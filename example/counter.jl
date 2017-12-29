using VisualCircuits, Compose

begin
    notQ1 = Symbol("~Q1")
    notQ2 = Symbol("~Q2")

    # JK flip flop
    IC7476(x, y) = IC(x, y, "7476", [
        :K1     :Q1     notQ1   :GND    :K2     :Q2     notQ2   :J2;
        :CLK1   :PRE1   :CLR1   :J1     :VCC    :CLK2   :PRE2   :CLR2
    ])
    # 4x 2 input and
    IC7408(x, y) = IC(x, y, "7408", [
        :VCC    :B4     :A4     :Y4     :B3     :A3     :Y3;
        :A1     :B1     :Y1     :A2     :B2     :Y2     :GND
    ])


    width, height = 11, 7.3
    jk1 = IC7476(3.5, 4.8)
    jk2 = IC7476(8.5, 4.8)
    and1 = IC7408(5.25, 1.4)

    # edges
    le = 0
    re = width

    # guide (not displayed)
    box = compose(
        context(),
        rectangle(0, 0, width, height),
        stroke("cyan"), fill(nothing)
    )

    # Wires
    y1 = 0.2
    y2 = height - 0.2
    power = compose(
        context(),
        connect((le, y1), (re, y1)),
        connect(and1[:VCC], (and1[:VCC][1], y1)),

        connect((le, y2), (re, y2)),
        connect(jk2[:VCC], (jk2[:VCC][1], y2)),
        connect(jk1[:VCC], (jk1[:VCC][1], y2)),

        connect(jk1[:PRE1], (jk1[:PRE1][1], y2)),
        connect(jk1[:PRE2], (jk1[:PRE2][1], y2)),
        connect(jk2[:PRE1], (jk2[:PRE1][1], y2)),
        connect(jk2[:PRE2], (jk2[:PRE2][1], y2)),

        connect(jk1[:J1], (jk1[:J1][1], y2)),
        connect(jk1[:K1], (jk1[:K1][1], y1)),

        dots(
            (jk1[:VCC][1], y2), (jk2[:VCC][1], y2),
            (and1[:VCC][1], y1),
            (jk1[:PRE1][1], y2), (jk1[:PRE2][1], y2),
            (jk2[:PRE1][1], y2), (jk2[:PRE2][1], y2),
            (jk1[:J1][1], y2), (jk1[:K1][1], y1),
            color = "darkred"
        ),
        stroke("darkred")
    )

    y = 2.9
    ground = compose(
        context(),
        connect((le, y), (re, y)),
        connect(jk1[:GND], (jk1[:GND][1], y)),
        connect(jk2[:GND], (jk2[:GND][1], y)),
        connect(and1[:GND], (and1[:GND][1], y)),
        dots(
            (jk1[:GND][1], y), (jk2[:GND][1], y),
            (and1[:GND][1], y), color = "darkblue"
        ),
        stroke("darkblue")
    )

    x = 1
    y = 6.3
    clear = compose(
        context(),
        connect(jk1[:CLR1], (jk1[:CLR1][1], y)),
        connect(jk1[:CLR2], (jk1[:CLR2][1], y)),
        connect(jk2[:CLR1], (jk2[:CLR1][1], y)),
        connect(jk2[:CLR2], (jk2[:CLR2][1], y), (x, y)),
        dots(
            (jk1[:CLR1][1], y), (jk1[:CLR2][1], y),
            (jk2[:CLR1][1], y), color = "darkgreen"
        ),
        stroke("darkgreen")
    )

    x = 1
    y = 6.7
    clock = compose(
        context(),
        connect(jk1[:CLK1], (jk1[:CLK1][1], y)),
        connect(jk1[:CLK2], (jk1[:CLK2][1], y)),
        connect(jk2[:CLK1], (jk2[:CLK1][1], y)),
        connect(jk2[:CLK2], (jk2[:CLK2][1], y), (x, y)),
        dots(
            (jk1[:CLK1][1], y), (jk1[:CLK2][1], y),
            (jk2[:CLK1][1], y), color = "darkcyan"),
        stroke("darkcyan")
    )

    # Q1 -> and, J2, K2
    y = 3.7
    logic1 = compose(
        context(),
        connect(jk1[:Q1], (jk1[:Q1][1], y), (jk1[:J2][1], y), jk1[:J2]),
        connect(jk1[:K2], and1[:A1]),
        connect(jk1[:Q2], and1[:B1]),
        dots((jk1[:K2][1], y)),
        stroke("black")
    )

    x = 5.8
    y1 = 2.5
    y2 = 3.5
    y3 = 3.7
    y9 = 5.9
    logic2 = compose(
        context(),
        connect(and1[:Y1], (and1[:Y1][1], y1), (and1[:B2][1], y1), and1[:B2]),
        connect(and1[:B2], (x, y9), (jk2[:J1][1], y9), jk2[:J1]),
        connect((x, y3), (jk2[:K1][1], y3), jk2[:K1]),

        # connect(and1[:Y1], (and1[:Y1][1], y1), (and1[:A2][1], y1), and1[:A2]),
        # connect(and1[:Y1], (and1[:Y1][1], y2), (jk2[:K1][1], y2), jk2[:K1]),
        # connect((x, y2), (x, y9), (jk2[:J1][1], y9), jk2[:J1]),

        # connect(and1[:Y1], (and1[:Y1][1], y1), (and1[:A2][1], y1), and1[:A2]),
        # connect(and1[:A2], (and1[:A2][1], y2), (x, y2), (x, y9), (jk2[:J1][1], y9), jk2[:J1]),
        # connect((x, y3), (jk2[:K1][1], y3), jk2[:K1]),
        dots((and1[:B2][1], y1), (x, y3)),
        stroke("black")
    )

    y1 = 2.5
    y2 = 3.3
    # y3 = 3.9
    logic3 = compose(
        context(),
        connect(and1[:A2], (and1[:A2][1], y2), (jk2[:Q1][1], y2), jk2[:Q1]),
        connect(and1[:Y2], (and1[:Y2][1], y1), (jk2[:J2][1], y1), jk2[:J2]),
        connect(jk2[:K2], (jk2[:K2][1], y1)),
        dots((jk2[:K2][1], y1)),
        stroke("black")
    )

    x1 = 3.0
    x2 = 7.6
    y1 = 3.3
    y2 = 2.5
    y3 = 3.7
    y9 = 1.5
    outputs = compose(
        context(),
        connect(jk1[:Q1], (jk1[:Q1][1], y9)),
        connect((jk1[:Q2][1], y2), (x1, y2), (x1, y9)),
        connect((jk2[:Q1][1], y1), (x2, y1), (x2, y9)),
        connect(jk2[:Q2], (jk2[:Q2][1], y9)),
        dots(
            (jk1[:Q1][1], y9), (x1, y9),
            (x2, y9), (jk2[:Q2][1], y9),
            color = "orange"
        ),
        dots((jk1[:Q2][1], y2), (jk2[:Q1][1], y1), (jk1[:Q1][1], y3)),
        stroke("orange")
    )


    lables = compose(
        context(),
        text(0.9, 6.3, "CLR", hright, vcenter),
        text(0.9, 6.7, "CLK", hright, vcenter),
        text(2.2, 1.3, "OUT1", hcenter, vbottom),
        text(3.0, 1.3, "OUT2", hcenter, vbottom),
        text(7.6, 1.3, "OUT3", hcenter, vbottom),
        text(9.2, 1.3, "OUT4", hcenter, vbottom),
        fontsize(20pt), font("Helvetica-Bold"), linewidth(0mm)
    )

    circuit = compose(
        context(units = UnitBox(0, 0, width, height)),
        # box,
        render(jk1), render(jk2), render(and1),

        power,
        ground,
        clear,
        #inputs,
        clock,
        logic1,
        logic2,
        logic3,
        outputs,
        lables,

        stroke("black"), linewidth(2mm)
    )

    circuit |> SVG("counter.svg", autosize(width, height)...)
    # circuit |> PDF("counter.pdf", autosize(width, height)...)
end
