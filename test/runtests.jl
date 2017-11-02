using HigherPrecision
using Base.Test


@testset "DoubleFloat64" begin
    x, y = rand(FastDouble), rand(AccurateDouble)

    @test x isa FastDouble
    @test y isa AccurateDouble
    @test x * y isa AccurateDouble
    @test x / y isa AccurateDouble
    @test x - y isa AccurateDouble
    @test x + y isa AccurateDouble


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
