using DOPT

function main()
    DOPT.run(
        DOPT.ILS();
        max_time     = 300.0,
        max_iter     =  1000,
        max_subiter  =  1000,
        relink_depth =     5,
    )

    DOPT.run(
        DOPT.SimulatedAnnealing();
        max_iter     =       1000,
        max_subiter  =       1000,
        relink_depth =          5,
    )

    DOPT.run(
        DOPT.ILS();
        max_time     = 300.0,
        max_iter     =  1000,
        max_subiter  =  1000,
        relink_depth =     0,
    )

    DOPT.run(
        DOPT.SimulatedAnnealing();
        max_iter     =       1000,
        max_subiter  =       1000,
        relink_depth =          0,
    )

    return nothing
end

main()