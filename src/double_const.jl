# these are used internally
const double_π = DoubleFloat64(pi)
const double_2pi = convert(FastDouble, 2 * BigFloat(Base.pi))
const double_pi = convert(FastDouble, Base.pi)
const double_pi2 = convert(FastDouble, BigFloat(Base.pi) * 0.5)
const double_pi4 = convert(FastDouble, BigFloat(Base.pi) * 0.25)
const double_pi16 = convert(FastDouble, BigFloat(Base.pi) * (1/16))
const double_3pi4 = convert(FastDouble, BigFloat(Base.pi) * 0.75)
const double_nan = DoubleFloat64{ComputeFast}(NaN, NaN)
const double_inf = DoubleFloat64{ComputeFast}(Inf)
const double_e = convert(FastDouble, Base.e)

const double_log2 = convert(FastDouble, log(BigFloat(2.0)))
const double_log10 = convert(FastDouble, log(BigFloat(10.0)))

const double_eps = 4.93038065763132e-32 # 2^-104
