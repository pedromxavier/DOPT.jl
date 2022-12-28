@doc raw"""
    objmatrix(A::Matrix{T}, x::Vector{U}) where {T,U}

Computes ``X = A' \cdot diag(x) \cdot A``.

Since ``A \in \mathbb{R}^{m \times n}`` and ``x \in \mathbb{R}^{m}``,
the resulting matrix ``X`` will have dimensions ``n \times n``.
"""
function objmatrix(A::Matrix{T}, x::Vector{U}) where {T,U}
    return A' * spdiagm(x) * A
end

function objval(A::Matrix{T}, x::Vector{U}) where {T,U}
    return objval(objmatrix(A, x))
end

function objmatrix(V::Array{T,3}, x::Vector{U}) where {T,U}
    m = length(x)
    X = sum(V[i, :, :] for i = 1:m if !iszero(x[i]))

    return X
end

function objval(V::Array{T,3}, x::Vector{U}) where {T,U}
    return objval(objmatrix(V, x))
end

function objval(X::Matrix{T}) where {T}
    z, s = logabsdet(X)

    return ifelse(s < 0.0, -Inf, z)
end

function build_buffer(A::Matrix{T}) where {T}
    m, n = size(A)

    V = Array{T,3}(undef, m, n, n)

    for i = 1:m
        v = @view(A[i, :])

        V[i, :, :] .= v * v'
    end

    return V
end