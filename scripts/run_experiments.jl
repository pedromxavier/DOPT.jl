using DOPT

function main()
    # For TTT-Plots
    DOPT.run(
        DOPT.ILS();
        max_time     = 300.0,
        max_iter     =  1000,
        max_subiter  =  1000,
        relink_depth =     5,
        num_samples  = 10,
        sizes=100,
        codes=Integer[1,2,3],
    )

    DOPT.run(
        DOPT.SimulatedAnnealing();
        max_iter     =       1000,
        max_subiter  =       1000,
        relink_depth =          5,
        num_samples  = 10,
        sizes=100,
        codes=Integer[1,2,3],
    )

    # With Path Relinking
    DOPT.run(
        DOPT.ILS();
        max_time     = 300.0,
        max_iter     =  1000,
        max_subiter  =  1000,
        relink_depth =     5,
        num_samples  = 3,
    )

    DOPT.run(
        DOPT.SimulatedAnnealing();
        max_iter     =       1000,
        max_subiter  =       1000,
        relink_depth =          5,
        num_samples  = 3,
    )

    # Without Path Relinking
    DOPT.run(
        DOPT.ILS();
        max_time     = 300.0,
        max_iter     =  1000,
        max_subiter  =  1000,
        relink_depth =     0,
        num_samples  = 3,
    )

    
    DOPT.run(
        DOPT.SimulatedAnnealing();
        max_iter     =       1000,
        max_subiter  =       1000,
        relink_depth =          0,
        num_samples  = 3,
    )

    return nothing
end

main()