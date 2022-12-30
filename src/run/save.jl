function save!(
    job::Job,
    n::Integer,
    i::Integer,
    k::Integer,
    z⃗::Vector{T},
    t⃗::Vector{Float64},
) where {T}
    path = series_path(job, n, i, k)

    open(path, "w") do fp
        for (z, t) in zip(z⃗, t⃗)
            println(fp, "$(z),$(t)")
        end
    end

    return nothing
end


function get_next_job_index(path::AbstractString)
    match_list = match.(r"^job-([0-9]+)$", filter(isdir, readdir(path)))
    index_list = getindex.(filter(!isnothing, match_list), 1)

    return maximum(filter(!isnothing, tryparse.(Int, index_list)); init = 0) + 1
end