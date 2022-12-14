# DOPT.jl

# Installation
```julia
julia> using Pkg

julia> Pkg.add(url=raw"https://github.com/pedromxavier/DOPT.jl")
```

# Updating Best Solutions
1. [Fork](https://github.com/pedromxavier/DOPT.jl/fork) this repository.
2. Rewrite the [results.json](./data/results/results.json) file with your own results.
3. Open a [Pull Request](https://github.com/pedromxavier/DOPT.jl/pulls) and wait for the workflow to run.

The `results.json` file must look like this:
```
[
    {
        "n" : 40,
        "i" : 1,
        "x" : [1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0]
    },
    {
        "n" : 40,
        "i" : 2,
        "x" : [1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0]
    },
    {
        "n" : 40,
        "i" : 3,
        "x" : [1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0]
    },
    ...
]
```
It must contain an array of results, each identified by the `"n"` and `"i"` fields (instance size and instance no.), followed by the `"x"` entry containing the (binary) solution vector.
