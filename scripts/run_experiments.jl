using DOPT

function run()
    # For TTT-Plots
    t = @timed begin
        let num_samples = 30, codes = 3, sizes = 80

            job = DOPT.run(
                DOPT.ILS();
                nthreads     = 1,
                max_iter     = 1000,
                max_subiter  = 1000,
                relink_depth = 10,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )

            DOPT.extract_ttt(job)

            job = DOPT.run(
                DOPT.ILS();
                nthreads     = Threads.nthreads(),
                max_iter     = 1000,
                max_subiter  = 1000,
                relink_depth = 10,
                num_samples  = num_samples,
                sizes        = sizes,
                codes        = codes,
            )

            DOPT.extract_ttt(job)
        end
    end

    println("Time elapsed: $(t.time)")

    return nothing
end

# ∫(-x)ⁿ e⁻ᵃˣ dx = ∫(-x)ⁿ ∑ₖ₌₀ (-a x)ᵏ / k! dx

run()