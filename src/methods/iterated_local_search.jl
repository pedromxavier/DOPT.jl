"""

Iterated Local Search
"""
struct IteratedLocalSearch{LS<:LocalSearch} <: MetaHeuristic end

IteratedLocalSearch() = IteratedLocalSearch{DeterministicLocalSearch{FirstImprovement}}()

"""
    solve(::IteratedLocalSearch, A::Matrix{T}, x̄::Vector{T}, z̄::T) where {T}

Performs an Iterated Local Search (IteratedLocalSearch) starting with `x`.
"""
function solve(
    ::IteratedLocalSearch{LS},
    A::Matrix{T},
    x̄::Vector{U},
    z̄::T;
    nthreads::Integer                   = 1,
    num_swaps::Integer                  = 3,
    max_temp::Float64                   = 0.0,
    max_iter::Integer                   = 1_000,
    max_time::Union{Float64,Nothing}    = nothing,
    max_subiter::Union{Integer,Nothing} = nothing,
    max_subtime::Union{Float64,Nothing} = nothing,
    params...,
) where {T,U,LS<:LocalSearch}
    V = build_buffer(A)
    R = [Report{T,U}(max_iter) for _ = 1:nthreads]

    Threads.@threads for i = 1:nthreads
        r = R[i]

        x̂, ẑ = x⃰, z⃰ = add_solution!(r, x̄, z̄)

        while !stop(r.num_iter, max_iter, time(r), max_time)
            x = shake(x̂, num_swaps)
            z = objval(A, x)

            x, z, ns = solve(LS(), A, V, x, z; max_iter = max_subiter, max_time = max_subtime)

            Δ = z - ẑ

            if Δ >= zero(T)
                x̂, ẑ = x, z # Accept

                if ẑ > z⃰
                    x⃰, z⃰ = add_solution!(r, x̂, ẑ)
                end
            elseif rand() < exp(Δ / max_temp)
                x̂, ẑ = x, z # Accept
            end

            r.num_iter    += 1
            r.num_subiter += ns
        end
    end

    i = argmax(r.z[end] for r in R)

    return R[i]
end

function print_header(
    method::IteratedLocalSearch;
    max_iter,
    max_subiter,
    max_time,
    nthreads,
    params...,
)
    print("""
          * $(method)
          * max_iter    = $(max_iter)
          * max_subiter = $(max_subiter)
          * max_time    = $(max_time)
          * nthreads    = $(nthreads)
          """)

    return nothing
end

function Base.show(io::IO, ::IteratedLocalSearch{S}) where {S<:LocalSearch}
    print(io, "Iterated Local Search: $(S())")
end

const ILS = IteratedLocalSearch