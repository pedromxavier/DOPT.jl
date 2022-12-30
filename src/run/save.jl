function save!(
    job::Job,
    n::Integer,
    i::Integer,
    k::Integer,
    z⃗::Vector{T},
    t⃗::Vector{Float64},
) where {T}
    path = series_path(job, n, i, k)

    open(path, "w") do fp
        println(fp, "z,t")

        for (z, t) in zip(z⃗, t⃗)
            println(fp, "$(z),$(t)")
        end
    end

    return nothing
end

function save!(
    job::Job,
    n::Integer,
    i::Integer,
    z⃗::Vector{T},
    Δ::T,
    t⃗::Vector{Float64},
) where {T}
    path = results_path(job)

    # Objective Value Statistics
    z_avg = mean(z⃗)
    z_std = std(z⃗)
    z_min = minimum(z⃗)
    z_max = maximum(z⃗)
    z_med = median(z⃗)
    z_gap = Δ

    # Running Time Statistics
    t_avg = mean(t⃗)
    t_std = std(t⃗)
    t_min = minimum(t⃗)
    t_max = maximum(t⃗)
    t_med = median(t⃗)

    open(path, "a") do fp
        println(
            fp,
            "$(n),$(i),$(z_avg),$(z_std),$(z_min),$(z_max),$(z_med),$(z_gap),$(t_avg),$(t_std),$(t_min),$(t_max),$(t_med)"
        )
    end

    return nothing
end

function save!(job::Job)
    path = metadata_path(job)

    metadata = Dict{Symbol,Any}(
        :author      => get_author(),
        :method      => string(job.method),
        :num_samples => job.num_samples,
        :timestamp   => string(Dates.now()),
        :cpu_info    => [
            "$(cpu.model) : $(cpu.speed)MHz"
            for cpu in Sys.cpu_info()
        ],
    )

    merge!(metadata, job.params)

    open(path, "w") do fp
        JSON.print(fp, metadata, 4)
    end

    path = results_path(job)

    open(path, "w") do fp
        println(
            fp,
            "n,i,z_avg,z_std,z_min,z_max,z_med,z_gap,t_avg,t_std,t_min,t_max,t_med"
        )
    end

    return nothing
end


function get_next_job_index(path::AbstractString)
    match_list = match.(r"^job-([0-9]+)$", readdir(path))
    index_list = getindex.(filter(!isnothing, match_list), 1)

    return maximum(filter(!isnothing, tryparse.(Int, index_list)); init = 0) + 1
end