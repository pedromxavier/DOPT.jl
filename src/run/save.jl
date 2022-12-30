function save(
    path::AbstractString,
    run_index::Integer,
    n::Integer,
    i::Integer,
    k::Integer,
    z⃗::Vector{T},
    t⃗::Vector{Float64},
) where {T}

end


function get_next_run_index(path::AbstractString)
    match_list = match.(r"^run-([0-9]+)$", filter(isdir, readdir(path)))
    index_list = getindex.(filter(!isnothing, match_list), 1)

    return maximum(filter(!isnothing, tryparse.(Int, index_list)); init = 0) + 1
end