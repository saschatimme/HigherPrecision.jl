# Introduction

| **Documentation** | **Build Status** |
|:-----------------:|:----------------:|
| [![][docs-stable-img]][docs-stable-url] | [![Build Status][build-img]][build-url] |
| [![][docs-latest-img]][docs-latest-url] | [![Codecov branch][codecov-img]][codecov-url] |

HigherPrecision defines the following types
* `DoubleFloat64` - A 128 bit number type with around 30 bits of precision.

These types are intended as a drop-in replacement for `Float64` and `BigFloat`.
Besides the basic arithmetic functions the following mathematical functions are defined:

`sin`, `cos`, `inv`, `rem`, `divrem`, `mod`,
`sqrt`, `exp`, `log`, `sin`, `cos`, `tan`,
`asin`, `acos`, `atan`, `atan2`,
`sinh`, `cosh`, `sincos`, `sincosh`, `tanh`


Basic arithmetic operations are significantly faster than `BigFloat`, but the above
mathematical functions can be slower than the corresponding `BigFloat` methods. In general
this still should yield a significant performance boost.

## FMA Instructions
This library needs FMA instructions. If your processor supports these, you probably still need
to rebuild your Julia system image. This can be done as follows
```julia
include(joinpath(dirname(JULIA_HOME),"share","julia","build_sysimg.jl")); build_sysimg(force=true)
```
If you are on Windows you need to run the following code first
```julia
Pkg.add("WinRPM");
WinRPM.install("gcc", yes=true)
WinRPM.install("winpthreads-devel", yes=true)
```


## Example
```julia
# Simply convert an irrational number to a DoubleFloat64
double_π = DoubleFloat64(π)

# y is again a DoubleFloat64
y = rand() * double_π

# You can also create a DoubleFloat64 from a Float64
x = DoubleFloat64(0.42)

# And use the usual functions
sin(x * y)
```
## Acknowledgement
This library is a port of the [QD library](http://crd.lbl.gov/~dhbailey/mpdist/) from Yozo Hida (U.C. Berkeley),
Xiaoye S. Li (Lawrence Berkeley National Lab) and David H. Bailey (Lawrence Berkeley National Lab)
from C++ to Julia. See COPYING for the original modified BSD license. Also see [this](http://web.mit.edu/tabbott/Public/quaddouble-debian/qd-2.3.4-old/docs/qd.pdf) paper
for some background informations.


[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-stable-url]: https://saschatimme.github.io/HigherPrecision.jl/stable
[docs-latest-url]: https://saschatimme.github.io/HigherPrecision.jl/latest

[build-img]: https://travis-ci.org/saschatimme/HigherPrecision.jl.svg?branch=master
[build-url]: https://travis-ci.org/saschatimme/HigherPrecision.jl
[winbuild-img]: https://ci.appveyor.com/api/projects/status/h2yw6aoq480e1etd/branch/master?svg=true
[winbuild-url]: https://ci.appveyor.com/project/saschatimme/fixedpolynomials-jl/branch/master
[codecov-img]: https://codecov.io/gh/saschatimme/HigherPrecision.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/saschatimme/HigherPrecision.jl
