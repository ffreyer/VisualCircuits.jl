"""
    Gate(x, y, logic)

Constructs a logic gate at position (x, y) and returns type Block. Acceptable
inputs for logic are (:AND, :NAND, :OR, :NOR, :XOR, :XNOR and :NOT)
"""
function Gate(x::Real, y::Real, logic::Symbol, inputs=[:in1, :in2])
    if      logic == :AND   return and_gate(x, y, inputs)
    elseif  logic == :NAND  return nand_gate(x, y, inputs)
    elseif  logic == :OR    return or_gate(x, y, inputs)
    elseif  logic == :NOR   return nor_gate(x, y, inputs)
    elseif  logic == :XOR   return xor_gate(x, y, inputs)
    elseif  logic == :XNOR  return xnor_gate(x, y, inputs)
    elseif  logic == :NOT   return not_gate(x, y, inputs)
    else
        println("Failed to recognize Logic")
        return nothing
    end
end


# Basic shape of AND
function and_base()
    compose(
        context(),
        line([(0, 1), (-1, 1), (-1, -1), (0, -1)]),
        curve((0, 1), (4/3, 1), (4/3, -1), (0, -1))
    )
end

# Basic shape of OR
function or_base()
    compose(
        context(),
        curve((-1, -1), (-0.5, -0.5), (-0.5, 0.5), (-1, 1)),
        curve((-1, 1), (0, 1), (0.5, 1), (1, 0)),
        curve((-1, -1), (0, -1), (0.5, -1), (1, 0))
    )
end

# Basic shape of XOR
function xor_base()
    compose(
        context(),
        curve((-1, -1), (-0.5, -0.5), (-0.5, 0.5), (-1, 1)),
        curve((-1.1, -1), (-0.6, -0.5), (-0.6, 0.5), (-1.1, 1)),
        curve((-1, 1), (0, 1), (0.5, 1), (1, 0)),
        curve((-1, -1), (0, -1), (0.5, -1), (1, 0))
    )
end


function and_gate(x, y, inputs, output=:out)
    p = (x, y)
    in_pos = partition(p + 0.5 * (-1, -1), p + 0.5 * (-1, 1), length(inputs))
    connections = Dict{Symbol, XYTuple}(
        map((label, pos) -> Pair(label, pos), inputs, in_pos)...,
        :out => p + 0.5 * (1, 0)
    )
    composition = compose(
        context(
            x-0.55, y-0.55, 1.1, 1.1,
            units = UnitBox(-1.1, -1.1, 2.2, 2.2)
        ),
        and_base()
    )
    return Block(composition, connections)
end


function nand_gate(x, y, inputs, output=:out)
    p = (x, y)
    in_pos = partition(p + 0.5 * (-1, -1), p + 0.5 * (-1, 1), length(inputs))
    connections = Dict{Symbol, XYTuple}(
        map((label, pos) -> Pair(label, pos), inputs, in_pos)...,
        :out => p + 0.5 * (1.3, 0.0)
    )
    composition = compose(
        context(
            x-0.55, y-0.55, 1.3, 1.1,
            units = UnitBox(-1.1, -1.1, 2.6, 2.2)
        ),
        and_base(),
        (context(), circle(1.2, 0, 0.2), fill(nothing))
    )
    return Block(composition, connections)
end


function or_gate(x, y, inputs, output=:out)
    @assert (length(inputs) == 2) "Only two inputs are implemented for OR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025, -0.5),
        inputs[2] => p + 0.5 * (-0.7025, 0.5),
        :out      => p + 0.5 * (1, 0)
    )
    composition = compose(
        context(
            x-0.55, y-0.55, 1.1, 1.1,
            units = UnitBox(-1.1, -1.1, 2.2, 2.2)
        ),
        or_base()
    )
    return Block(composition, connections)
end


function nor_gate(x, y, inputs, output=:out)
    @assert (length(inputs) == 2) "Only two inputs are implemented for NOR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025, -0.5),
        inputs[2] => p + 0.5 * (-0.7025, 0.5),
        :out      => p + 0.5 * (1.3, 0.0)
    )
    composition = compose(
        context(
            x-0.55, y-0.55, 1.3, 1.1,
            units = UnitBox(-1.1, -1.1, 2.6, 2.2)
        ),
        or_base(),
        (context(), circle(1.2, 0, 0.2), fill(nothing))
    )
    return Block(composition, connections)
end


function xor_gate(x, y, inputs, output=:out)
    @assert (length(inputs) == 2) "Only two inputs are implemented for OR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025, -0.5),
        inputs[2] => p + 0.5 * (-0.7025, 0.5),
        :out      => p + 0.5 * (1, 0)
    )
    composition = compose(
        context(
            x-0.6, y-0.55, 1.15, 1.1,
            units = UnitBox(-1.2, -1.1, 2.3, 2.2)
        ),
        xor_base()
    )
    return Block(composition, connections)
end


function xnor_gate(x, y, inputs, output=:out)
    @assert (length(inputs) == 2) "Only two inputs are implemented for NOR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025, -0.5),
        inputs[2] => p + 0.5 * (-0.7025, 0.5),
        :out      => p + 0.5 * (1.3, 0.0)
    )
    composition = compose(
        context(
            x-0.6, y-0.55, 1.35, 1.1,
            units = UnitBox(-1.2, -1.1, 2.7, 2.2)
        ),
        xor_base(),
        (context(), circle(1.2, 0, 0.2), fill(nothing))
    )
    return Block(composition, connections)
end


function not_gate(x, y, inputs, output=:out)
    p = (x, y)
    in_pos = partition(p + 0.5 * (-1.0, -1.0), p + 0.5 * (-1.0, 1.0), length(inputs))
    connections = Dict{Symbol, XYTuple}(
        map((label, pos) -> Pair(label, pos), inputs, in_pos)...,
        :out => p + 0.5*(1.0, 0.)
    )
    composition = compose(
        context(
            x-0.55, y-0.55, 1.1, 1.1,
            units = UnitBox(-1.1, -1.1, 2.2, 2.2)
        ),
        (
            context(),
            polygon([(-1, -1), (-1, 1), (0.68, 0.)]),
            circle(0.85, 0, 0.15),
            fill(nothing)
        )
    )
    return Block(composition, connections)
end

# function bezier(anchor1, ctrl1, ctrl2, anchor2)
#     f(t) = (1 - t)^3 * anchor1 +
#         3 * t * (1 - t)^2 * (anchor1 + ctrl1) +
#         3 * t^2 * (1 - t) * (anchor2 - ctrl2) +
#         t^3 * anchor2
# end
