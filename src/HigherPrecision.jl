__precompile__()

module HigherPrecision


    import Base: +, -, *, /, ^, <, ==, <=

    include("basics.jl")
    include("double.jl")
    include("quad.jl")

end # module
