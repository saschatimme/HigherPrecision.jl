var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Introduction-1",
    "page": "Introduction",
    "title": "Introduction",
    "category": "section",
    "text": "HigherPrecision defines the following typesDoubleFloat64 - A 128 bit number type with around 30 bits of precision.These types are intended as a drop-in replacement for Float64 and BigFloat. Besides the basic arithmetic functions the following mathematical functions are defined:sin, cos, inv, rem, divrem, mod, sqrt, exp, log, sin, cos, tan, asin, acos, atan, atan2, sinh, cosh, sincos, sincosh, tanhBasic arithmetic operations are significantly faster than BigFloat, but the above mathematical functions can be slower than the corresponding BigFloat methods. In general this still should yield a significant performance boost.note: Note\nThis library needs FMA instructions. If your processor supports these, you probably still need to rebuild your Julia system image. This can be done as followsinclude(joinpath(dirname(JULIA_HOME),\"share\",\"julia\",\"build_sysimg.jl\")); build_sysimg(force=true)If you are on Windows you need to run the following code firstPkg.add(\"WinRPM\");\nWinRPM.install(\"gcc\", yes=true)\nWinRPM.install(\"winpthreads-devel\", yes=true)"
},

{
    "location": "index.html#Example-1",
    "page": "Introduction",
    "title": "Example",
    "category": "section",
    "text": "# Simply convert an irrational number to a DoubleFloat64\ndouble_π = DoubleFloat64(π)\n\n# y is again a DoubleFloat64\ny = rand() * double_π\n\n# You can also create a DoubleFloat64 from a Float64\nx = DoubleFloat64(0.42)\n\n# And use the usual functions\nsin(x)"
},

{
    "location": "index.html#Acknowledgement-1",
    "page": "Introduction",
    "title": "Acknowledgement",
    "category": "section",
    "text": "This library is a port of the QD library from Yozo Hida (U.C. Berkeley), Xiaoye S. Li (Lawrence Berkeley National Lab) and David H. Bailey (Lawrence Berkeley National Lab) from C++ to Julia. See COPYING for the original modified BSD license. Also see this paper for some background informations."
},

{
    "location": "computemode.html#",
    "page": "Compute mode",
    "title": "Compute mode",
    "category": "page",
    "text": ""
},

{
    "location": "computemode.html#Compute-Mode-1",
    "page": "Compute mode",
    "title": "Compute Mode",
    "category": "section",
    "text": "For addition, subtraction and division we implement two versions, a accurate one (which satisfies an IEEE style error bound) and a less accurate one which is significantly faster. We leverage Julia's type system to support both versions seamlessly."
},

{
    "location": "computemode.html#Types-1",
    "page": "Compute mode",
    "title": "Types",
    "category": "section",
    "text": ""
},

{
    "location": "computemode.html#HigherPrecision.ComputeMode",
    "page": "Compute mode",
    "title": "HigherPrecision.ComputeMode",
    "category": "Type",
    "text": "ComputeMode\n\n\n\n"
},

{
    "location": "computemode.html#HigherPrecision.ComputeFast",
    "page": "Compute mode",
    "title": "HigherPrecision.ComputeFast",
    "category": "Type",
    "text": "ComputeFast\n\nShorthand for ComputeMode{:fast}\n\n\n\n"
},

{
    "location": "computemode.html#HigherPrecision.ComputeAccurate",
    "page": "Compute mode",
    "title": "HigherPrecision.ComputeAccurate",
    "category": "Type",
    "text": "ComputeAccurate\n\nShorthand for ComputeMode{:ComputeAccurate}\n\n\n\n"
},

{
    "location": "computemode.html#ComputeMode-1",
    "page": "Compute mode",
    "title": "ComputeMode",
    "category": "section",
    "text": "ComputeMode\nComputeFast\nComputeAccurate"
},

{
    "location": "computemode.html#HigherPrecision.DoubleFloat64",
    "page": "Compute mode",
    "title": "HigherPrecision.DoubleFloat64",
    "category": "Type",
    "text": "DoubleFloat64(x [, mode::ComputeMode])\n\n\n\n"
},

{
    "location": "computemode.html#HigherPrecision.FastDouble",
    "page": "Compute mode",
    "title": "HigherPrecision.FastDouble",
    "category": "Type",
    "text": "FastDouble\n\nShorthand for DoubleFloat64{ComputeFast}\n\n\n\n"
},

{
    "location": "computemode.html#HigherPrecision.AccurateDouble",
    "page": "Compute mode",
    "title": "HigherPrecision.AccurateDouble",
    "category": "Type",
    "text": "AccurateDouble\n\nShorthand for DoubleFloat64{ComputeAccurate}\n\n\n\n"
},

{
    "location": "computemode.html#DoubleFloat64-1",
    "page": "Compute mode",
    "title": "DoubleFloat64",
    "category": "section",
    "text": "DoubleFloat64\nFastDouble\nAccurateDouble"
},

{
    "location": "computemode.html#Promotion-1",
    "page": "Compute mode",
    "title": "Promotion",
    "category": "section",
    "text": "By default we will create a FastDouble, but the product (or sum) of a FastDouble and an AccurateDouble is an AccurateDouble."
},

{
    "location": "computemode.html#What's-the-difference-exactly?-1",
    "page": "Compute mode",
    "title": "What's the difference exactly?",
    "category": "section",
    "text": "As an example, here are the implementations for addition for DoubleFloat64s:function accurate_add(a::DoubleFloat64, b::DoubleFloat64)\n    s1, s2 = two_sum(a.hi, b.hi)\n    t1, t2 = two_sum(a.lo, b.lo)\n    s2 += t1\n    s1, s2 = quick_two_sum(s1, s2);\n    s2 += t2\n    s1, s2 = quick_two_sum(s1, s2);\n\n    AccurateDouble(s1, s2);\nend\n\nfunction fast_add(a::DoubleFloat64, b::DoubleFloat64)\n    hi, lo = two_sum(a.hi, b.hi)\n    lo += (a.lo + b.lo)\n    hi, lo = quick_two_sum(hi, lo)\n\n    FastDouble(hi, lo);\nendOne can see that the accurate one needs around twice as many instructions."
},

{
    "location": "reference.html#",
    "page": "Reference",
    "title": "Reference",
    "category": "page",
    "text": ""
},

{
    "location": "reference.html#Reference-1",
    "page": "Reference",
    "title": "Reference",
    "category": "section",
    "text": ""
},

{
    "location": "reference.html#DoubleFloat64-1",
    "page": "Reference",
    "title": "DoubleFloat64",
    "category": "section",
    "text": "double_add\ndouble_sub\ndouble_mul\ndouble_div\ndouble_square\ndouble_sqrt\nsincos\nsincosh"
},

]}
