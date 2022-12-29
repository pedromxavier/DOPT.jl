mutable struct Job
    path::String
    run_index::Integer
    run_path::String
    series_path::String
    series_fp::IO
    results_path::String
    results_fp::IO
    metadata_path::String

    function Job(
        path::AbstractString = results_path(),
        run_index::Integer = get_next_run_index(path)
    )

        return new(
            path,
            run_index,
            run_path,
        )
    end
end

function save(
    path::AbstractString,
    run_index::Integer,
    n::Integer,
    i::Integer,
    k::Integer,
    z⃗::Vector{T},
    t⃗::Vector{Float64},
) where {T}
    file_path = series_path(run_index, n, i, k; base_path=path)

    open(file_path, "a") do fp

end


function get_next_run_index(path::AbstractString)
    match_list = match.(r"^run-([0-9]+)$", filter(isdir, readdir(path)))
    index_list = getindex.(filter(!isnothing, match_list), 1)

    return maximum(filter(!isnothing, tryparse.(Int, index_list)); init = 0) + 1
end