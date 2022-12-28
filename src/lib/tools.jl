@inline function swap!(x::Vector{U}, i::Integer, j::Integer) where {U}
    x[i], x[j] = x[j], x[i]

    return nothing
end

function swap!(X::Matrix{T}, V::Array{T,3}, i::Integer, j::Integer) where {T}
    X .+= @view(V[j,:,:]) .- @view(V[i,:,:])

    return nothing
end

@inline stop(num_iter::Integer, max_iter::Integer) = num_iter >= max_iter
@inline stop(run_time::Float64, max_time::Float64) = run_time >= max_time
@inline stop(::Integer, ::Nothing) = false
@inline stop(::Float64, ::Nothing) = false

@inline function stop(
    num_iter::Integer,
    max_iter::Union{Integer,Nothing},
    run_time::Float64,
    max_time::Union{Float64,Nothing},
)
    return stop(num_iter, max_iter) || stop(run_time, max_time)
end

@inline function shake(x::Vector{T}) where {T}
    return shuffle(x)
end

@inline function shake!(x::Vector{T}) where {T}
    return shuffle!(x)
end

function shake(x::Vector{T}, k::Integer) where {T}
    return shake!(copy(x), k)
end

function shake!(x::Vector{T}, k::Integer) where {T}
    for _ = 1:k
        i, j = find_walk(x)

        swap!(x, i, j)
    end

    return x
end

function find_walk(x::Vector{T}) where {T}
    n = length(x)
    i = rand(1:n)
    j = nothing

    while true
        j = rand(1:n)

        if iszero(x[i]) ⊻ iszero(x[j])
            break
        end
    end

    return ifelse(iszero(x[i]), (j, i), (i, j))
end

@doc raw"""
```math
\begin{align*}
    z       &= \log\det A' \cdot diagm(x) \cdot A \\
    \bar{z} &= \log\det A' \cdot diagm(\bar{x}) \cdot A
\end{align*}
```

```math
\begin{align*}
    z - \bar{z} &= \log\det A' \cdot diagm(x) \cdot A - \log\det A' \cdot diagm(\bar{x}) \cdot A \\
                &= \log\frac{\det A' \cdot diagm(x) \cdot A}{\det A' \cdot diagm(\bar{x}) \cdot A} \\
                &= \log
                \left[
                    \det \left(A' \cdot diagm(x) \cdot A\right)
                    \cdot
                    \det \left(A' \cdot diagm(\bar{x}) \cdot A\right)^{-1}
                \right] \\
                &= \log\det
                \left[
                    \left(A' \cdot diagm(x) \cdot A\right) \cdot \left(A' \cdot diagm(\bar{x}) \cdot A\right)^{-1}
                \right]
\end{align*}
```
""" function gap end

function gap(z::T, z̄::T) where {T}

end