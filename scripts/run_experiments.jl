using DOPT

function main()
    job = DOPT.run(
        DOPT.SimulatedAnnealing();
        max_iter    = 100,
        max_subiter = 100,
    )

    return nothing
end

main()