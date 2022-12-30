abstract type StopCriteria end

struct FirstImprovement <: StopCriteria end

function Base.show(io::IO, ::FirstImprovement)
    print(io, "First Improvement")
end

struct FirstImprovementPlus <: StopCriteria end

function Base.show(io::IO, ::FirstImprovementPlus)
    print(io, "First Improvement Plus")
end

struct BestImprovement <: StopCriteria end

function Base.show(io::IO, ::BestImprovement)
    print(io, "Best Improvement")
end

struct LocalSearch{C<:StopCriteria} <: MetaHeuristic end

LocalSearch() = LocalSearch{FirstImprovement}()

function solve(
    ::LocalSearch{FirstImprovement},
    A::Matrix{T},
    V::Array{T,3},
    x̄::Vector{U},
    z̄::T;
    max_iter::Union{Integer,Nothing} = nothing,
    max_time::Union{Float64,Nothing} = nothing,
    params...,
) where {T,U}
    n    = length(x̄)
    x⃰, z⃰ = copy(x̄), z̄
    X    = objmatrix(A, x̄)

    num_iter  = 0
    run_time  = 0.0
    init_time = time()

    while !stop(num_iter, max_iter, run_time, max_time)
        flag = false

        for i = 1:n, j = 1:n
            i == j && continue

            if iszero(x⃰[i]) ⊻ iszero(x⃰[j])
                if iszero(x⃰[i])
                    i, j = j, i
                end

                swap!(X, V, i, j)

                z = objval(X)

                if z > z⃰ # Improvement
                    swap!(x⃰, i, j)
                    flag = true
                    z⃰ = z
                    break
                else
                    swap!(X, V, j, i)
                end
            end
        end

        num_iter += 1
        run_time = time() - init_time
        flag || break
    end

    return (x⃰, z⃰, num_iter)
end

function solve(
    ::LocalSearch{FirstImprovement},
    A::Matrix{T},
    x̄::Vector{T},
    z̄::T;
    max_iter::Union{Integer,Nothing} = nothing,
    max_time::Union{Float64,Nothing} = nothing,
    params...,
) where {T}
    n = length(x̄)
    x⃰ = copy(x̄)
    z⃰ = z̄
    x = copy(x⃰)
    z = NaN

    num_iter  = 0
    run_time  = 0.0
    init_time = time()

    while !stop(num_iter, max_iter, run_time, max_time)
        flag = false

        for i = 1:n
            if !iszero(x[i])
                x[i] = zero(T)

                for j = 1:n
                    if i != j && iszero(x[j])
                        x[j] = one(T)

                        z = objval(A, x)

                        if z > z⃰
                            x⃰, z⃰ = copy(x), z
                            flag = true
                            break
                        end

                        x[j] = zero(T)
                    end
                end

                flag && break
                x[i] = one(T)
            end
        end

        num_iter += 1
        run_time = time() - init_time
        flag || break
    end

    return (x⃰, z⃰, num_iter)
end

function solve(
    ::LocalSearch{FirstImprovementPlus},
    A::Matrix{T},
    x̄::Vector{T},
    z̄::T;
    max_iter::Union{Integer,Nothing} = nothing,
    max_time::Union{Float64,Nothing} = nothing,
    params...,
) where {T}
    n = length(x̄)
    x⃰ = copy(x̄)
    z⃰ = z̄
    x = copy(x⃰)
    z = NaN

    k = nothing

    num_iter  = 0
    run_time  = 0.0
    init_time = time()

    while !stop(num_iter, max_iter, run_time, max_time)
        flag = false
        num_iter += 1

        for i = 1:n
            if !iszero(x[i])
                x[i] = zero(T)

                for j = 1:n
                    if i != j && iszero(x[j])
                        x[j] = one(T)

                        z = objval(A, x)

                        if z > z⃰
                            x⃰, z⃰ = copy(x), z
                            k    = j
                            flag = true
                        end

                        x[j] = zero(T)
                    end
                end

                flag && break
                x[i] = one(T)
            end
        end

        x[k] = one(T)
        
        num_iter += 1
        run_time = time() - init_time

        flag || break
    end

    return (x⃰, z⃰, [], num_iter, 0)
end

function solve(
    ::LocalSearch{BestImprovement},
    A::Matrix{T},
    x̄::Vector{T},
    z̄::T;
    max_iter::Union{Integer,Nothing} = nothing,
    max_time::Union{Float64,Nothing} = nothing,
    params...,
) where {T}
    n = length(x̄)
    x⃰ = copy(x̄)
    z⃰ = z̄
    x = copy(x⃰)
    z = NaN

    k = nothing
    l = nothing

    num_iter  = 0
    run_time  = 0.0
    init_time = time()

    while !stop(num_iter, max_iter, run_time, max_time)
        flag = false

        for i = 1:n
            if !iszero(x[i])
                x[i] = zero(T)

                for j = 1:n
                    if i != j && iszero(x[j])
                        x[j] = one(T)

                        z = objval(A, x)

                        if z > z⃰
                            x⃰, z⃰ = copy(x), z
                            k, l = i, j
                            flag = true
                        end

                        x[j] = zero(T)
                    end
                end

                flag && break
                x[i] = one(T)
            end
        end

        x[k] = one(T)
        x[l] = zero(T)

        num_iter += 1
        run_time = time() - init_time

        flag || break
    end

    return (x⃰, z⃰, num_iter)
end

function Base.show(io::IO, ::LocalSearch{C}) where {C}
    print(io, "Local Search: $(C())")
end