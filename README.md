# HigherPrecision.jl

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

# Acknowledgement
This library is a port of the [QD library](http://crd.lbl.gov/~dhbailey/mpdist/) from Yozo Hida (U.C. Berkeley),
Xiaoye S. Li (Lawrence Berkeley Natl Lab) and David H. Bailey (Lawrence Berkeley Natl Lab)
from C++ to Julia. See COPYING for the original modified BSD license. Also see [this](http://web.mit.edu/tabbott/Public/quaddouble-debian/qd-2.3.4-old/docs/qd.pdf) paper
for some background informations.
