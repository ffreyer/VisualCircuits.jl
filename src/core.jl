struct Block
    composition::Compose.Context
    connections::Union{Dict{Symbol, XYTuple}, Vector{XYTuple}}
end


function Block(x::Real, y::Real, tag::Symbol, inputs=[:in1, :in2]; kwargs...)
    logic_tags = [:NOT, :AND, :OR, :XOR, :NAND, :NOR, :XNOR]
    if tag in logic_tags
        return logic_block(x, y, tag, inputs, kwargs...)
    end
end


function getindex(B::Block, tag::Symbol)
    if typeof(B.connections) == Dict{Symbol, XYTuple}
        return B.connections[tag]
    else
        throw(ErrorException("Block uses integer indices!"))
    end
end

function getindex(B::Block, i::Integer)
    if typeof(B.connections) == Dict{Symbol, XYTuple}
        throw(ErrorException("Block uses symbol indices!"))
    else
        return B.connections[i]
    end
end
