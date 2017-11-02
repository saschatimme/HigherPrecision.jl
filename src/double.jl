export DoubleFloat64, FastDouble, AccurateDouble, sincosh,
double_square, double_add, double_mul, double_div, double_sub


"""
    DoubleFloat64(x [, mode::ComputeMode])
"""
struct DoubleFloat64{T<:ComputeMode} <: Real
    hi::Float64
    lo::Float64
end

"""
    FastDouble

Shorthand for `DoubleFloat64{ComputeFast}`
"""
const FastDouble = DoubleFloat64{ComputeFast}

"""
    AccurateDouble

Shorthand for `DoubleFloat64{ComputeAccurate}`
"""
const AccurateDouble = DoubleFloat64{ComputeAccurate}

DoubleFloat64(x::DoubleFloat64{T}) where T = DoubleFloat64{T}(x.hi, x.lo)
DoubleFloat64(x::Float64) = FastDouble(x, isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Float64, y::Float64) = FastDouble(x, y)
DoubleFloat64(x::Float32) = FastDouble(convert(Float64, x), isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Float16) = FastDouble(convert(Float64, x), isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Integer) = FastDouble(convert(Float64, x), isinf(x) ? Inf : 0.0)
function DoubleFloat64(x::BigFloat)
    z = convert(Float64, x)
    FastDouble(z, convert(Float64, x-z))
end
DoubleFloat64(x::Irrational) = DoubleFloat64(big(x))

DoubleFloat64(x::Float64, compmode::Type{<:ComputeMode}) = DoubleFloat64{compmode}(x, isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Float64, y::Float64, compmode::Type{<:ComputeMode}) = FastDouble(x, y)
DoubleFloat64(x::Float32, compmode::Type{<:ComputeMode}) = DoubleFloat64{compmode}(convert(Float64, x), isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Float16, compmode::Type{<:ComputeMode}) = DoubleFloat64{compmode}(convert(Float64, x), isinf(x) ? Inf : 0.0)
DoubleFloat64(x::Integer, compmode::Type{<:ComputeMode}) = DoubleFloat64{compmode}(convert(Float64, x), isinf(x) ? Inf : 0.0)
function DoubleFloat64(x::BigFloat, compmode::Type{<:ComputeMode})
    z = convert(Float64, x)
    DoubleFloat64{compmode}(z, convert(Float64, x-z))
end
DoubleFloat64(x::Irrational, compmode::Type{<:ComputeMode}) = DoubleFloat64(big(x), compmode)


hi(x::DoubleFloat64) = x.hi
lo(x::DoubleFloat64) = x.lo

Base.isbits(::DoubleFloat64) = true



zero(::DoubleFloat64{T}) where T = DoubleFloat64{T}(0.0, 0.0)
zero(::Type{DoubleFloat64{T}}) where T = DoubleFloat64{T}(0.0, 0.0)

one(::DoubleFloat64{T}) where T = DoubleFloat64{T}(1.0, 0.0)
one(::Type{DoubleFloat64{T}}) where T = DoubleFloat64{T}(1.0, 0.0)

Base.convert(::Type{T}, a::DoubleFloat64) where {T<:AbstractFloat} = convert(T, a.hi)
Base.convert(::Type{BigFloat}, a::DoubleFloat64) = big(a.hi) + big(a.lo)
Base.convert(::Type{T}, a::DoubleFloat64) where {T<:Integer} = convert(T, a.hi)
Base.convert(::Type{Integer}, a::DoubleFloat64) = convert(Int64, a.hi)
Base.convert(::Type{BigInt}, a::DoubleFloat64) = convert(BigInt, big(a.hi) + big(a.lo))

Base.convert(::Type{DoubleFloat64{T}}, x::DoubleFloat64{S}) where {T, S} = DoubleFloat64{T}(x.hi, x.lo)
Base.convert(::Type{DoubleFloat64{T}}, x::DoubleFloat64{T}) where {T} = x
Base.convert(::Type{DoubleFloat64{T}}, x::AbstractFloat) where T = DoubleFloat64(x, T)
Base.convert(::Type{DoubleFloat64{T}}, x::Irrational) where T = DoubleFloat64(x, T)
Base.convert(::Type{DoubleFloat64{T}}, x::Integer) where T = DoubleFloat64(x, T)


Base.promote_rule(::Type{FastDouble}, ::Type{DoubleFloat64{ComputeAccurate}}) = DoubleFloat64{ComputeAccurate}
Base.promote_rule(::Type{DoubleFloat64{T}}, ::Type{I}) where {T, I<:Integer} = DoubleFloat64{T}
Base.promote_rule(::Type{DoubleFloat64{T}}, ::Type{BigInt}) where {T} = BigFloat
Base.promote_rule(::Type{DoubleFloat64}, ::Type{BigFloat}) = BigFloat
Base.promote_rule(::Type{DoubleFloat64{T}}, ::Type{Float64}) where T = DoubleFloat64{T}
Base.promote_rule(::Type{DoubleFloat64{T}}, ::Type{Float32}) where T = DoubleFloat64{T}
Base.promote_rule(::Type{DoubleFloat64{T}}, ::Type{Float16}) where T = DoubleFloat64{T}


Base.big(x::DoubleFloat64) = big(x.hi) + big(x.lo)

include("double_const.jl")
include("double_arithmetic.jl")
include("double_misc.jl")
include("double_funcs.jl")


function Base.show(io::IO, x::DoubleFloat64)
    @printf io "%.32g" big(x)  # crude approximation to valid number of digits
end
