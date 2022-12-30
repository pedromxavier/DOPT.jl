mutable struct Job
    method::MetaHeuristic
    params::Dict{Symbol,Any}
    path::String
    index::Integer
    num_samples::Integer
    sizes::Vector{Int}
    codes::Vector{Int}

    function Job(
        method,
        params::Dict{Symbol,Any},
        path::Union{AbstractString,Nothing} = nothing,
        index::Union{Integer,Nothing} = nothing;
        num_samples::Integer = 1,
        sizes::Vector = INSTANCE_SIZES,
        codes::Vector = INSTANCE_CODES,
    )
        if isnothing(path)
            path = results_path()
        end

        if isnothing(index)
            index = get_next_job_index(path)
        end

        job = new(method, params, path, index, num_samples, sizes, codes)

        mkpath(job_path(job))

        open(joinpath(job_path(job), ".gitignore"), "w") do fp
            println(fp, "*")
        end

        mkpath(series_path(job))

        return job
    end
end

function job_path(job::Job)
    return abspath(joinpath(job.path, "job-$(job.index)"))
end

function series_path(job::Job)
    return abspath(joinpath(job_path(job), "series"))
end

function series_path(job::Job, n::Integer, i::Integer, k::Integer)
    return abspath(joinpath(series_path(job), "$(n)_$(i).$(k).csv"))
end

function metadata_path(job::Job)
    return abspath(joinpath(job_path(job), "metadata.json"))
end

function results_path(job::Job)
    return abspath(joinpath(job_path(job), "results.csv"))
end