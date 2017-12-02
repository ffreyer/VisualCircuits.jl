using VisualCircuits, Compose

width, height = 7, 4
nand1 = Gate(4.5, 1, :NAND)
nand2 = Gate(4.5, 3, :NAND)
nand3 = Gate(2.5, nand1[:in1][2], :NAND)
nand4 = Gate(2.5, nand2[:in2][2], :NAND)

circuit = compose(
    # Range of coordinate system
    context(units=UnitBox(0, 0, width, height)),

    # Gates
    render(nand1), render(nand2), render(nand3), render(nand4),

    # Connect to edges (point, x_value)
    connect(nand1[:out], width-1),
    connect(nand2[:out], width-1),
    connect(nand3[:in1], 1),
    connect(nand4[:in2], 1),
    connect((1.5, 2), 1),

    # Connect Gates
    connect(nand1[:in1], nand3[:out]),
    connect(nand2[:in2], nand4[:out]),

    # crossing lines
    connect(
        nand1[:in2],
        (3.5, nand1[:in2][2]),
        (3.5, 1.5), (5.5, 2.5),
        (5.5, nand2[:out][2]),
        nand2[:out]
    ),
    connect(
        nand2[:in1],
        (3.5, nand2[:in1][2]),
        (3.5, 2.5), (5.5, 1.5),
        (5.5, nand1[:out][2]),
        nand1[:out]
    ),
    connect(
        nand3[:in2],
        (1.5, nand3[:in2][2]),
        (1.5, nand4[:in1][2]),
        nand4[:in1]
    ),

    # connections/dots
    dots(
        (5.5, nand1[:out][2]),
        (5.5, nand2[:out][2]),
        (1.5, 2)
    ),

    # render text
    render(
        (0.5, nand3[:in1][2], "R"),
        (0.5, nand4[:in2][2], "S"),
        (0.5, 2, "C"),
        (width-0.5, nand1[:out][2], "Q"),
        (width-0.5, nand2[:out][2], "~Q")
    ),

    # compose options
    stroke("black"), linewidth(2mm)
)

# draw(PDF("Clocked_RS_FlipFlop.pdf", autosize(width, height)...), circuit)
draw(SVG("Clocked_RS_FlipFlop.svg", autosize(width, height)...), circuit)
