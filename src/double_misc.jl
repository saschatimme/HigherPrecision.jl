# COMPARISON & EQUALITY
<(a::DoubleFloat64, b::DoubleFloat64) = a.hi + a.lo < b.hi + b.lo
<(a::DoubleFloat64, b::Float64) = a.hi < b || (a.hi == b) && a.lo < 0.0
<(a::Float64, b::DoubleFloat64) = a < b.hi || (a == b.hi) && b.lo > 0.0

Base.isless(a::DoubleFloat64, b::DoubleFloat64) = isless(a.hi + a.lo, b.hi + b.lo)

<=(a::DoubleFloat64, b::DoubleFloat64) = !(b < a)
<=(a::DoubleFloat64, b::Float64) = !(b < a)
<=(a::Float64, b::DoubleFloat64) = !(b < a)


==(a::DoubleFloat64, b::Float64) = a.hi == b && a.lo == 0.0
==(a::Float64, b::DoubleFloat64) = b == a
Base.iszero(a::DoubleFloat64) = a.hi == 0.0

if VERSION > v"0.7.0-DEV.1319"
    Base.isone(a::DoubleFloat64) = a.hi == 1.0 && a.lo == 0.0
else
    isone(a::DoubleFloat64) = a.hi == 1.0 && a.lo == 0.0
end

Base.abs(a::DoubleFloat64) = a.hi < 0.0 ? -a : a

Base.eps(::Type{DoubleFloat64}) = 4.93038065763132e-32 # 2^-104

Base.realmin(::Type{DoubleFloat64}) = 2.0041683600089728e-292 # = 2^(-1022 + 53)
Base.realmax(::Type{DoubleFloat64}) = DoubleFloat64(1.79769313486231570815e+308, 9.97920154767359795037e+291);

Base.isnan(a::DoubleFloat64) = isnan(a.hi) || isnan(a.lo)
Base.isinf(a::DoubleFloat64) = isinf(a.hi)
Base.isfinite(a::DoubleFloat64) = isfinite(a.hi)

#
# ROUNDING
#
@inline function Base.round(a::DoubleFloat64)
    hi = round(a.hi)
    lo = 0.0

    if hi == a.hi
        # High word is an integer already.  Round the low word.
        lo = round(a.lo)

        # Renormalize. This is needed if hi = some integer, lo = 1/2.
        hi, lo = quick_two_sum(hi, lo)
    else
        # High word is not an integer.
        if abs(hi-a.hi) == 0.5 && a.lo < 0.0
            # There is a tie in the high word, consult the low word to break the tie.
            hi -= 1.0
        end
    end

     DoubleFloat64(hi, lo)
end

@inline function Base.floor(a::DoubleFloat64)
    hi = floor(a.hi)
    lo = 0.0

    if hi == a.hi
        lo = floor(a.lo)
        hi, lo = quick_two_sum(hi, lo)
    end

    DoubleFloat64(hi, lo)
end

@inline function Base.ceil(a::DoubleFloat64)
    hi = ceil(a.hi)
    lo = 0.0

    if hi == a.hi
        lo = ceil(a.lo)
        hi, lo = quick_two_sum(hi, lo)
    end

    DoubleFloat64(hi, lo)
end

Base.trunc(a::DoubleFloat64) = a.hi ≥ 0.0 ? floor(a) : ceil(a)

function Base.rand(::Type{DoubleFloat64})
    u = rand(UInt64)
    f = Float64(u)
    uf = UInt64(f)
    ur = uf > u ? uf - u : u - uf
    DoubleFloat64(5.421010862427522e-20 * f, 5.421010862427522e-20 * Float64(ur))
end
function Base.rand(::Type{DoubleFloat64}, dims::Vararg{Int, N}) where N
    rands = Array{DoubleFloat64}(dims)
    for l in eachindex(rands)
        rands[l] = rand(DoubleFloat64)
    end
    rands
end
