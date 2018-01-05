using VisualCircuits, Compose

begin
    width, height = 12.5, 5.3

    nand3 = Gate(4.5, 1.1, :NAND)
    nand4 = Gate(4.5, 3.1, :NAND)
    nand1 = Gate(2.8, nand3[:in1][2], :NAND, [:in1, :in2, :in3])
    nand2 = Gate(2.8, nand4[:in2][2], :NAND, [:in1, :in2, :in3])

    nand7 = Gate(9, 1.1, :NAND)
    nand8 = Gate(9, 3.1, :NAND)
    nand5 = Gate(7.3, nand7[:in1][2], :NAND)
    nand6 = Gate(7.3, nand8[:in2][2], :NAND)

    not = Gate(5, 4.3, :NOT)

    box = compose(
        context(),
        rectangle(0, 0, width, height),
        stroke("cyan"), fill(nothing)
    )

    feedforward = compose(
        context(),
        connect((1, nand1[:in2][2]), nand1[:in2]),
        connect((1, nand2[:in2][2]), nand2[:in2]),
        connect(nand1[:out], nand3[:in1]),
        connect(nand3[:out], nand5[:in2]),
        connect(nand5[:out], nand7[:in1]),
        connect(nand2[:out], nand4[:in2]),
        connect(nand4[:out], nand6[:in1]),
        connect(nand6[:out], nand8[:in2]),
        connect(nand7[:out], (width-1, nand7[:out][2])),
        connect(nand8[:out], (width-1, nand8[:out][2]))
    )
    # gate low/high pos
    loop(p1, h1, h2, p2) = connect(
        p1, p1 - (0.3, 0), (p1[1] - 0.3, h1), (p2[1], h2), p2
    )
    loops = compose(
        context(),
        loop(nand3[:in2], 1.7, 2.5, nand4[:out] + (0.3, 0)),
        loop(nand4[:in1], 2.5, 1.7, nand3[:out] + (0.3, 0)),
        loop(nand7[:in2], 1.7, 2.5, nand8[:out] + (0.3, 0)),
        loop(nand8[:in1], 2.5, 1.7, nand7[:out] + (0.3, 0)),
        dots(
            nand3[:out] + (0.3, 0), nand4[:out] + (0.3, 0),
            nand7[:out] + (0.3, 0), nand8[:out] + (0.3, 0)
        )
    )

    clock = compose(
        context(),
        connect((1, 2.1), (nand1[:in1][1]-0.3, 2.1)),
        connect(
            nand1[:in3], nand1[:in3] - (0.3, 0),
            nand2[:in1] - (0.3, 0), nand2[:in1]
        ),
        connect(
            nand5[:in1], nand5[:in1] - (0.3, 0),
            nand6[:in2] - (0.3, 0), nand6[:in2]
        ),
        connect(nand2[:in1]-(0.3,0), (nand2[:in1][1]-0.3, not[:in][2]), not[:in]),
        connect(nand6[:in2]-(0.3,0), (nand6[:in2][1]-0.3, not[:out][2]), not[:out]),
        dots((nand1[:in1][1]-0.3, 2.1), nand2[:in1]-(0.3,0), nand6[:in2]-(0.3,0))
    )

    feedback = compose(
        context(),
        connect(
            nand8[:out] + (0.6, 0),
            (nand8[:out][1] + 0.6, 0.2),
            (nand1[:in1][1] - 0.3, 0.2),
            nand1[:in1] - (0.3, 0),
            nand1[:in1]
        ),
        connect(
            nand7[:out] + (0.9, 0),
            (nand7[:out][1] + 0.9, height - 0.2),
            (nand2[:in3][1] - 0.6, height - 0.2),
            nand2[:in3] - (0.6, 0),
            nand2[:in3]
        ),
        dots(nand7[:out] + (0.9, 0), nand8[:out] + (0.6, 0))
    )

    labels = compose(
        context(),
        text(0.9, nand1[:in2][2], "J",   hright, vcenter),
        text(0.9, 2.1,            "CLK", hright, vcenter),
        text(0.9, nand2[:in2][2], "K",   hright, vcenter),
        text(width-0.9, nand7[:out][2], "Q",   hleft, vcenter),
        text(width-0.9, nand8[:out][2], "~Q",   hleft, vcenter),
        fontsize(30pt), font("Helvetica-Bold"), linewidth(0mm)
    )

    circuit = compose(
        context(units = UnitBox(0, 0, width, height)),
        map(render, [eval(Symbol("nand$n")) for n in 1:8])...,
        render(not),

        # box,
        feedforward, loops, clock, feedback, labels,

        stroke("black"), linewidth(2mm)
    )

    circuit |> SVG("MS_JK_FlipFlop.svg", autosize(width, height)...)
    # circuit |> PDF("MS_JK_FlipFlop.pdf", autosize(width, height)...)
end
