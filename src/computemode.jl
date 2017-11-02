export ComputeMode, ComputeFast, ComputeAccurate

"""
    ComputeMode
"""
struct ComputeMode{T} end

"""
    ComputeFast

Shorthand for `ComputeMode{:fast}`
"""
const ComputeFast = ComputeMode{:fast}

"""
    ComputeAccurate

Shorthand for `ComputeMode{:ComputeAccurate}`
"""
const ComputeAccurate = ComputeMode{:ComputeAccurate}
Base.promote_rule(::Type{ComputeFast}, ::Type{ComputeAccurate}) = ComputeAccurate
