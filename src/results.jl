function update_optimal!(;
    author::Union{String,Nothing} = nothing,
)
    results_json_path = joinpath(RESULTS_PATH, "results.json")
    optimal_json_path = joinpath(RESULTS_PATH, "optimal.json")
    optimal_csv_path  = joinpath(RESULTS_PATH, "optimal.csv")

    if !isfile(results_json_path)
        error("'results.json' file is missing!")
    end

    results_data = JSON.parsefile(results_json_path)::Vector
    optimal_data = JSON.parsefile(optimal_json_path)::Dict

    for result::Dict in results_data
        n = haskey(result, "n") ? result["n"]::Int          : error("missing 'n' entry (problem size)")
        i = haskey(result, "i") ? result["i"]::Int          : error("missing 'i' entry (instance code)")
        x = haskey(result, "x") ? Int.(result["x"]::Vector) : error("missing 'x' entry (solution vector)")

        if n ∉ INSTANCE_SIZES || i ∉ [1, 2, 3]
            @warn "Invalid instance '($n, $i)', skipping"
            continue
        end

        A = read_instance(n, i, :A)::Matrix{Float64}
        z = objval(A, float(x))::Float64

        if !isfinite(z)
            @warn "Unbounded objective value '$z', skipping"
            continue
        end

        n̂ = string(n)
        î = string(i)

        if !haskey(optimal_data, n̂)
            optimal_data[n̂] = Dict{String,Any}()
        end

        if !haskey(optimal_data[n̂], î)
            optimal_data[n̂][î] = Dict{String,Any}(
                "x"      => x,
                "z"      => z,
                "author" => author,
            )

            continue
        end
        
        z⃰ = optimal_data[n̂][î]["z"]

        if z > z⃰
            optimal_data[n̂][î]["z"]      = z
            optimal_data[n̂][î]["x"]      = x
            optimal_data[n̂][î]["author"] = author
        end
    end

    # Write JSON
    open(optimal_json_path, "w") do fp
        JSON.print(fp, optimal_data)
    end

    csv_results = []

    # Write CSV
    for n̂ in keys(optimal_data)
        n = parse(Int, n̂)
        for î in keys(optimal_data[n̂])
            i = parse(Int, î)
            z = float(optimal_data[n̂][î]["z"])
            author = something(optimal_data[n̂][î]["author"], missing)

            push!(csv_results, (n, i, z, author))
        end
    end

    CSV.write(optimal_csv_path, sort(csv_results), header = ["n", "i", "z", "author"])     

    return nothing
end
