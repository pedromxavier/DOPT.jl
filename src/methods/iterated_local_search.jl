"""

Iterated Local Search
"""
struct IteratedLocalSearch <: MetaHeuristic end

"""
    solve(::IteratedLocalSearch, A::Matrix{T}, x̄::Vector{T}, z̄::T) where {T}

Performs an Iterated Local Search (IteratedLocalSearch) starting with `x`.
"""
function solve(
    ::IteratedLocalSearch,
    A::Matrix{T},
    x̄::Vector{T},
    z̄::T;
    nthreads::Integer                   = 1,
    num_swaps::Integer                  = 3,
    max_temp::Float64                   = 0.0,
    max_iter::Integer                   = 1_000,
    max_time::Union{Float64,Nothing}    = nothing,
    max_subiter::Union{Integer,Nothing} = nothing,
    max_subtime::Union{Float64,Nothing} = nothing,
    submethod::LocalSearch              = LocalSearchFI(),
    params...
) where {T}
    V = build_buffer(A)

    # Thread-wise data
    R = [Report{T}(x̄, z̄, max_iter) for _ = 1:nthreads]

    Threads.@threads for i = 1:nthreads
        r = R[i]

        run_time  = 0.0

        start!(r)

        x⃰, z⃰ = r.x, r.z[end] # 
        x̂, ẑ = x⃰, z⃰                # Accepted Solution

        while !stop(r.num_iter, max_iter, run_time, max_time)
            x = shake(x̂, num_swaps)
            z = objval(A, x)

            x, z, ns = solve(
                submethod,
                A, V, x, z;
                max_iter=max_subiter,
                max_time=max_subtime,
            )

            Δ = z - ẑ

            if Δ >= zero(T)
                x̂, ẑ = x, z # Accept

                if ẑ > z⃰
                    x⃰, z⃰ = add_solution!(r, x̂, ẑ)
                end
            elseif rand() < exp(Δ / max_temp)
                x̂, ẑ = x, z # Accept
            end

            r.num_subiter += ns
            r.num_iter    += 1
            run_time = time() - r.init_time
        end
    end

    i = argmax([r.z[end] for r in R])

    return R[i]
end

function print_header(method::DOPT.IteratedLocalSearch; max_iter, max_time, max_temp, nthreads, params...)
    print(
        """
        * $(method_summary(method; params...))
        * max_iter = $(max_iter)
        * max_time = $(max_time)
        * max_temp = $(max_temp)
        * nthreads = $(nthreads)
        """
    )
end

function method_summary(::DOPT.IteratedLocalSearch; submethod::DOPT.LocalSearch, params...)
    if submethod isa DOPT.LocalSearchFI
        return "Iterated Local Search: First Improvement"
    elseif submethod isa DOPT.LocalSearchFIP
        return "Iterated Local Search: First Improvement+"
    elseif submethod isa DOPT.LocalSearchFIP
        return "Iterated Local Search: Best Improvement"
    else
        return "Iterated Local Search: ?"
    end
end