using DOPT

function main(argv)
    author = if length(argv) == 0
        nothing
    else
        argv[1]
    end

    DOPT.update_optimal!(; author=author)

    return nothing
end

main(ARGS)