struct Block
    composition::Compose.Context
    connections::Union{Dict{Symbol, XYTuple}, Vector{XYTuple}}
end
