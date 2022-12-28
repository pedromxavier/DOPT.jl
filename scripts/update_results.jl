using DOPT

function main(argv)
    author = nothing

    if length(argv) == 1
        author = argv[1]
    else
        error("This script accepts only one argument [author]")
    end

    DOPT.update_solution!(; author=author)

    return 0
end

main(ARGS)