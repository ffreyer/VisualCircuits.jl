using VisualCircuits, Compose

width, height = 7.5, 4
nand1 = Gate(5, 1, :NAND)
nand2 = Gate(5, 3, :NAND)
nand3 = Gate(3, nand1[:in1][2], :NAND, [:in1, :in2, :in3])
nand4 = Gate(3, nand2[:in2][2], :NAND, [:in1, :in2, :in3])

circuit = begin
    compose(
    # Range of coordinate system
    context(units=UnitBox(0, 0, width, height)),

    # Gates
    render(nand1), render(nand2), render(nand3), render(nand4),

    # Connect to edges (point, x_value)
    connect(nand1[:out], width-1),
    connect(nand2[:out], width-1),
    connect(nand3[:in1], 1),
    connect(nand4[:in3], 1),
    connect((1.5, 2), 1),

    # Connect Gates
    connect(nand1[:in1], nand3[:out]),
    connect(nand2[:in2], nand4[:out]),

    # crossing lines
    connect(
        nand1[:in2],
        (4, nand1[:in2][2]),
        (4, 1.75), (6, 2.25),
        (6, nand2[:out][2]),
        nand2[:out]
    ),
    connect(
        nand2[:in1],
        (4, nand2[:in1][2]),
        (4, 2.25), (6, 1.75),
        (6, nand1[:out][2]),
        nand1[:out]
    ),
    # Clock line
    connect(
        nand3[:in2],
        (1.5, nand3[:in2][2]),
        (1.5, nand4[:in2][2]),
        nand4[:in2]
    ),
    # looping lines
    connect(nand3[:in3], (2, nand3[:in3][2]), (2, 1.5), (4, 1.5)),
    connect(nand4[:in1], (2, nand4[:in1][2]), (2, 2.5), (4, 2.5)),

    # connections/dots
    dots(
        (6, nand1[:out][2]),
        (6, nand2[:out][2]),
        (1.5, 2),
        (4, 1.5),
        (4, 2.5)
    ),

    # render text
    render(
        (0.5, nand3[:in1][2], "J"),
        (0.5, nand4[:in3][2], "K"),
        (0.5, 2, "C"),
        (width-0.5, nand1[:out][2], "Q"),
        (width-0.5, nand2[:out][2], "~Q")
    ),

    # compose options
    stroke("black"), linewidth(2mm)
    )
end

# draw(PDF("JK_FlipFlop.pdf", autosize(width, height)...), circuit)
draw(SVG("JK_FlipFlop.svg", autosize(width, height)...), circuit)
