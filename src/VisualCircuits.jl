module VisualCircuits

# Implement math for two-tuples
import Base: +, -, *, /, getindex, connect
using Compose, Colors, Measures

include("TupleMath.jl")
include("core.jl")
export Block, connect, dots, render

include("LogicGates.jl")
export Gate

end # module
