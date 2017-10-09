#
# ADDITION
#
@inline function add(::Type{DoubleFloat64}, a::Float64, b::Float64)
    hi, lo =  two_sum(a, b)

    DoubleFloat64(hi, lo)
end

@inline function +(a::DoubleFloat64, b::Float64)
    hi, lo = two_sum(a.hi, b)
    lo += a.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64(hi, lo)
end
+(a::Float64, b::DoubleFloat64) = b + a
+(a::Int, b::DoubleFloat64) = b + float(a)
+(a::DoubleFloat64, b::Int) = a + float(b)

@inline function accurate_add(a::DoubleFloat64, b::DoubleFloat64)
    s1, s2 = two_sum(a.hi, b.hi)
    t1, t2 = two_sum(a.lo, b.lo)
    s2 += t1
    s1, s2 = quick_two_sum(s1, s2);
    s2 += t2
    s1, s2 = quick_two_sum(s1, s2);

    DoubleFloat64(s1, s2);
end

@inline function fast_add(a::DoubleFloat64, b::DoubleFloat64)
    hi, lo = two_sum(a.hi, b.hi)
    lo += (a.lo + b.lo)
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64(hi, lo);
end

+(a::DoubleFloat64, b::DoubleFloat64) = fast_add(a, b)


#
# SUBSTRACTION
#
@inline function sub(::Type{DoubleFloat64}, a::Float64, b::Float64)
    hi, lo = two_diff(a, b)

    DoubleFloat64(hi, lo)
end

@inline function -(a::DoubleFloat64, b::Float64)
    hi, lo = two_diff(a.hi, b)
    lo += a.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64(hi, lo)
end

@inline function -(a::Float64, b::DoubleFloat64)
    hi, lo = two_diff(a, b.hi)
    lo -= b.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64(hi, lo)
end

@inline function fast_sub(a::DoubleFloat64, b::DoubleFloat64)
    hi, lo = two_diff(a.hi, b.hi)
    lo += a.lo
    lo -= b.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64(hi, lo)
end

@inline function accurate_sub(a::DoubleFloat64, b::DoubleFloat64)
    s1, s2 = two_diff(a.hi, b.hi)
    t1, t2 = two_diff(a.lo, b.lo)
    s2 += t1
    s1, s2 = quick_two_sum(s1, s2);
    s2 += t2
    s1 = quick_two_sum(s1, s2, s2);

    DoubleFloat64(s1, s2);
end

-(a::DoubleFloat64, b::DoubleFloat64) = fast_sub(a, b)


-(a::DoubleFloat64) = DoubleFloat64(-a.hi, -a.lo)


#
# MULTIPLICATION
#
@inline function mul(::Type{DoubleFloat64}, a::Float64, b::Float64)
    hi, lo = two_prod(a, b)
    DoubleFloat64(hi, lo)
end

@inline function *(a::DoubleFloat64, b::Float64)
    p1, p2 = two_prod(a.hi, b)
    p2 = muladd(a.lo, b, p2)
    p1, p2 = quick_two_sum(p1, p2)

    DoubleFloat64(p1, p2)
end
*(a::Float64, b::DoubleFloat64) = b * a
*(a::Int, b::DoubleFloat64) = b * float(a)
*(a::DoubleFloat64, b::Int) = a * float(b)

@inline function *(a::DoubleFloat64, b::DoubleFloat64)
    p1, p2 = two_prod(a.hi, b.hi)
    p2 += muladd(a.hi, b.lo, a.lo * b.hi)
    p1, p2 = quick_two_sum(p1, p2)

    DoubleFloat64(p1, p2)
end

#
# DIVISION
#
@inline function div(::Type{DoubleFloat64}, a::Float64, b::Float64)
    q1 = a / b
    # Compute a - q1 * b
    p1, p2 = two_prod(q1, b)
    s, e = two_diff(a, p1)
    e -= p2

    # get next approximation
    q2 = (s + e) / b

    s, e = quick_two_sum(q1, q2)

    DoubleFloat64(s, e)
end

@inline function /(a::DoubleFloat64, b::Float64)
    q1 = a.hi / b

    # Compute  this - q1 * d
    p1, p2 = two_prod(q1, b)
    s, e = two_diff(a.lo, p1)
    e += a.lo
    e -= p2

    # get next approximation.
    q2 = (s + e) / b

    # renormalize
    hi, lo = quick_two_sum(q1, q2)

    DoubleFloat64(hi, lo)
