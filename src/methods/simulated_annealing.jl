abstract type AnnealingSchedule end

"""
"""
struct LinearSchedule <: AnnealingSchedule end

Base.show(io::IO, ::Type{LinearSchedule}) = print(io, "Linear Schedule")

function generate_schedule(
    ::LinearSchedule;
    max_iter::Integer = 1000,
    max_temp::Float64 = 10.0,
    min_temp::Float64 = 1e-3,
)
    #   T(i) = T(1) + α * (i - 1)
    # ⟹ α = [T(i) - T(1)] / (i - 1)
    α = (min_temp - max_temp) / (max_iter - 1)
    τ = Vector{Float64}(undef, max_iter)

    for i = 1:max_iter
        τ[i] = max_temp + α * (i - 1)
    end

    return τ
end

"""
"""
struct GeometricSchedule <: AnnealingSchedule end

Base.show(io::IO, ::Type{GeometricSchedule}) = print(io, "Geometric Schedule")

function generate_schedule(
    ::GeometricSchedule;
    max_iter::Integer = 1000,
    max_temp::Float64 = 10.0,
    min_temp::Float64 = 1e-3,
)
    #   αⁱ⁻¹ T(1) = T(i) 
    # ⟹ αⁿ⁻¹      = T(n) / T(1)
    # ⟹ α         = (T(n) / T(1)) ^ (1 / (n - 1))
    α = (min_temp / max_temp) ^ inv(max_iter - 1)
    τ = Vector{Float64}(undef, max_iter)

    for i = 1:max_iter
        τ[i] = max_temp * α^(i - 1)
    end

    return τ
end

"""
"""
struct ReverseSchedule{S<:AnnealingSchedule} end

Base.show(io::IO, ::Type{ReverseSchedule{S}}) where {S} = print(io, "Reverse($S)")

ReverseSchedule() = ReverseSchedule{GeometricSchedule}()

function generate_schedule(
    ::ReverseSchedule{S};
    max_iter::Integer = 1000,
    max_temp::Float64 = 10.0,
    min_temp::Float64 = 1e-3,
    ) where {S<:AnnealingSchedule}

    τ = generate_schedule(
        S();
        max_iter = max_iter ÷ 2,
        max_temp = max_temp,
        min_temp = min_temp,
    )

    return [reverse(τ);τ]
end

"""

Simulated Annealing
"""
struct SimulatedAnnealing{S<:AnnealingSchedule} <: MetaHeuristic end

SimulatedAnnealing() = SimulatedAnnealing{GeometricSchedule}()

"""
    solve(::SimulatedAnnealing, A::Matrix{T}, x̄::Vector{T}, z̄::T; schedule::Vector{Float64}) where {T}

"""
function solve(
    method::SimulatedAnnealing{S},
    A::Matrix{T},
    x̄::Vector{T},
    z̄::T;
    max_iter::Integer = 1000,
    max_temp::Float64 = 10.0,
    min_temp::Float64 = 1e-3,
    params...,
) where {T,S<:AnnealingSchedule}
    schedule = generate_schedule(
        S();
        max_iter = max_iter,
        max_temp = max_temp,
        min_temp = min_temp,
    )
    return solve(
        method,
        A,
        x̄,
        z̄,
        schedule;
        max_iter = max_iter,
        params...
    )
end

function solve(
    ::SimulatedAnnealing,
    A::Matrix{T},
    x̄::Vector{U},
    z̄::T,
    schedule::Vector{Float64};
    max_iter::Integer                   = 1_000,
    max_time::Union{Float64,Nothing}    = nothing,
    max_subiter::Integer                = 1_000,
    max_subtime::Union{Float64,Nothing} = nothing,
    params...,
) where {T,U}
    x⃰, z⃰ = copy(x̄), z̄ # Best solution so far
    x̂, ẑ = copy(x̄), z̄ # Accepted solution

    X = objmatrix(A, x̂)
    V = build_buffer(A)
    r = Report{T}(x̄, z̄, max_iter)

    start!(r)

    for τ in schedule
        init_subtime = time()

        for _ = 1:max_subiter
            i, j = find_walk(x̂)

            swap!(X, V, i, j)

            z = objval(X)
            Δ = z - ẑ

            if Δ >= zero(T) # Improvement
                # Accept solution
                swap!(x̂, i, j)

                ẑ = z
            
                if ẑ > z⃰
                    x⃰, z⃰ = add_solution!(r, x̂, ẑ)
                end
            elseif rand() < exp(Δ / τ) # Probabilistic criteria
                # Accept solution
                swap!(x̂, i, j)
                ẑ = z
            else # Reject solution
                # Undo
                swap!(X, V, j, i)
            end

            r.num_subiter += 1
            run_subtime = time() - init_subtime

            stop(run_subtime, max_subtime) && break
        end

        r.num_iter += 1
        run_time = time() - r.init_time

        stop(r.num_iter, max_iter, run_time, max_time) && break
    end

    return r
end

function print_header(
    method::SimulatedAnnealing;
    max_iter,
    max_time,
    max_temp,
    min_temp,
    params...
)
    print(
        """
        * $(method_summary(method; params...))
        * max_iter = $(max_iter)
        * max_time = $(max_time)
        * max_temp = $(max_temp)
        * min_temp = $(min_temp)
        """
    )

    return nothing
end

function method_summary(::SimulatedAnnealing{S}; params...) where {S}
    return "Simulated Annealing: $S"
end