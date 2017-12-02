struct Block
    composition::Compose.Context
    connections::Union{Dict{Symbol, XYTuple}, Vector{XYTuple}}
end


function Block(x::Real, y::Real, tag::Symbol, inputs=[:in1, :in2]; kwargs...)
    logic_tags = [:NOT, :AND, :OR, :XOR, :NAND, :NOR, :XNOR]
    if tag in logic_tags
        return Gate(x, y, tag, inputs, kwargs...)
    end
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


function IC(
        x::Real, y::Real, pins::Matrix{Symbol};
        scale_x::Real = 1.0, scale_y::Real = 1.0, text_offset::Float64 = 0.05,
        _fontsize = fontsize(20pt), _font = font("Helvetica-Bold")
    )
    M, N = size(pins)
    p = (x, y)
    sx, sy = scale_x, scale_y

    rot = Rotation(pi/2)
    if M > N
        # vertical layout
        @assert (N == 2) "pins should be ($M, 2)"
        width, height = 1.5sx, M * 0.5sy
        left = partition(p + (-0.5width, -0.5height), p + (-0.5width, 0.5height), M)
        right = partition(p + (0.5width, -0.5height), p + (0.5width, 0.5height), M)
        connections = Dict{Symbol, XYTuple}(map(Pair, pins[:], [left..., right...][:]))

        text_comp = compose(
            context(),
            map(pins[:, 1], left) do s, tp
                text(tp[1] + text_offset, tp[2], string(s), hleft, vcenter)
            end...,
            map(pins[:, 2], right) do s, tp
                text(tp[1] - text_offset, tp[2], string(s), hright, vcenter)
            end...,
            linewidth(0mm), _fontsize, _font, fill("black")
        )
    else
        # horizontal layout
        @assert (M == 2) "pins should be (2, $N)"
        width, height = N * 0.5sx, 1.5sy
        top = partition(p + (-0.5width, -0.5height), p + (0.5width,- 0.5height), N)
        bot = partition(p + (-0.5width, 0.5height), p + (0.5width, 0.5height), N)
        connections = Dict{Symbol, XYTuple}(
            map(Pair, permutedims(pins, (2, 1))[:], [top..., bot...][:])...
        )

        text_comp = compose(
            context(),
            map(pins[1, :], top) do s, tp
                rot = Rotation(pi/2, tp[1], tp[2] + text_offset*sy)
                text(tp[1], tp[2] + text_offset*sy, string(s), hleft, vcenter, rot)
            end...,
            map(pins[2, :], bot) do s, tp
                rot = Rotation(pi/2, tp[1], tp[2] - text_offset*sy)
                text(tp[1], tp[2] - text_offset*sy, string(s), hright, vcenter, rot)
            end...,
            linewidth(0.0mm), _fontsize, _font, fill("black")
        )
    end
    composition = compose(
        context(),
        text_comp,
        compose(
            context(),
            rectangle(x - 0.5width, y - 0.5height, width, height),
            fill(nothing)
        )
    )

    return Block(composition, connections)
end


# function IC16(
#         x::Real, y::Real, pins::Vector{Symbol}=Symbol[];
#         name::String = "", #rot::Symbol=:h,
#         scale_x::Real=1.0, scale_y::Real=1.0
#     )
#     p = (x, y)
#     sx, sy = scale_x, scale_y
#
#     bottom = partition(p + (-1sx, -0.5sy), p + (1sx, -0.5sy), 8)
#     top = partition(p + (1sx, 0.5sy), p + (-1sx, 0.5sy), 8)
#     connections = if isempty(pins)
#         [bottom..., top...]
#     else
#         @assert (length(pins) == 16) """
#         16 pins should be given, but only $(length(pins)) were.
#         """
#         Dict{Symbol, XYTuple}(
#         map((label, pos) -> Pair(label, pos), pins, [bottom..., top...])...
#         )
#     end
#     composition = compose(
#         context(
#             x-1.05sx, y-0.55sy, 2.1sx, 1.1sy,
#             units = UnitBox(-1.05, -0.55, 2.1, 1.1)
#         ),
#         rectangle(-1.0, -0.5, 2.0, 1.0),
#         render(0.0, 0.0, name)
#     )
#     return Block(composition, connections)
# end




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