end


@inline function fast_div(a::DoubleFloat64, b::DoubleFloat64)
    q1 = a.hi / b.hi  # approximate quotient

    # compute  this - q1 * dd
    r = b * q1
    s1, s2 = two_diff(a.hi, r.hi)
    s2 -= r.lo
    s2 += a.lo

    # get next approximation
    q2 = (s1 + s2) / b.hi

    # renormalize
    hi, lo = quick_two_sum(q1, q2)

    return DoubleFloat64(hi, lo)
end

@inline function accurate_div(a::DoubleFloat64, b::DoubleFloat64)
    q1 = a.hi / b.hi  # approximate quotient

    r = a -  b * q1

    q2 = r.hi / b.hi
    r -= q2 * b

    q3 = r.hi / b.hi

    q1, q2 = quick_two_sum(q1, q2)

    r = DoubleFloat64(q1, q2) + q3
    r
end

/(a::DoubleFloat64, b::DoubleFloat64) = fast_div(a, b)
/(a::Float64, b::DoubleFloat64) = DoubleFloat64(a) / b
/(a::Int, b::DoubleFloat64) = float(a) / b
/(a::DoubleFloat64, b::Int) = a / float(b)


Base.inv(a::DoubleFloat64) = 1.0 / a

Base.rem(a::DoubleFloat64, b::DoubleFloat64) = a - round(a / b) * b
@inline function Base.divrem(a::DoubleFloat64, b::DoubleFloat64)
    n = round(a / b)
    n, a - n * b
end

function Base.mod(x::DoubleFloat64, y::DoubleFloat64)
    n = round(a / b)
    return (a - b * n)
end

#
# POWERS
#

@inline function square(a::DoubleFloat64)
    p1, p2 = two_square(a.hi)
    p2 += 2.0 * a.hi * a.lo
    p2 += a.lo * a.lo
    hi, lo = quick_two_sum(p1, p2)
    return DoubleFloat64(hi, lo)
end

@inline function square(a::Float64)
    hi, lo = two_square(a)
    return DoubleFloat64(hi, lo)
end

# The compiler optimizes low static powers
# See here https://github.com/JuliaLang/julia/blob/b83c228a6de9a3d1a22afa5d019da770ff355427/base/intfuncs.jl#L223-L235
@inline Base.literal_pow(::typeof(^), a::DoubleFloat64, ::Val{1}) = a
@inline Base.literal_pow(::typeof(^), a::DoubleFloat64, ::Val{2}) = square(a)
@inline Base.literal_pow(::typeof(^), a::DoubleFloat64, ::Val{3}) = square(a) * a

# Implementation adapted from Base
function power_by_squaring(x::DoubleFloat64, p::Integer)
    if p == 1
        return copy(x)
    elseif p == 0
        return one(x)
    elseif p == 2
        return square(x)
    end
    P = abs(p)
    t = trailing_zeros(P) + 1
    P >>= t
    while (t -= 1) > 0
        x = square(x)
    end
    y = x
    while P > 0
        t = trailing_zeros(P) + 1
        P >>= t
        while (t -= 1) >= 0
            x = square(x)
        end
        y *= x
    end
    if (p < 0)
        return 1.0 / y
    end
    y
end

^(a::DoubleFloat64, p::Integer) = power_by_squaring(a, p)
^(a::DoubleFloat64, b::Real) = exp(b * log(a))

function Base.sqrt(a::DoubleFloat64)
    #= Strategy:  Use Karp's trick:  if x is an approximation
   to sqrt(a), then

      sqrt(a) = a*x + [a - (a*x)^2] * x / 2   (approx)

   The approximation is accurate to twice the accuracy of x.
   Also, the multiplication (a*x) and [-]*x can be done with
   only half the precision.
   =#
    if a.hi < 0
        throw(DomainError("sqrt will only return a complex result if called with a complex argument."))
    end
    if iszero(a)
        return zero(a)
    end

    x = inv(sqrt(a.hi))
    ax = a.hi * x

    add(DoubleFloat64, ax, (a - square(ax)).hi * (x * 0.5))
end

Base.sqrt(DoubleFloat64, a::Float64) = sqrt(DoubleFloat64(a))

# TODO: Add n-th root?
