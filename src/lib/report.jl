# m : Number of 'experiments'
# n : Length of each 'experiment'

mutable struct Report{T,U}
    x::Vector{Vector{U}} # ≤max_iter × m
    z::Vector{T}         # ≤max_iter
    t::Vector{Float64}   # ≤max_iter
    init_time::Union{Float64,Nothing}
    num_iter::Int
    num_subiter::Int

    function Report{T,U}(max_iter::Union{Integer,Nothing} = nothing) where {T,U}
        max_iter = something(max_iter, 1_000)

        x = sizehint!(Vector{U}[], max_iter)
        z = sizehint!(T[], max_iter)
        t = sizehint!(Float64[], max_iter)

        return new{T,U}(x, z, t, nothing, 0, 0)
    end
end

function add_solution!(r::Report{T}, x::Vector{U}, z::T) where {T,U}
    if isnothing(r.init_time)
        r.init_time = time()
    end

    t = time() - r.init_time
    x = copy(x)

    push!(r.t, t)
    push!(r.z, z)
    push!(r.x, x)

    return (x, z)
end