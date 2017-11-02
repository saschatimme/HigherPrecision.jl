# Compute Mode

For addition, subtraction and division we implement two versions, a accurate one (which satisfies
an IEEE style error bound) and a less accurate one which is significantly faster.
We leverage Julia's type system to support both versions seamlessly.

## Types
### ComputeMode
```@docs
ComputeMode
ComputeFast
ComputeAccurate
```
### DoubleFloat64
```@docs
DoubleFloat64
FastDouble
AccurateDouble
```

## Promotion

By default we will create a `FastDouble`, but the product (or sum) of a `FastDouble` and
an `AccurateDouble` is an `AccurateDouble`.


## What's the difference exactly?
As an example, here are the implementations for addition for `DoubleFloat64`s:
```julia
function accurate_add(a::DoubleFloat64, b::DoubleFloat64)
    s1, s2 = two_sum(a.hi, b.hi)
    t1, t2 = two_sum(a.lo, b.lo)
    s2 += t1
    s1, s2 = quick_two_sum(s1, s2);
    s2 += t2
    s1, s2 = quick_two_sum(s1, s2);

    AccurateDouble(s1, s2);
end

function fast_add(a::DoubleFloat64, b::DoubleFloat64)
    hi, lo = two_sum(a.hi, b.hi)
    lo += (a.lo + b.lo)
    hi, lo = quick_two_sum(hi, lo)

    FastDouble(hi, lo);
end
```
One can see that the accurate one needs around twice as many instructions.
