function print_columns()
    print("""
          *-------*-----*---------*---------------*---------------*--------------*
          |   n:i   |    N | z (ẑ) ± δz               | Δ            | t (t̂) ± δt | iter:subiter |
          *-------*-----*---------*---------------*---------------*--------------*
          """)
end

function run(
    n::Integer,
    i::Integer,
    method::DOPT.MetaHeuristic = DOPT.AntColony();
    num_samples::Integer = 1,
    params...,
)
    @assert num_samples > 0

    z̄ = DOPT.read_solution(n, i)
    A = DOPT.read_instance(n, i, :A)
    R = DOPT.read_instance(n, i, :R)
    s = n ÷ 2

    z⃗ = []
    t⃗ = []

    num_iter    = 0
    num_subiter = 0

    for _ = 1:num_samples
        report = DOPT.solve(method, A, R, s; params...)::DOPT.Report

        t = report.t[end]
        z = report.z[end]
        x = report.x[end]

        if isnothing(z̄)
            Δ = NaN
            DOPT.update_solution!(n, i, x, z)
        else
            Δ = DOPT.gap(z, z̄)

            if Δ < 0
                DOPT.update_solution!(n, i, x, z)
            end
        end

        push!(z⃗, z)
        push!(t⃗, t)

        num_iter    += report.num_iter   
        num_subiter += report.num_subiter
    end

    # Objective Value Statistics
    z  = mean(z⃗)
    ẑ  = median(z⃗)
    δz = std(z⃗)

    # Running Time Statistics
    t  = mean(t⃗)
    t̂  = median(t⃗)
    δt = std(t⃗)

    @printf(
        "| %3d:%1d | %3d  | %+7.3f (%+7.3f) ± %+7.3f | Δ ≈ %+8.2f%% | %12.2f | %10d:%10d |\n",
        n, i,
        num_samples,
        z, ẑ, δz,
        100.0Δ,
        t, t̂, δt,
        num_iter ÷ num_samples,
        num_subiter ÷ num_samples,
    )

    return nothing
end

function run(method::DOPT.MetaHeuristic = DOPT.AntColony(); params...)
    print_header(method; params...)

    print_columns()

    for n in N, i in I
        run(n, i, method; params...)
    end

    println("*-------*-----*-----------*---------------*---------------*-----------*")

    # metadata = Dict{String,Any}(
    #     "max_subiter" => max_subiter,
    #     "num_swaps" => num_swaps,
    #     "num_ants" => num_ants,
    #     "max_iter" => max_iter,
    #     "max_time" => max_time,
    #     "nthreads" => nthreads,
    #     "datetime" => Dates.now(),
    #     "method" => method_summary(method; submethod = submethod),
    # )

    # index = get_results_index()::Integer
    # path  = mkpath(data_path("results-$(index)"))

    # metadata_path = joinpath(path, "metadata.json")
    # results_path  = joinpath(path, "results.csv")

    # let fp = open(metadata_path, "w")
    #     JSON.print(fp, metadata)
    #     close(fp)
    # end

    # CSV.write(results_path, results, header = ["n", "i", "z", "t"])

    return nothing
end

# function get_results_index()
#     match_list = match.(r"^results-([0-9]+)$", readdir(DATA_PATH))
#     index_list = getindex.(filter(!isnothing, match_list), 1)

#     return maximum(filter(!isnothing, tryparse.(Int, index_list)); init = 0) + 1
# end