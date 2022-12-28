const DATA_PATH = joinpath(@__DIR__, "..", "..", "data")

function data_path(path::String...)
    return abspath(joinpath(DATA_PATH, path...))
end

function instances_path(path::String...)
    return data_path("instances", path...)
end

function results_path(path::String...)
    return data_path("results", path...)
end
