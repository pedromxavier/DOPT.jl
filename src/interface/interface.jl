@doc raw"""
    MetaHeuristic

The abstract class for defining new solution methods, to be used for
triggering multiple dispatch over [`solve`](@ref) and [`init`](@ref)
"""
abstract type MetaHeuristic end

@doc raw"""
    solve(::MetaHeuristic, A::Matrix{T}, s::Integer, args...; params...) where {T}
    solve(::MetaHeuristic, A::Matrix{T}, R::Vector{Int}, s::Integer, args...; params...) where {T}

Solves the Determinant-Optimality problem for a given matrix ``A \in \mathbb{R}^{m \times n}``.
"""
function solve end

@doc raw"""
    init(A::Matrix{T})
    init(A::Matrix{T}, R::Matrix{T})
    init(::MetaHeuristic, A::Matrix{T})
    init(::MetaHeuristic, A::Matrix{T}, R::Matrix{T})
"""
function init end

@doc raw"""
    run(method::MetaHeuristic; params...)    
    run(path::AbstractString, method::MetaHeuristic; params...)

Runs all problem instances with a given `method`, saving results to `path`.
"""
function run end

@doc raw"""
    save(path::AbstractString)
"""
function save end