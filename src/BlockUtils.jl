"""
    connect(points...)

returns a line connecting all points.
"""
function connect(points::XYTuple...)
    line([points...])
end

"""
    connect(point, x, dir=:x)

Connects point to (x, point[2]) if dir is :x or to (point[1], x) if dir is :y
"""
function connect(point::XYTuple, x::Real, dir=:x)
    if dir == :x
        return line([point, (x, point[2])])
    elseif dir == :y
        return line([point, (point[1], x)])
    else
        println("dir :", string(dir), " not recognized.")
    end
    return nothing
end


"""
    dots(points...)

Render circles at points to signify electrical connections
"""
function dots(points::XYTuple...; lw::Measures.Length=1mm)
    radius = .10# * lw / 1mm
    compose(
        context(),
        map(points) do p
            circle(p[1], p[2], radius)
        end...,
        fill("Black"),
        linewidth(0mm)
    )
end


"""
    render(renderable::Block)

Returns the render context of a Block.
"""
function render(renderable::Block)
    renderable.composition
end


# function render(renderable::Block, args...)
#     compose(
#         context(units=UnitBox(0, 0, 6, 6)),
#         renderable.composition,
#         args...
#     )
# end


"""
    render(
        pstrs...;
        _fontsize = fontsize(40pt),
        _font = font("Helvetica-Bold")
    )

Given Tuples (pos, text), this function will generate a renderable object with
text centered around pos.
"""
function render(
        pstrs::Union{Tuple{Tuple{Real, Real}, String}, Tuple{Real, Real, String}}...;
        _fontsize::Compose.Property{Compose.FontSizePrimitive} = fontsize(40pt),
        _font::Compose.Property{Compose.FontPrimitive} = font("Helvetica-Bold")
    )

    texts = map(pstrs) do pstr
        if typeof(pstr) <: Tuple{Tuple{Real, Real}, String}
            (x, y), s = pstr
        else
            x, y, s = pstr
        end
        text(x, y, s, hcenter, vcenter)
    end
    compose(
        context(), texts...,
        linewidth(0mm), _fontsize, _font
    )
end


"""
    autosize(width, height)

Generate sensable sizes based on the circuit width and height.
"""
function autosize(width, height, w_scale=3cm, h_scale=3cm)
    width * w_scale, height * h_scale
end
