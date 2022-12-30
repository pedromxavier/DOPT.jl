function run(
    method::MetaHeuristic = SimulatedAnnealing(),
    path::Union{AbstractString,Nothing} = nothing;
    max_iter::Integer = 1_000,
    max_subiter::Integer = 1_000,
    max_temp::Float64 = 100.0,
    min_temp::Float64 = 1E-10,
    num_samples::Integer = 3,
    params...,
)

    job_params = Dict{Symbol,Any}(
        :max_iter    => max_iter,
        :max_subiter => max_subiter,
        :max_temp    => max_temp,
        :min_temp    => min_temp,
        params...,
    )

    job = Job(method, job_params, path; num_samples = num_samples)

    _run!(job)

    return nothing
end

function _run!(job::Job, n::Integer, i::Integer)
    z̄       = DOPT.read_benchmark(n, i)
    A, R, s = DOPT.read_instance(n, i)

    z⃗ = []
    t⃗ = []

    Δ = Inf

    for k = 1:job.num_samples
        report = DOPT.solve(job.method, A, R, s; job.params...)::DOPT.Report

        t = report.t[end]
        z = report.z[end]
        x = report.x[end]

        if isnothing(z̄)
            DOPT.update_solution!(n, i, x)
        else
            δ = DOPT.gap(z, z̄)

            if δ < 0
                DOPT.update_solution!(n, i, x)
            end

            if δ < Δ
                Δ = δ
            end
        end

        # Save Series
        save!(job, n, i, k, report.z, report.t)

        push!(z⃗, z)
        push!(t⃗, t)
    end

    # Objective Value Statistics
    z = mean(z⃗)
    ẑ = median(z⃗)
    δz = std(z⃗)
    zmin = minimum(z⃗)
    zmax = maximum(z⃗)

    # Running Time Statistics
    t = mean(t⃗)
    t̂ = median(t⃗)
    δt = std(t⃗)
    tmin = minimum(t⃗)
    tmax = maximum(t⃗)

    print_line(n, i, job.num_samples, z, δz, Δ, t, δt)

    # Save Results
    # save!(job, n, i, z⃗, t⃗)

    return nothing
end

function _run!(job::Job)
    print_header(job.method; job.params...)

    print_columns()

    for n in INSTANCE_SIZES, i in INSTANCE_CODES
        _run!(job, n, i)
    end

    print_footer()

    # save(path, method; params...)

    # Metadata

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

    # CSV



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

