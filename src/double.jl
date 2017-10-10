export DoubleFloat64, sincosh, square, add, mul, div, sub

struct DoubleFloat64 <: Real
    hi::Float64
    lo::Float64
end

DoubleFloat64(x::DoubleFloat64) = DoubleFloat64(x.hi, x.lo)
DoubleFloat64(x::Float64) = DoubleFloat64(x, isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Float32) = DoubleFloat64(convert(Float64, x), isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Float16) = DoubleFloat64(convert(Float64, x), isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Integer) = DoubleFloat64(convert(Float64, x), isinf(x) ? Inf : 0.0)
function DoubleFloat64(x::BigFloat)
    z = convert(Float64, x)
    DoubleFloat64(z, convert(Float64, x-z))
end
DoubleFloat64(x::Irrational) = DoubleFloat64(big(x))

zero(::DoubleFloat64) = DoubleFloat64(0.0, 0.0)
zero(::Type{DoubleFloat64}) = DoubleFloat64(0.0, 0.0)

one(::DoubleFloat64) = DoubleFloat64(1.0, 0.0)
one(::Type{DoubleFloat64}) = DoubleFloat64(1.0, 0.0)

Base.convert(::Type{T}, a::DoubleFloat64) where {T<:AbstractFloat} = convert(T, a.hi)
Base.convert(::Type{BigFloat}, a::DoubleFloat64) = big(a.hi) + big(a.lo)
Base.convert(::Type{T}, a::DoubleFloat64) where {T<:Integer} = convert(T, a.hi)
Base.convert(::Type{BigInt}, a::DoubleFloat64) = convert(BigInt, big(a.hi) + big(a.lo))

Base.convert(::Type{DoubleFloat64}, x::AbstractFloat) = DoubleFloat64(x)
Base.convert(::Type{DoubleFloat64}, x::Irrational) = DoubleFloat64(x)
Base.convert(::Type{DoubleFloat64}, x::Integer) = DoubleFloat64(x)

Base.promote_rule(::Type{DoubleFloat64}, ::Type{Int}) = DoubleFloat64
Base.promote_rule(::Type{DoubleFloat64}, ::Type{BigFloat}) = BigFloat
Base.promote_rule(::Type{DoubleFloat64}, ::Type{Float64}) = DoubleFloat64
Base.promote_rule(::Type{DoubleFloat64}, ::Type{Float32}) = DoubleFloat64
Base.promote_rule(::Type{DoubleFloat64}, ::Type{Float16}) = DoubleFloat64

Base.big(x::DoubleFloat64) = big(x.hi) + big(x.lo)

include("double_const.jl")
include("double_arithmetic.jl")
include("double_misc.jl")
include("double_funcs.jl")


function Base.show(io::IO, x::DoubleFloat64)
    @printf io "%.32g" big(x)  # crude approximation to valid number of digits
end
