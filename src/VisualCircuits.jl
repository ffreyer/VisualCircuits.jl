module VisualCircuits

# Implement math for two-tuples
import Base: +, -, *, /
using Compose, Colors

include("TupleMath.jl")
include("core.jl")
include("LogicGates.jl")

export Block, Gate

end # module
