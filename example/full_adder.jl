using VisualCircuits, Compose

begin
    width, height = 8, 3.8

    xor1 = Gate(3, 1, :XOR)
    xor2 = Gate(6, 1.4, :XOR)
    and1 = Gate(4.8, 2.5, :AND)
    and2 = Gate(4.8, 3.5, :AND)
    or = Gate(6.5, 3, :OR)

    x0 = 1
    x1 = 7.5

    circuit = compose(
        context(units = UnitBox(0.4, 0.4, width, height)),
        map(render, [xor1, xor2, and1, and2, or])...,

        # inputs
        connect(xor1[:in1], x0),
        connect(xor1[:in2], x0),
        connect(xor2[:in2], x0),
        # xor -> xor
        connect(xor1[:out], xor1[:out]+(1, 0), xor2[:in1]-(1,0), xor2[:in1]),
        # -> and1
        connect(xor1[:out]+(.4, 0), and1[:in1]-(.4, 0), and1[:in1]),
        connect(and1[:in2]-(0.8, 1.1), and1[:in2]-(0.8, 0), and1[:in2]),
        # -> and2
        connect(and2[:in1]-(2.2, 2.5), and2[:in1]-(2.2, 0), and2[:in1]),
        connect(and2[:in2]-(2.6, 2.5), and2[:in2]-(2.6, 0), and2[:in2]),
        # and + and -> or
        connect(and1[:out], and1[:out]+(.35,0), or[:in1]-(.35,0), or[:in1]),
        connect(and2[:out], and2[:out]+(.35,0), or[:in2]-(.35,0), or[:in2]),
        # outputs
        connect(xor2[:out], x1),
        connect(or[:out], x1),
        dots(
            xor1[:out]+(.4, 0), and1[:in2]-(0.8, 1.1),
            and2[:in1]-(2.2, 2.5), and2[:in2]-(2.6, 2.5)
        ),
        compose(
            context(),
            text(x0-0.1, xor1[:in1][2], "A", hright, vcenter),
            text(x0-0.1, xor1[:in2][2], "B", hright, vcenter),
            text(x0-0.1, xor2[:in2][2], "Cᵢₙ", hright, vcenter),
            text(x1+0.1, xor2[:out][2], "S", hleft, vcenter),
            text(x1+0.1, or[:out][2], "Cₒᵤₜ", hleft, vcenter),
            fontsize(30pt), font("Helvetica-Bold"), linewidth(0mm)
        ),

        stroke("black"), linewidth(2mm)
    )

    circuit |> SVG("full_adder.svg", autosize(width, height)...)
    # circuit |> PDF("full_adder.pdf", autosize(width, height)...)
end
