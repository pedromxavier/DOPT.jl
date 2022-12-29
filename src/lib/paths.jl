const DATA_PATH = joinpath(@__DIR__, "..", "..", "data")

function data_path(path::AbstractString...; base_path::AbstractString = DATA_PATH)
    return abspath(joinpath(base_path, path...))
end

function instances_path(path::AbstractString...; base_path::AbstractString = DATA_PATH)
    return data_path("instances", path...; base_path)
end

function results_path(path::AbstractString...; base_path::AbstractString = DATA_PATH)
    return data_path("results", path...; base_path)
end

function run_path(run_index::Integer; base_path::AbstractString = results_path())
    return abspath(joinpath(base_path, "run-$(run_index)"))
end

function series_path(run_index::Integer; base_path::AbstractString = results_path())
    return abspath(joinpath(run_path(run_index; base_path = base_path), "series"))
end

function series_path(
    run_index::Integer,
    n::Integer,
    i::Integer,
    k::Integer;
    base_path::AbstractString = results_path(),
)
    return abspath(
        joinpath(series_path(run_index; base_path = base_path), "$(n)_$(i).$(k).csv"),
    )
end
