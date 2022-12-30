function print_columns()
    print(
        """
        *-------*-----*---------------------*---------*---------------------*
        |   n:i |  N  |        z̄ ±       δz |    Δ    |        t̄ ±       δt |
        *-------*-----*---------------------*---------*---------------------*
        """
    )

    return nothing
end

function print_line(
    n,
    i,
    N::Integer,
    z̄::T,
    δz::T,
    Δ::T,
    t̄::Float64,
    δt::Float64,
) where {T}
    @printf(
        "| %3d:%1d | %3d | %8.5f ±%9.6f | %+6.2f%% | %8.5f ±%9.6f |\n",
        n,
        i,
        N,
        z̄,
        δz,
        100.0Δ,
        t̄,
        δt,
    )

    return nothing
end

function print_footer()
    print(
        """
        *-------*-----*---------------------*---------*---------------------*
        """
    )

    return nothing
end
