mutable struct Job
    method::MetaHeuristic
    params::Dict{Symbol,Any}
    path::String
    index::Integer
    num_samples::Integer

    function Job(
        method,
        params::Dict{Symbol,Any},
        path::Union{AbstractString,Nothing} = nothing,
        index::Union{Integer,Nothing} = nothing;
        num_samples::Integer = 1,
    )
        if isnothing(path)
            path = results_path()
        end

        if isnothing(index)
            index = get_next_run_index(path)
        end

        return new(
            method,
            params,
            path,
            index,
            num_samples
        )
    end
end