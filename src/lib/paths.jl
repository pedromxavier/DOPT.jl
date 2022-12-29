const DATA_PATH = joinpath(@__DIR__, "..", "..", "data")

function data_path(path::AbstractString...; base_path::AbstractString=DATA_PATH)
    return abspath(joinpath(base_path, path...))
end

function instances_path(path::AbstractString...; base_path::AbstractString=DATA_PATH)
    return data_path("instances", path...; base_path)
end

function results_path(path::AbstractString...; base_path::AbstractString=DATA_PATH)
    return data_path("results", path...; base_path)
end

function run_path(index::Integer)

end

function benchmark_path(path::String...)
    return data_path("benchmark", path...)
end
