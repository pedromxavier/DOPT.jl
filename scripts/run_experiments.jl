using DOPT

function run_random()
    # Test random local search
    t = @timed begin
        let num_samples = 3, sizes = 100, codes = [1, 2, 3]
            DOPT.run(
                DOPT.ILS();
                max_time     = 100.0,
                max_iter     = 10,
                max_subiter  = 100,
                relink_depth = 5,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )

            DOPT.run(
                DOPT.ILS{DOPT.RandomLocalSearch{DOPT.FirstImprovement}}();
                max_time     = 100.0,
                max_iter     = 10,
                max_subiter  = 10_000,
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

function main()
    run_tttplots()

    # # With Path Relinking
    # DOPT.run(
    #     DOPT.ILS();
    #     max_time     = 300.0,
    #     max_iter     = 1000,
    #     max_subiter  = 1000,
    #     relink_depth = 5,
    #     num_samples  = 3,
    # )

    # DOPT.run(
    #     DOPT.SimulatedAnnealing();
    #     max_iter     = 1000,
    #     max_subiter  = 1000,
    #     relink_depth = 5,
    #     num_samples  = 3,
    # )

    # # Without Path Relinking
    # DOPT.run(
    #     DOPT.ILS();
    #     max_time     = 300.0,
    #     max_iter     = 1000,
    #     max_subiter  = 1000,
    #     relink_depth = 0,
    #     num_samples  = 3,
    # )


    # DOPT.run(
    #     DOPT.SimulatedAnnealing();
    #     max_iter     = 1000,
    #     max_subiter  = 1000,
    #     relink_depth = 0,
    #     num_samples  = 3,
    # )

    return nothing
end

main()