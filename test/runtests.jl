using HigherPrecision
using Base.Test


@testset "DoubleFloat64" begin
    @test DoubleFloat64(Float32(2.0)) == DoubleFloat64(2.0)
    @test DoubleFloat64(Float16(2.0)) == DoubleFloat64(2.0)
    @test DoubleFloat64(2) == DoubleFloat64(2.0)
    @test DoubleFloat64(big(π)) isa FastDouble
    @test DoubleFloat64(π) == DoubleFloat64(big(π))

    @test DoubleFloat64(Float32(2.0), ComputeAccurate) isa AccurateDouble
    @test DoubleFloat64(Float16(2.0), ComputeAccurate) isa AccurateDouble
    @test DoubleFloat64(2, ComputeAccurate) isa AccurateDouble
    @test DoubleFloat64(big(π), ComputeAccurate) isa AccurateDouble
    @test DoubleFloat64(π, ComputeAccurate) isa AccurateDouble

    @test HigherPrecision.hi(DoubleFloat64(2.0)) == 2.0
    @test HigherPrecision.lo(DoubleFloat64(2.0)) == 0.0

    @test isbits(FastDouble) == true
    @test isbits(AccurateDouble) == true

    @test zero(DoubleFloat64(2.0)) == zero(FastDouble)

    @test convert(Integer, DoubleFloat64(2.0)) isa Int64
    @test 32 ≤ length(string(rand(FastDouble))) ≤ 40

    @test double_sub(rand(), rand()) isa FastDouble
    @test double_add(rand(), rand()) isa FastDouble
    @test double_div(rand(), rand()) isa FastDouble
    @test double_mul(rand(), rand()) isa FastDouble


    x, y = rand(FastDouble), rand(AccurateDouble)

    @test x isa FastDouble
    @test y isa AccurateDouble
    @test x * y isa AccurateDouble
    @test y * x isa AccurateDouble
    @test x / y isa AccurateDouble
    @test y / x isa AccurateDouble
    @test x - y isa AccurateDouble
    @test y - x isa AccurateDouble
    @test x + y isa AccurateDouble
    @test y + x isa AccurateDouble
    @test x / 3.2 isa FastDouble
    @test y / 3.2 isa AccurateDouble

    @test x + 2 isa FastDouble
    @test 2 + x isa FastDouble

    @test x < 2 * x
    @test x ≤ x
    @test convert(Float64, x) ≤ x
    @test x ≤ 2 * convert(Float64, x)
    @test DoubleFloat64(2.0) == 2.0
    @test 2.0 == DoubleFloat64(2.0)

    @test isnan(DoubleFloat64(NaN))
    @test isinf(DoubleFloat64(Inf))

    @test floor(DoubleFloat64(3.2)) == 3.0
    @test ceil(DoubleFloat64(3.2)) == 4.0
    @test trunc(DoubleFloat64(3.2)) == 3.0
    @test isinteger(DoubleFloat64(3.2)) == false
    @test isinteger(DoubleFloat64(3.0)) == true

    @test rand(Base.Random.GLOBAL_RNG, FastDouble, 4) isa Vector{FastDouble}
    @test rand(Base.Random.GLOBAL_RNG, Complex{FastDouble}, 4) isa Vector{Complex{FastDouble}}
    @test rand(Complex{DoubleFloat64}, 3) isa Vector{Complex{FastDouble}}
    @test rand(Base.Random.GLOBAL_RNG, Complex{DoubleFloat64}, 4) isa Vector{Complex{FastDouble}}
    @test length(rand(Base.Random.GLOBAL_RNG, FastDouble, 4)) == 4

    for k = 1:5000
        x = rand(DoubleFloat64) * 20 - 10
        y = rand(DoubleFloat64) * 20 - 10
        @test x * y ≈ big(x) * big(y) atol=1e-29
        @test x + y ≈ big(x) + big(y) atol=1e-30
        @test x - y ≈ big(x) - big(y) atol=1e-30
        @test x / y ≈ big(x) / big(y) atol=1e-28
        @test x^5 ≈ BigFloat(x)^5 atol=1e-25

        @test exp(x) ≈ exp(big(x)) atol=1e-26
        @test log(abs(x)) ≈ log(big(abs(x))) atol=1e-29
        @test sin(x) ≈ sin(big(x)) atol=1e-30
        @test cos(x) ≈ cos(big(x)) atol=1e-30
        @test atan(x) ≈ atan(big(x)) atol=1e-30
        @test atan2(y, x) ≈ atan2(big(y), big(x)) atol=1e-30
        @test tan(x) ≈ tan(big(x)) atol=1e-21

        sinh_x, cosh_x = sincosh(x)
        if abs(x) > 0.05
            @test sinh(x) ≈ sinh(big(x)) atol=1e-25
            @test tanh(x) ≈ tanh(big(x)) atol=1e-25
            @test sinh_x ≈ sinh(big(x)) atol=1e-25
            @test cosh_x ≈ cosh(big(x)) atol=1e-25
        else
            @test sinh(x) ≈ sinh(big(x)) atol=1e-16
            @test tanh(x) ≈ tanh(big(x)) atol=1e-16
            @test sinh_x ≈ sinh(big(x)) atol=1e-16
            @test cosh_x ≈ cosh(big(x)) atol=1e-16
        end
        @test cosh(x) ≈ cosh(big(x)) atol=1e-20

        sin_x, cos_x = sincos(x)
        @test sin_x ≈ sin(big(x)) atol=1e-30
        @test cos_x ≈ cos(big(x)) atol=1e-30

        z = DoubleFloat64(rand() * 2 - 1)
        @test asin(z) ≈ asin(big(z)) atol=1e-30
        @test acos(z) ≈ acos(big(z)) atol=1e-30
    end


    for k = 1:5000
        x = rand(DoubleFloat64{ComputeAccurate}) * 20 - 10
        y = rand(DoubleFloat64{ComputeAccurate}) * 20 - 10
        @test x * y ≈ big(x) * big(y) atol=1e-29
        @test x + y ≈ big(x) + big(y) atol=1e-31
        @test x - y ≈ big(x) - big(y) atol=1e-31
        @test x / y ≈ big(x) / big(y) atol=1e-28
        @test x^5 ≈ BigFloat(x)^5 atol=1e-26

        @test exp(x) ≈ exp(big(x)) atol=1e-26
        @test log(abs(x)) ≈ log(big(abs(x))) atol=1e-29
        @test sin(x) ≈ sin(big(x)) atol=1e-30
        @test cos(x) ≈ cos(big(x)) atol=1e-30
        @test atan(x) ≈ atan(big(x)) atol=1e-30
        @test atan2(y, x) ≈ atan2(big(y), big(x)) atol=1e-30
        @test tan(x) ≈ tan(big(x)) atol=1e-21

        sinh_x, cosh_x = sincosh(x)
        if abs(x) > 0.05
            @test sinh(x) ≈ sinh(big(x)) atol=1e-25
            @test tanh(x) ≈ tanh(big(x)) atol=1e-25
            @test sinh_x ≈ sinh(big(x)) atol=1e-25
            @test cosh_x ≈ cosh(big(x)) atol=1e-25
        else
            @test sinh(x) ≈ sinh(big(x)) atol=1e-16
            @test tanh(x) ≈ tanh(big(x)) atol=1e-16
            @test sinh_x ≈ sinh(big(x)) atol=1e-16
            @test cosh_x ≈ cosh(big(x)) atol=1e-16
        end
        @test cosh(x) ≈ cosh(big(x)) atol=1e-20

        sin_x, cos_x = sincos(x)
        @test sin_x ≈ sin(big(x)) atol=1e-30
        @test cos_x ≈ cos(big(x)) atol=1e-30

        z = DoubleFloat64(rand() * 2 - 1)
        @test asin(z) ≈ asin(big(z)) atol=1e-30
        @test acos(z) ≈ acos(big(z)) atol=1e-30
    end



    @test eps(DoubleFloat64) == 4.93038065763132e-32 # 2^-104
    @test realmin(DoubleFloat64) > realmin(Float64)
    @test realmax(DoubleFloat64) > realmax(Float64)
end
