@doc raw"""
    solve(method::MetaHeuristic, A::Matrix{T}, R::Vector{K}, s::Integer; params...) where {T,K<:Integer}

Solves after initializing the solution with the S.V.D. heuristic.
"""
function solve(
    method::MetaHeuristic,
    A::Matrix{T},
    R::Vector{K},
    s::Integer;
    params...,
) where {T,K<:Integer}
    x̄ = init(method, A, R, s)

    return solve(method, A, x̄; params...)
end

function solve(method::MetaHeuristic, A::Matrix{T}, s::Integer; params...) where {T}
    x̄ = init(method, A, s)::Vector{T}

    return solve(method, A, x̄; params...)
end

function solve(method::MetaHeuristic, A::Matrix{T}, x̄::Vector{T}; params...) where {T}
    z̄ = objval(A, x̄)

    return solve(method, A, x̄, z̄; params...)
end

function init(::MetaHeuristic, A::Matrix{T}, R::Vector{K}, s::Integer) where {T,K<:Integer}
    m, n = size(A)
    U,   = svd(A; full = true)

    x̄ = vec(sum(U .^ 2; dims = 2))
    x = zeros(m)

    x[R] .= 1.0 # choose independent rows
    x̄[R] .= 0.0

    ϕ = partialsortperm(x̄, (1:s-n); rev = true)

    x[ϕ] .= 1.0

    @assert sum(round.(Int, x)) == s

    return x
end

function init(::MetaHeuristic, A::Matrix{T}, s::Integer) where {T}
    m = size(A, 1)

    return shuffle!(ifelse.(1:m .<= s, one(T), zero(T)))
end