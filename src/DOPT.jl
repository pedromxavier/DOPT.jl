module DOPT

using CSV
using MAT
using JSON
using LinearAlgebra
using SparseArrays
using LoopVectorization

export objval, read_instance

const DATA_PATH      = joinpath(@__DIR__, "..", "data")
const RESULTS_PATH   = joinpath(DATA_PATH, "results")
const INSTANCES_PATH = joinpath(DATA_PATH, "instances")
const INSTANCE_SIZES = [40, 60, 80, 100, 140, 180, 200, 240, 280, 300]

include("lib.jl")
include("results.jl")

end # module DOPT
