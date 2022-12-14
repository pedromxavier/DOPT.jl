module DOPT

using JSON
using LinearAlgebra
using SparseArrays
using LoopVectorization

export objval, read_instance

const DATA_PATH      = joinpath(@__DIR__, "..", "data")
const RESULTS_PATH   = joinpath(DATA_PATH, "results")
const INSTANCES_PATH = joinpath(DATA_PATH, "instances")

include("lib.jl")
include("results.jl")

end # module DOPT
