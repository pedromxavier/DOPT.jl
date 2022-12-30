function run(
    method::MetaHeuristic = SimulatedAnnealing();
    path::Union{AbstractString,Nothing} = nothing,
    sizes::Union{Integer,Vector,Nothing} = nothing,
    codes::Union{Integer,Vector,Nothing} = nothing,
    max_iter::Integer = 1_000,
    nthreads::Integer = Threads.nthreads(),
    max_time::Float64 = 1.0,
    max_subiter::Integer = 1_000,
    max_temp::Float64 = 100.0,
    min_temp::Float64 = 1E-10,
    num_samples::Integer = 3,
    relink_depth::Integer = 5,
    seed::Union{Integer,Nothing} = nothing,
    params...,
)
    solve_params = Dict{Symbol,Any}(
        :nthreads    => nthreads,
        :max_time    => max_time,
        :max_iter    => max_iter,
        :max_subiter => max_subiter,
        :max_temp    => max_temp,
        :min_temp    => min_temp,
        :relink_depth => relink_depth,
        params...,
    )

    if isnothing(sizes)
        sizes = INSTANCE_SIZES
    elseif sizes isa Integer
        sizes = [sizes]
    end

    if isnothing(codes)
        codes = INSTANCE_CODES
    elseif codes isa Integer
        codes = [codes]
    end

    job = Job(
        method,
        solve_params,
        path;
        num_samples = num_samples,
        sizes = sizes,
        codes = codes,
    )

    Random.seed!(seed)

    _run!(job)

    return job
end

function _run!(job::Job, n::Integer, i::Integer)
    z̄ = DOPT.read_benchmark(n, i)
    A, R, s = DOPT.read_instance(n, i)

    z⃗ = []
    t⃗ = []

    Δ = Inf

    relink = 0
    relink_depth = job.params[:relink_depth]

    for k = 1:job.num_samples
        report = DOPT.solve(job.method, A, R, s; job.params...)::DOPT.Report

        t = report.t[end]
        z = report.z[end]
        x = report.x[end]

        # Path Relinking
        if relink_depth > 0
            D = 0
            L = 0

            for l = 1:min(relink_depth, length(report) - 1)
                d = hamming_distance(x, report.x[end-l])

                if d > D
                    D = d
                    L = l
                end
            end

            xl, zl = DOPT.solve(
                PathRelinking{ForwardRelinking}(),
                A,
                x,
                z,
                report.x[end-L];
                job.params...,
            )

            if zl > z
                x, z = add_solution!(report, xl, zl)

                t = report.t[end]

                relink += 1
            end
        end

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
    δz = std(z⃗)

    # Running Time Statistics
    t = mean(t⃗)
    δt = std(t⃗)

    print_line(n, i, job.num_samples, z, δz, Δ, t, δt)

    # Save Results
    save!(job, n, i, Float64.(z⃗), Δ, Float64.(t⃗))

    return nothing
end

function _run!(job::Job)
    print_header(job.method; job.params...)

    save!(job)

    print_columns()

    for n in job.sizes, i in job.codes
        _run!(job, n, i)
    end

    print_footer()

    println("Results written to $(job_path(job))")

    return nothing
end

