using VisualCircuits, Compose

width, height = 5, 4
nand1 = Gate(2.5, 1., :NAND)
nand2 = Gate(2.5, 3., :NAND)

circuit = begin
    compose(
    # Range of coordinate system
    context(units=UnitBox(0, 0, width, height)),

    # Gates
    render(nand1), render(nand2),

    # Connect to edges (point, x_value)
    connect(nand1[:in1], 1),
    connect(nand2[:in2], 1),
    connect(nand1[:out], width-1),
    connect(nand2[:out], width-1),

    # crossing lines
    connect(
        nand1[:in2],
        (1.5, nand1[:in2][2]),
        (1.5, 1.5), (3.5, 2.5),
        (3.5, nand2[:out][2]),
        nand2[:out]
    ),
    connect(
        nand2[:in1],
        (1.5, nand2[:in1][2]),
        (1.5, 2.5), (3.5, 1.5),
        (3.5, nand1[:out][2]),
        nand1[:out]
    ),

    # connections/dots
    dots(
        (3.5, nand1[:out][2]),
        (3.5, nand2[:out][2])
    ),

    # render text
    render(
        (0.5, nand1[:in1][2], "R"),
        (0.5, nand2[:in2][2], "S"),
        (width-0.5, nand1[:out][2], "Q"),
        (width-0.5, nand2[:out][2], "~Q")
    ),

    # compose options
    stroke("black"), linewidth(2mm)
    )
end

draw(PDF("RS_FlipFlop.pdf", autosize(width, height)...), circuit)
