struct PathRelinking <: MetaHeuristic end

function solve(::PathRelinking, A::Matrix{T}, x::Vector{U}, x̄::Vector{Vector{U}}) where {T,U}
    Δ = x .⊻ x̄



end