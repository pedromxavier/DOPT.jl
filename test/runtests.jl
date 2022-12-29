using Test
using DOPT

include("lib/tools.jl")

function main()
    @testset "Library" begin
        test_gap()
    end
end


main()