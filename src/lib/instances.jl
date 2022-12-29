const INSTANCE_SIZES = [40, 60, 80, 100, 140, 180, 200, 240, 280, 300]
const INSTANCE_CODES = [1, 2, 3]

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

function read_instance(name::AbstractString, matrix_name::String)
    path = instances_path("$(name).mat")

    A = matopen(path) do fp
        read(fp, matrix_name)
    end

    return A
end

function read_instance(n::Integer, i::Integer, matrix_name::String)
    @assert n ∈ INSTANCE_SIZES && i ∈ INSTANCE_CODES

    return read_instance("Instance_$(n)_$(i)", matrix_name)
end

read_instance(n::Integer, i::Integer, key::Symbol) = read_instance(n, i, Val(key))
read_instance(n::Integer, i::Integer, ::Val{:A})   = read_instance(n, i, "A")
read_instance(n::Integer, i::Integer, ::Val{:R})   = trunc.(Int, vec(read_instance(n, i, "R")))
read_instance(n::Integer, ::Integer, ::Val{:s})    = n ÷ 2

@doc raw"""
    read_instance(n:Integer, i:Integer)

Retrieves ``A \in mathbb{R}^{m \times n}``, ``R \in \mathbb{Z}^{n}`` and ``s \in \mathbb{Z}``
for a given instance `(n, i)`.
"""
function read_instance(n::Integer, i::Integer)
    A = read_instance(n, i, :A)
    R = read_instance(n, i, :R)
    s = read_instance(n, i, :s)

    return (A, R, s)
end
