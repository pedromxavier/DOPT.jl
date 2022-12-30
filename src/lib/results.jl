@doc raw"""
"""
function get_author()
    return get(ENV, "DOPT_AUTHOR", nothing)
end

@doc raw"""
    read_solution(n::Integer, i::Integer)
"""
function read_solution(n::Integer, i::Integer)
    return read_solution(string(n), string(i))
end

function read_benchmark(n::Integer, i::Integer)
    df = CSV.read(benchmark_path("benchmark_results.csv"), DataFrame)

    z = nothing

    for row in eachrow(df)
        if row.n == n && row.i == i
            z = row.LS
            break
        end
    end

    return z
end

function read_solution(n::String, i::String)
    data = JSON.parsefile(results_path("solution.json"); use_mmap=false)

    if haskey(data, n) && haskey(data[n], i)
        sol = data[n][i]

        x = uncompress(sol["x"])
        z = float(sol["z"])

        return (x, z)
    else
        return (nothing, nothing)
    end
end

function update_solution!(
    n::String,
    i::String,
    x::Vector{U},
    z::T;
    author::Union{String,Nothing} = get_author(),
) where {T,U<:Integer}
    path = results_path("solution.json")
    data = JSON.parsefile(path; use_mmap=false)

    if !haskey(data, n)
        data[n] = Dict{String,Any}()
    end

    if !haskey(data[n], i)
        data[n][i] = Dict{String,Any}("x" => nothing, "z" => nothing, "author" => nothing)
    end

    data[n][i]["x"]      = compress(Int.(x))
    data[n][i]["z"]      = float(z)
    data[n][i]["author"] = author

    open(path, "w") do fp
        JSON.print(fp, data, 4)
    end

    return nothing
end

function update_solution!(
    n::Integer,
    i::Integer,
    x::Vector{U};
    author::Union{String,Nothing} = get_author(),
) where {U}
    x = round.(Int, x)
    A = read_instance(n, i, :A)
    z = objval(A, x)
    _, z̄ = read_solution(n, i)

    if (isnothing(z̄) && isfinite(z)) || (z > z̄)
        update_solution!(string(n), string(i), x, z; author = author)

        return z
    else
        return z̄
    end
end

function update_solution!(; author::Union{String,Nothing} = get_author())
    if !isfile(results_path("results.json"))
        error("The 'results.json' file is missing")
    end

    results = JSON.parsefile(results_path("results.json"); use_mmap=false)

    if !(results isa Vector)
        error("'results.json' must hold a vector of dictionaries")
    end

    for result in results
        if !(result isa Dict)
            error("'results.json' must hold a vector of dictionaries")
        end

        if !haskey(result, "n") || !(result["n"] isa Integer)
            error("missing integer 'n' (problem size)")
        end

        if !haskey(result, "i") || !(result["i"] isa Integer)
            error("missing integer 'i' (problem code)")
        end

        if !haskey(result, "x") || !(result["x"] isa Vector)
            error("missing binary vector 'x' (solution)")
        end

        n = Int(result["n"])
        i = Int(result["i"])
        x = Int.(result["x"])

        if n ∉ INSTANCE_SIZES || i ∉ INSTANCE_CODES
            @warn "Invalid instance '($n, $i)', skipping"
            continue
        end

        update_solution!(n, i, x; author = author)
    end

    csv_results   = []
    solution_data = JSON.parsefile(results_path("solution.json"); use_mmap=false)

    # Write CSV
    for n in keys(solution_data)
        for i in keys(solution_data[n])
            z      = float(solution_data[n][i]["z"])
            author = something(solution_data[n][i]["author"], missing)

            push!(csv_results, (parse(Int, n), parse(Int, i), z, author))
        end
    end

    CSV.write(
        results_path("solution.csv"),
        sort(csv_results),
        header = ["n", "i", "z", "author"],
    )

    return nothing
end
