@doc raw"""
    MetaHeuristic

The abstract class for defining new solution methods, to be used for
triggering multiple dispatch over [`solve`](@ref) and [`init`](@ref)
"""
abstract type MetaHeuristic end

@doc raw"""
    solve(::MetaHeuristic, A::Matrix{T}, s::Integer; params...) where {T}
    solve(::MetaHeuristic, A::Matrix{T}, R::Vector{Int}, s::Integer; params...) where {T}

Solves the Determinant-Optimality problem for a given matrix ``A \in \mathbb{R}^{m \times n}``.
"""
function solve end

@doc raw"""
    init(::MetaHeuristic, A::Matrix{T})
"""
function init end