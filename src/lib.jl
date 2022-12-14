function objval(A::Matrix{T}, x::Vector{T}) where {T}
    x, s = logabsdet(A' * spdiagm(x) * A)

    return ifelse(s < zero(T), -Inf, x)
end

@doc raw"""
    read_instance(n::Integer, i::Integer)
    read_instance(n::Integer, i::Integer, matrix_name::Symbol)

## Example
```julia
julia> A, R = read_instance(200, 2);
```

or

```julia
julia> A = read_instance(200, 2, :A);

julia> R = read_instance(200, 2, :R);
```
""" function read_instance end

function read_instance(filename::AbstractString, matrix_name::String)
    path = joinpath(INSTANCES_PATH, "$(filename).mat")

    M = matopen(path) do fp
        return read(fp, matrix_name)
    end

    return M
end

function read_instance(n::Integer, i::Integer, matrix_name::String)
    return read_instance("Instance_$(n)_$(i)", matrix_name)
end

read_instance(n::Integer, i::Integer, key::Symbol) = read_instance(n, i, Val(key))
read_instance(n::Integer, i::Integer, ::Val{:A})   = read_instance(n, i, "A")
read_instance(n::Integer, i::Integer, ::Val{:R})   = trunc.(Int, vec(read_instance(n, i, "R")))

function read_instance(n::Integer, i::Integer)
    A = read_instance(n, i, :A)
    R = read_instance(n, i, :R)

    return (A, R)
end