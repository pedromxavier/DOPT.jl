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

    for n in INSTANCE_SIZES, i in INSTANCE_CODES
        _run!(job, n, i)
    end

    print_footer()

    return nothing
end
