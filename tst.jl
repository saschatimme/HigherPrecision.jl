using HigherPrecision
using BenchmarkTools

u = rand(Complex128, 128)


rand(Complex{FastDouble})

rand(Complex{DoubleFloat64})


w = rand(Complex{DoubleFloat64}, 128)

w1, w2 = first(w), last(w)

@benchmark *($w1, $w2)


function unroll(xs::AbstractVector{T}) where T
    out = one(T)
    N = length(xs)
    reminder = rem(N, 4)
    i = 1
    while i < (N - reminder)
        @inbounds a = xs[i] * xs[i + 1]
        @inbounds b = xs[i + 2] * xs[i + 3]
        out *= (a * b)

        i += 4
    end

    if reminder == 0
        return out
    end
    @inbounds out *= xs[i]
    if reminder == 1
        return out
    end
    @inbounds out *= xs[i + 1]
    if reminder == 2
        return out
    end
    @inbounds out *= xs[N]

    out
end


prod(w)
unroll(w)








function rprod_loop(xs::Vector{Complex{T}}) where T
    out = one(Complex{T})
    N = length(xs)
    i = N
    while i > 0
        @inbounds a = xs[i] * xs[i - 1]
        @inbounds b = xs[i - 2] * xs[i - 3]
        ab = a * b

        out *= ab

        i -= 4
    end
    out
end
u = rand(Complex128, 257)
prod_loop()

prod(u)
prod_loop(u)
@code_llvm prod_loop(u)
@benchmark prod_loop($u)
@benchmark prod($u)


@benchmark rprod_loop($u)



@benchmark prod($u)


xs = ComplexVec([1+2im, 2+3im])
prod_loop(xs)

@benchmark prod_loop($v)
prod(u)

@benchmark prod_loop($v)


@benchmark prod($u)










x = rand(DoubleFloat64, 1024)
y = rand(DoubleFloat64, 64)

a = rand(Complex128, 1048)
b = rand(Complex128, 64)


@benchmark prod()


@benchmark prod($x)
@benchmark prod($a)

@benchmark prod($y)
@benchmark prod($b)



@benchmark prod($y)

z = rand(DoubleFloat64)

@code_llvm *(z, z)

@code_llvm *(a, b)

u1, u2, u3 = rand(3)
@benchmark muladd($u1, $u2, $u3)

naivemuladd(a, b, c) = a * b + c
@benchmark fma($u1, $u2, $u3)
