function update_optimal!(;
    author::Union{String,Nothing} = nothing,
)
    results_path = joinpath(RESULTS_PATH, "results.json")
    optimal_path = joinpath(RESULTS_PATH, "optimal.json")

    if !isfile(results_path)
        error("'results.json' file is missing!")
    end

    results_data = JSON.parsefile(results_path)::Vector
    optimal_data = JSON.parsefile(optimal_path)::Dict

    for result::Dict in results_data
        n = haskey(result, "n") ? result["n"]::Int          : error("missing 'n' entry (problem size)")
        i = haskey(result, "i") ? result["i"]::Int          : error("missing 'i' entry (instance code)")
        x = haskey(result, "i") ? Int.(result["x"]::Vector) : error("missing 'x' entry (solution vector)")

        A = read_instance(n, i, :A)::Matrix{Float64}
        z = objval(A, float(x))::Float64

        if !isfinite(z)
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

    open(optimal_path, "w") do fp
        JSON.print(fp, optimal_data)
    end

    return nothing
end
