using Documenter, HigherPrecision

makedocs(
    format = :html,
    sitename = "HigherPrecision.jl",
    #modules = [HigherPrecision],
    pages = [
        "Introduction" => "index.md",
        "Compute mode" => "computemode.md",
        "Reference" => "reference.md"
        ]
)

deploydocs(
    repo   = "github.com/saschatimme/HigherPrecision.jl.git",
    target = "build",
    julia = "0.6",
    osname = "linux",
    deps   = nothing,
    make   = nothing
)
