"""
    Gate(x, y, logic)

Constructs a logic gate at position (x, y) and returns type Block. Acceptable
inputs for logic are (:AND, :NAND, :OR, :NOR, :XOR, :XNOR and :NOT)
"""
function Gate(
        x::Real, y::Real, logic::Symbol, inputs=[:in1, :in2],
        output=:out, scale_x=1.0, scale_y=0.8
    )
    if      logic == :AND   return and_gate(x, y, inputs, output, scale_x, scale_y)
    elseif  logic == :NAND  return nand_gate(x, y, inputs, output, scale_x, scale_y)
    elseif  logic == :OR    return or_gate(x, y, inputs, output, scale_x, scale_y)
    elseif  logic == :NOR   return nor_gate(x, y, inputs, output, scale_x, scale_y)
    elseif  logic == :XOR   return xor_gate(x, y, inputs, output, scale_x, scale_y)
    elseif  logic == :XNOR  return xnor_gate(x, y, inputs, output, scale_x, scale_y)
    elseif  logic == :NOT   return not_gate(x, y, inputs, output, scale_x, scale_y)
    else
        println("Failed to recognize Logic")
        return nothing
    end
end


# Basic shape of AND
function and_base()
    compose(
        context(),
        line([(0.001, 1), (-1, 1), (-1, -1), (0.001, -1)]),
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
        curve((-1.2, -1), (-0.7, -0.5), (-0.7, 0.5), (-1.2, 1)),
        curve((-1, 1), (0, 1), (0.5, 1), (1, 0)),
        curve((-1, -1), (0, -1), (0.5, -1), (1, 0))
    )
end


function and_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    p = (x, y)
    in_pos = partition(
        p + 0.5 * (-1sx, -1sy),
        p + 0.5 * (-1sx, 1sy),
        length(inputs)
    )
    connections = Dict{Symbol, XYTuple}(
        map((label, pos) -> Pair(label, pos), inputs, in_pos)...,
        :out => p + 0.5 * (1sx, 0sy)
    )
    composition = compose(
        context(
            x-0.55sx, y-0.55sy, 1.1sx, 1.1sy,
            units = UnitBox(-1.1, -1.1, 2.2, 2.2)
        ),
        and_base()
    )
    return Block(composition, connections)
end


function nand_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    p = (x, y)
    in_pos = partition(
        p + 0.5 * (-1sx, -1sy),
        p + 0.5 * (-1sx, 1sy),
        length(inputs)
    )
    connections = Dict{Symbol, XYTuple}(
        map((label, pos) -> Pair(label, pos), inputs, in_pos)...,
        :out => p + 0.5 * (1.4sx, 0.0sy)
    )
    composition = compose(
        context(
            x-0.55sx, y-0.55sy, 1.3sx, 1.1sy,
            units = UnitBox(-1.1, -1.1, 2.6, 2.2)
        ),
        and_base(),
        (context(), circle(1.2sx, 0, 0.2sx), fill(nothing))
    )
    return Block(composition, connections)
end


function or_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    @assert (length(inputs) == 2) "Only two inputs are implemented for OR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025sx, -0.5sy),
        inputs[2] => p + 0.5 * (-0.7025sx, 0.5sy),
        :out      => p + 0.5 * (1sx, 0sy)
    )
    composition = compose(
        context(
            x-0.55sx, y-0.55sy, 1.1sx, 1.1sy,
            units = UnitBox(-1.1, -1.1, 2.2, 2.2)
        ),
        or_base()
    )
    return Block(composition, connections)
end


function nor_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    @assert (length(inputs) == 2) "Only two inputs are implemented for NOR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025sx, -0.5sy),
        inputs[2] => p + 0.5 * (-0.7025sx, 0.5sy),
        :out      => p + 0.5 * (1.4sx, 0.0sy)
    )
    composition = compose(
        context(
            x-0.55sx, y-0.55sy, 1.3sx, 1.1sy,
            units = UnitBox(-1.1, -1.1, 2.6, 2.2)
        ),
        or_base(),
        (context(), circle(1.2sx, 0, 0.2sx), fill(nothing))
    )
    return Block(composition, connections)
end


function xor_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    @assert (length(inputs) == 2) "Only two inputs are implemented for OR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025sx, -0.5sy),
        inputs[2] => p + 0.5 * (-0.7025sx, 0.5sy),
        :out      => p + 0.5 * (1sx, 0sy)
    )
    composition = compose(
        context(
            x-0.6sx, y-0.55sy, 1.15sx, 1.1sy,
            units = UnitBox(-1.2, -1.1, 2.3, 2.2)
        ),
        xor_base()
    )
    return Block(composition, connections)
end


function xnor_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    @assert (length(inputs) == 2) "Only two inputs are implemented for NOR."
    p = (x, y)
    connections = Dict{Symbol, XYTuple}(
        inputs[1] => p + 0.5 * (-0.7025sx, -0.5sy),
        inputs[2] => p + 0.5 * (-0.7025sx, 0.5sy),
        :out      => p + 0.5 * (1.4sx, 0.0sy)
    )
    composition = compose(
        context(
            x-0.6sx, y-0.55sy, 1.35sx, 1.1sy,
            units = UnitBox(-1.2, -1.1, 2.7, 2.2)
        ),
        xor_base(),
        (context(), circle(1.2sx, 0, 0.2sx), fill(nothing))
    )
    return Block(composition, connections)
end


function not_gate(x, y, inputs, output=:out, sx=1.0, sy=1.0)
    p = (x, y)
    in_pos = partition(
        p + 0.5 * (-1.0sx, -1.0sy),
        p + 0.5 * (-1.0sx, 1.0sy),
        length(inputs)
    )
    connections = Dict{Symbol, XYTuple}(
        map((label, pos) -> Pair(label, pos), inputs, in_pos)...,
        :out => p + 0.5 * (1.0sx, 0.0sy)
    )
    composition = compose(
        context(
            x-0.55sx, y-0.55sy, 1.1sx, 1.1sy,
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
