# these are used internally
const double_π = DoubleFloat64(pi)
const double_2pi = convert(DoubleFloat64, 2 * BigFloat(Base.pi))
const double_pi = convert(DoubleFloat64, Base.pi)
const double_pi2 = convert(DoubleFloat64, BigFloat(Base.pi) * 0.5)
const double_pi4 = convert(DoubleFloat64, BigFloat(Base.pi) * 0.25)
const double_pi16 = convert(DoubleFloat64, BigFloat(Base.pi) * (1/16))
const double_3pi4 = convert(DoubleFloat64, BigFloat(Base.pi) * 0.75)
const double_nan = DoubleFloat64(NaN, NaN)
const double_inf = DoubleFloat64(Inf)
const double_e = convert(DoubleFloat64, Base.e)

const double_log2 = convert(DoubleFloat64, log(BigFloat(2.0)))
const double_log10 = convert(DoubleFloat64, log(BigFloat(10.0)))

const double_eps = 4.93038065763132e-32 # 2^-104
