using DOPT

function run_minimal()
    println("Running Minimal Example")

    # For TTT-Plots
    t = @timed begin
        let num_samples = 3, sizes = 40, codes = 1
            DOPT.run(
                DOPT.ILS();
                max_time     = 100.0,
                max_iter     = 10,
                max_subiter  = 1000,
                relink_depth = 0,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )

            DOPT.run(
                DOPT.SimulatedAnnealing();
                max_iter     = 100,
                max_subiter  = 100,
                relink_depth = 0,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )
        end
    end

    println("Time elapsed: $(t.time)")

    return nothing
end

function run_tttplots()
    # For TTT-Plots
    t = @timed begin
        let num_samples = 30, sizes = 80, codes = [1, 2, 3]
            DOPT.run(
                DOPT.ILS();
                max_time     = 100.0,
                max_iter     = 10,
                max_subiter  = 1000,
                relink_depth = 5,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )

            DOPT.run(
                DOPT.SimulatedAnnealing();
                max_iter     = 1000,
                max_subiter  = 1000,
                relink_depth = 5,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )
        end
    end

    println("Time elapsed: $(t.time)")

    return nothing
end

run_minimal()