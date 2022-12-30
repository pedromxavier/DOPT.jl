module DOPT

using CSV
using DataFrames
using Dates
using JSON
using LinearAlgebra
using MAT
using Printf
using Random
using SparseArrays
using Statistics
using TOML
using UUIDs

export objval, read_instance

# ~*~ Interface ~*~ #
include("interface/interface.jl")
include("interface/generic.jl")

# ~*~ Library Includes ~*~ #
include("lib/paths.jl")
include("lib/tools.jl")
include("lib/report.jl")
include("lib/compress.jl")
include("lib/objective.jl")
include("lib/instances.jl")
include("lib/results.jl")

# ~*~ Solution Methods ~*~ #
include("methods/ant_colony.jl")
include("methods/local_search.jl")
include("methods/iterated_local_search.jl")
include("methods/simulated_annealing.jl")
include("methods/path_relinking.jl")

# ~*~ Running Utils ~*~ #
include("run/job.jl")
include("run/run.jl")
include("run/print.jl")
include("run/save.jl")

end # module DOPT
