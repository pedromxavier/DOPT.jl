using Documenter
using DOPT
using LinearAlgebra

# Set up to run docstrings with jldoctest
DocMeta.setdocmeta!(
    DOPT, :DocTestSetup, :(using DOPT); recursive=true
)

makedocs(;
    modules=[DOPT],
    doctest=true,
    clean=true,
    format=Documenter.HTML(
        # assets = ["assets/extra_styles.css", "assets/favicon.ico"],
        mathengine=Documenter.MathJax2(),
        sidebar_sitename=false,
    ), 
    sitename="DOPT.jl",
    authors="Pedro Xavier and Thiago Henrique Coelho",
    pages=[
        "Home" => "index.md",
        # "manual.md",
        # "examples.md",
        # "Booklet" => "booklet.md"
    ],
    workdir="."
)

if "--skip-deploy" ∉ ARGS
    deploydocs(
        repo=raw"github.com/pedromxavier/DOPT.jl.git",
        push_preview = true,
    )
end