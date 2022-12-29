function test_gap()
    for x = -10.0:1.0:10.0
        @test DOPT.gap(x, x) ≈ 0.0
        @test DOPT.gap(x, x + 1.0) ≈ 1.0 - inv(ℯ)
        @test DOPT.gap(x + 1.0, x) ≈ 1.0 - ℯ
    end

    return nothing
end