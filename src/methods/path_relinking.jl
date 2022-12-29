abstract type RelinkingMode end

@doc raw"""
    PathRelinking{M<:RelinkingMode} <: MetaHeuristic
"""
struct PathRelinking{M<:RelinkingMode} <: MetaHeuristic end

function solve(
    method::PathRelinking{M},
    A::Matrix{T},
    X̄::Vector{Vector{U}},
    Z̄::Vector{T},
) where {T,U,M<:RelinkingMode}
    n = length(X̄)
    x⃰ = copy(X̄[end])
    z⃰ = Z̄[end]

    for i = 1:n, j = (i+1):n
        x, z = solve(method, A, X̄[j], Z̄[j], X̄[i])

        if z > z⃰
            x⃰ .= x
            z⃰  = z
        end
    end

    return (x⃰, z⃰)
end

@doc raw"""
"""
struct ForwardRelinking <: RelinkingMode end

function solve(
    ::PathRelinking{ForwardRelinking},
    A::Matrix{T},
    x̄::Vector{U},
    z̄::T,
    x::Vector{U};
    params...
) where {T,U}
    x̂ = copy(x)
    x⃰ = copy(x)
    z⃰ = z̄
    n = hamming_distance(x̂, x̄) ÷ 2

    while n > 0
        i, j = find_walk(A, x̂, x̄)

        swap!(x̂, i, j)

        ẑ = objval(A, x̂)

        if ẑ > z⃰
            x⃰ .= x̂
            z⃰  = ẑ
        end

        n -= 1
    end

    return (x⃰, z⃰)
end

@doc raw"""
"""
struct BackwardRelinking <: RelinkingMode end

function solve(
    ::PathRelinking{BackwardRelinking},
    A::Matrix{T},
    x̄::Vector{U},
    z̄::T,
    x::Vector{U};
    params...
) where {T,U}
    return solve(PathRelinking{ForwardRelinking}(), A, x, z̄, x̄)
end

@doc raw"""
    DuplexRelinking <: RelinkingMode
"""
struct DuplexRelinking <: RelinkingMode end

function solve(
    ::PathRelinking{DuplexRelinking},
    A::Matrix{T},
    x̄::Vector{U},
    z̄::T,
    x::Vector{U};
    params...
) where {T,U}
    x̂ = copy(x)
    x̌ = copy(x̄)

    x⃰ = copy(x)
    z⃰ = z̄
    n = hamming_distance(x̂, x̌) ÷ 2

    while n > 0
        if n % 2 == 0
            i, j = find_walk(A, x̂, x̌)

            swap!(x̂, i, j)

            z = objval(A, x̂)

            if z > z⃰
                x⃰ .= x̂
                z⃰  = z
            end
        else
            i, j = find_walk(A, x̌, x̂)

            swap!(x̌, i, j)

            z = objval(A, x̌)

            if z > z⃰
                x⃰ .= x̌
                z⃰  = z
            end
        end

        n -= 1
    end

    return (x⃰, z⃰)
end

@doc raw"""
    find_walk(A::Matrix{T}, x::Vector{U}, x̄::Vector{U}) where {T,U}

To be used with [`PathRelinking`](@ref).
"""
function find_walk(A::Matrix{T}, x::Vector{U}, x̄::Vector{U}) where {T,U}
    m       = length(x)
    z⃰, i⃰, j⃰ = T(-Inf), 1, 1

    for i = 1:m, j = (i+1):m
        if (x[i] - x̄[i]) * (x[j] - x̄[j]) < zero(T)
            swap!(x, i, j)

            z = objval(A, x)

            swap!(x, i, j)

            if z > z⃰
                z⃰, i⃰, j⃰ = z, i, j                
            end
        end
    end

    return (i⃰, j⃰)
end

function hamming_distance(x::Vector{T}, y::Vector{T}) where {T}
    s = 0

    for i = eachindex(x)
        s += ifelse(x[i] ≈ y[i], 0, 1)
    end

    return s
end