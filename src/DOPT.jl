module DOPT

using CSV
using MAT
using JSON
using Random
using LinearAlgebra
using SparseArrays

export objval, read_instance

# ~*~ Interface ~*~ #
include("interface/interface.jl")
include("interface/generic.jl")

# ~*~ Library Includes ~*~ #
include("lib/paths.jl")
include("lib/tools.jl")
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

end # module DOPT
