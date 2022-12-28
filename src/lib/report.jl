# m : Number of 'experiments'
# n : Length of each 'experiment'

mutable struct Report{T,U}
    x::Vector{Vector{U}} # ≤max_iter × m
    z::Vector{T}         # ≤max_iter
    t::Vector{Float64}   # ≤max_iter
    init_time::Float64
    num_iter::Int
    num_subiter::Int

    function Report{T}(x̄::Vector{U}, z̄::T, max_iter::Union{Integer,Nothing} = nothing) where {T,U}
        max_iter = something(max_iter, 1_000)

        x = sizehint!(Vector{T}[copy(x̄)], max_iter)
        z = sizehint!(T[z̄], max_iter)
        t = sizehint!(Float64[0], max_iter)

        return new{T}(x, z, t, NaN, 0, 0)
    end
end

function start!(r::Report)
    r.init_time = time()

    return nothing
end

function add_solution!(r::Report{T}, x::Vector{T}, z::T) where {T}
    t = time() - r.init_time
    x = copy(x)

    push!(r.t, t)
    push!(r.z, z)
    push!(r.x, x)

    return (x, z)
end