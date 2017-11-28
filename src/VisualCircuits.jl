module VisualCircuits

# Implement math for two-tuples
import Base: +, -, *, /, getindex, connect
using Compose, Colors, Measures

include("TupleMath.jl")
include("core.jl")
export Block

include("LogicGates.jl")
export Gate

include("BlockUtils.jl")
export connect, dots, render, autosize

end # module
