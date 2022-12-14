mutable struct Job
    method::MetaHeuristic
    params::Dict{Symbol,Any}
    path::String
    index::UUID
    num_samples::Integer
    sizes::Vector{Int}
    codes::Vector{Int}

    function Job(
        method,
        params::Dict{Symbol,Any},
        path::Union{AbstractString,Nothing} = nothing;
        num_samples::Integer = 1,
        sizes::Vector = INSTANCE_SIZES,
        codes::Vector = INSTANCE_CODES,
    )
        if isnothing(path)
            path = results_path()
        end

        index = uuid4()

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

@doc raw"""
""" function create_job end

function create_job(path::AbstractString)
    data = TOML.parsefile(path)

    data
end

function extract_ttt(job::Job)
    path = series_path(job)

    for n = job.sizes, i = job.codes
        z = read_benchmark(n, i)

        src_path = joinpath(path, "$(n)_$(i).*.csv")
        out_path = joinpath(path, "$(n)_$(i).dat")
        Base.run(`tttplots-extract $z -o $out_path $src_path`)
    end

    return nothing
end