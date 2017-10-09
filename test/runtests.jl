using HigherPrecision
using Base.Test


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
    @test tan(x) ≈ tan(big(x)) atol=1e-23

    if abs(x) > 0.05
        @test sinh(x) ≈ sinh(big(x)) atol=1e-25
        @test tanh(x) ≈ tanh(big(x)) atol=1e-25
    else
        @test sinh(x) ≈ sinh(big(x)) atol=1e-16
        @test tanh(x) ≈ tanh(big(x)) atol=1e-16
    end
    @test cosh(x) ≈ cosh(big(x)) atol=1e-20


    sin_x, cos_x = Qd.sincos(x)
    @test sin_x ≈ sin(big(x)) atol=1e-30
    @test cos_x ≈ cos(big(x)) atol=1e-30

    z = DoubleFloat64(rand() * 2 - 1)
    @test asin(z) ≈ asin(big(z)) atol=1e-30
    @test acos(z) ≈ acos(big(z)) atol=1e-30
end

@test eps(DoubleFloat64) == 4.93038065763132e-32 # 2^-104
@test realmin(DoubleFloat64) < realmin(Float64)
@test realmax(DoubleFloat64) > realmax(Float64)
