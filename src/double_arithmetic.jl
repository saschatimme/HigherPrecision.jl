#
# ADDITION
#
"""
    double_add(a::Float64, b::Float64)

Add two `Float64`s with `DoubleFloat64` precision.
"""
@inline function double_add(a::Float64, b::Float64)
    hi, lo =  two_sum(a, b)

    FastDouble(hi, lo)
end

@inline function +(a::DoubleFloat64{T}, b::Float64) where T
    hi, lo = two_sum(a.hi, b)
    lo += a.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64{T}(hi, lo)
end
+(a::Float64, b::DoubleFloat64) = b + a
+(a::Integer, b::DoubleFloat64) = b + float(a)
+(a::DoubleFloat64, b::Integer) = a + float(b)

@inline function accurate_add(a::DoubleFloat64, b::DoubleFloat64)
    s1, s2 = two_sum(a.hi, b.hi)
    t1, t2 = two_sum(a.lo, b.lo)
    s2 += t1
    s1, s2 = quick_two_sum(s1, s2);
    s2 += t2
    s1, s2 = quick_two_sum(s1, s2);

    AccurateDouble(s1, s2);
end

@inline function fast_add(a::DoubleFloat64, b::DoubleFloat64)
    hi, lo = two_sum(a.hi, b.hi)
    lo += (a.lo + b.lo)
    hi, lo = quick_two_sum(hi, lo)

    FastDouble(hi, lo);
end

+(a::FastDouble, b::FastDouble) = fast_add(a, b)
+(a::FastDouble, b::AccurateDouble) = accurate_add(a, b)
+(a::AccurateDouble, b::FastDouble) = accurate_add(a, b)
+(a::AccurateDouble, b::AccurateDouble) = accurate_add(a, b)


#
# SUBSTRACTION
#
"""
    double_sub(a::Float64, b::Float64)

Subtract two `Float64`s with `DoubleFloat64` precision.
"""
@inline function double_sub(a::Float64, b::Float64)
    hi, lo = two_diff(a, b)

    FastDouble(hi, lo)
end

@inline function -(a::DoubleFloat64{T}, b::Float64) where T
    hi, lo = two_diff(a.hi, b)
    lo += a.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64{T}(hi, lo)
end

@inline function -(a::Float64, b::DoubleFloat64{T}) where T
    hi, lo = two_diff(a, b.hi)
    lo -= b.lo
    hi, lo = quick_two_sum(hi, lo)

    DoubleFloat64{T}(hi, lo)
end

@inline function fast_sub(a::DoubleFloat64, b::DoubleFloat64)
    hi, lo = two_diff(a.hi, b.hi)
    lo += a.lo
    lo -= b.lo
    hi, lo = quick_two_sum(hi, lo)

    FastDouble(hi, lo)
end

@inline function accurate_sub(a::DoubleFloat64, b::DoubleFloat64)
    s1, s2 = two_diff(a.hi, b.hi)
    t1, t2 = two_diff(a.lo, b.lo)
    s2 += t1
    s1, s2 = quick_two_sum(s1, s2);
    s2 += t2
    s1, s2 = quick_two_sum(s1, s2);

    AccurateDouble(s1, s2);
end

-(a::FastDouble, b::FastDouble) = fast_sub(a, b)
-(a::FastDouble, b::AccurateDouble) = accurate_sub(a, b)
-(a::AccurateDouble, b::FastDouble) = accurate_sub(a, b)
-(a::AccurateDouble, b::AccurateDouble) = accurate_sub(a, b)


-(a::DoubleFloat64{T}) where T = DoubleFloat64{T}(-a.hi, -a.lo)


#
# MULTIPLICATION
#
"""
    double_mutiply(a::Float64, b::Float64)

Multiply two `Float64`s with `DoubleFloat64` precision.
"""
@inline function double_mul(a::Float64, b::Float64)
    hi, lo = two_prod(a, b)
    FastDouble(hi, lo)
end

@inline function *(a::DoubleFloat64{T}, b::Float64) where T
    p1, p2 = two_prod(a.hi, b)
    p2 += a.lo * b
    p1, p2 = quick_two_sum(p1, p2)

    DoubleFloat64{T}(p1, p2)
end
*(a::Float64, b::DoubleFloat64) = b * a
*(a::Integer, b::DoubleFloat64) = b * float(a)
*(a::DoubleFloat64, b::Integer) = a * float(b)


@inline function *(a::DoubleFloat64{T}, b::DoubleFloat64{S}) where {T, S}
    p1, p2 = two_prod(a.hi, b.hi)
    p2 += a.hi * b.lo + a.lo * b.hi
    p1, p2 = quick_two_sum(p1, p2)

    DoubleFloat64{promote_type(T, S)}(p1, p2)
end


#
# DIVISION
#
"""
    double_div(a::Float64, b::Float64)

Divide two `Float64`s with `DoubleFloat64` precision.
"""
@inline function double_div(a::Float64, b::Float64)
    q1 = a / b
    # Compute a - q1 * b
    p1, p2 = two_prod(q1, b)
    s, e = two_diff(a, p1)
    e -= p2

    # get next approximation
    q2 = (s + e) / b

    s, e = quick_two_sum(q1, q2)

    FastDouble(s, e)
end

@inline function /(a::DoubleFloat64{T}, b::Float64) where T
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

    DoubleFloat64{T}(hi, lo)
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

    FastDouble(hi, lo)
end

@inline function accurate_div(a::DoubleFloat64, b::DoubleFloat64)
    q1 = a.hi / b.hi  # approximate quotient

    r = a -  b * q1

    q2 = r.hi / b.hi
    r -= q2 * b

    q3 = r.hi / b.hi

    q1, q2 = quick_two_sum(q1, q2)

    AccurateDouble(q1, q2) + q3
end

/(a::FastDouble, b::FastDouble) = fast_div(a, b)
/(a::FastDouble, b::AccurateDouble) = accurate_div(a, b)
/(a::AccurateDouble, b::FastDouble) = accurate_div(a, b)
/(a::AccurateDouble, b::AccurateDouble) = accurate_div(a, b)

/(a::Float64, b::DoubleFloat64) = DoubleFloat64(a) / b
/(a::Integer, b::DoubleFloat64) = float(a) / b
/(a::DoubleFloat64, b::Integer) = a / float(b)


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

"""
    square(x::DoubleFloat64)

Compute `x * x` in a more efficient way.
"""
@inline function square(a::DoubleFloat64{T}) where T
    p1, p2 = two_square(a.hi)
    p2 += 2.0 * a.hi * a.lo
    p2 += a.lo * a.lo
    hi, lo = quick_two_sum(p1, p2)
    return DoubleFloat64{T}(hi, lo)
end
square(a::Float64) = double_square(a)
"""
    double_square(x::Float64)

Convert `x` to a DoubleFloat64 and then compute `x*x`.
"""
@inline function double_square(a::Float64)
    hi, lo = two_square(a)
    return FastDouble(hi, lo)
end
# Implementation adapted from Base
@inline function power_by_squaring(x::DoubleFloat64, p::Integer)
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

@inline function Base.sqrt(a::DoubleFloat64{T}) where T
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

    convert(DoubleFloat64{T}, double_add(ax, (a - square(ax)).hi * (x * 0.5)))
end

"""
    double_square(x::Float64)

Convert `x` to a DoubleFloat64 and then compute `sqrt(x)`.
"""
double_sqrt(a::Float64) = sqrt(FastDouble(a))

# TODO: Add n-th root?
