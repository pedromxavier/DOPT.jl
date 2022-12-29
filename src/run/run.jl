function run(
    n::Integer,
    i::Integer,
    method::DOPT.MetaHeuristic = DOPT.AntColony();
    params...
)
    print_header(
        method;
        num_ants    = num_ants,
        max_iter    = max_iter,
        max_time    = max_time,
        max_subiter = max_subiter,
        max_subtime = max_subtime,
        nthreads    = nthreads,
        submethod   = submethod,
        max_temp    = max_temp,
        min_temp    = min_temp,
    )

    print(
        """
        *-------*-----*---------*---------------*---------------*--------------*
        |   n:i |  s  |  value  |      gap      |  iter:subiter |     time     |
        *-------*-----*---------*---------------*---------------*--------------*
        """,
    )

    results = []

    for n in N, i in I
        z̄ = DOPT.read_solution(n, i)

        A = DOPT.read_instance(n, i, :A)
        R = DOPT.read_instance(n, i, :R)
        s = n ÷ 2

        for _ = 1:num_samples
            info = @timed DOPT.solve(
                method,
                A,
                R,
                s;
                nthreads    = nthreads,
                max_iter    = max_iter,
                max_time    = max_time,
                num_ants    = num_ants,
                max_temp    = max_temp,
                min_temp    = min_temp,
                submethod   = submethod,
                max_subiter = max_subiter,
                max_subtime = max_subtime,
            )

            r = info.value
            t = info.time
            k = sum(round.(Int, r.x))
            z = r.z[end]

            if isnothing(z̄)
                Δ = NaN
                z̄ = update_solution(n, i, r.x)
            else
                δ = z - z̄
                
                if δ > 0
                    z̄ = update_solution(n, i, r.x)
                end

                Δ = δ / abs(z̄)
            end

            @printf(
                "| %3d:%1d | %3d | %+7.3f | Δ ≈ %+8.2f%% | %5d:%7d | %12.2f |\n",
                n,
                i,
                k,
                z,
                100.0Δ,
                r.num_iter,
                r.num_subiter,
                info.time,
            )

            push!(results, (n, i, z, t))
        end
    end

    println(
        "*-------*-----*-----------*---------------*---------------*-----------*",
    )

    metadata = Dict{String,Any}(
        "max_subiter" => max_subiter,
        "num_swaps" => num_swaps,
        "num_ants" => num_ants,
        "max_iter" => max_iter,
        "max_time" => max_time,
        "nthreads" => nthreads,
        "datetime" => Dates.now(),
        "method"   => method_summary(method; submethod = submethod),
    )

    index = get_results_index()::Integer
    path  = mkpath(data_path("results-$(index)"))

    metadata_path = joinpath(path, "metadata.json")
    results_path  = joinpath(path, "results.csv")

    let fp = open(metadata_path, "w")
        JSON.print(fp, metadata)
        close(fp)
    end

    CSV.write(results_path, results, header = ["n","i","z","t"])
end

function get_results_index()
    match_list = match.(r"^results-([0-9]+)$", readdir(DATA_PATH))
    index_list = getindex.(filter(!isnothing, match_list), 1)

    return maximum(filter(!isnothing, tryparse.(Int, index_list)); init = 0) + 1
end