using VisualCircuits, Compose

begin
    notQ1 = Symbol("~Q1")
    notQ2 = Symbol("~Q2")

    # JK flip flop
    IC7476(x, y) = IC(x, y, "7476", [
        :K1     :Q1     notQ1   :GND    :K2     :Q2     notQ2   :J2;
        :CLK1   :PRE1   :CLR1   :J1     :VCC    :CLK2   :PRE2   :CLR2
    ])

    width, height = 11, 6.5
    jk1 = IC7476(3.5, 3.3)
    jk2 = IC7476(8.5, 3.3)

    # edges
    le = 0
    re = width

    # guide (not displayed)
    box = compose(
        context(),
        rectangle(0, 0, width, height),
        stroke("cyan"), fill(nothing)
    )

    # power
    y = 5.6
    power = compose(
        context(),
        connect((le, y), (re, y)),
        #connect(jk1[:PRE1], y, :y),    connect(jk2[:PRE1], y, :y),
        connect(jk1[:VCC],  y, :y),    connect(jk2[:VCC],  y, :y),
        #connect(jk1[:PRE2], y, :y),    connect(jk2[:PRE2], y, :y),
        dots(
            #(jk1[:PRE1][1], y),        (jk2[:PRE1][1], y),
            (jk1[:VCC][1],  y),        (jk2[:VCC][1],  y),
            #(jk1[:PRE2][1], y),        (jk2[:PRE2][1], y),
            color = "darkred"
        ),
        stroke("darkred")
    )

    y = 6
    preset = compose(
        context(),
        connect(jk2[:PRE1], y, :y),
        connect(jk2[:PRE2], y, :y),
        connect(jk1[:PRE1], y, :y),
        connect(jk1[:PRE2], y, :y),
        dots(
            (jk1[:PRE1][1], y), (jk1[:PRE2][1], y),
            (jk2[:PRE1][1], y), (jk2[:PRE2][1], y),
            color = "darkgreen"
        ),
        stroke("darkgreen")
    )

    y = 1.0
    ground = compose(
        context(),
        connect((le, y), (re, y)),
        connect(jk1[:GND], y, :y),     connect(jk2[:GND], y, :y),
        dots(
            (jk1[:GND][1], y),         (jk2[:GND][1], y),
            color = "darkblue"
        ),
        stroke("darkblue")
    )

    # clear
    x = 1
    y = 5.2
    clear = compose(
        context(),
        connect(jk1[:CLR1], (jk1[:CLR1][1], y)),
        connect(jk1[:CLR2], (jk1[:CLR2][1], y)),
        connect(jk2[:CLR1], (jk2[:CLR1][1], y)),
        connect(jk2[:CLR2], (jk2[:CLR2][1], y), (x, y)),
        dots(
            (jk1[:CLR1][1], y), (jk1[:CLR2][1], y),
            (jk2[:CLR1][1], y), color = "purple"
        ),
        stroke("purple")
    )

    # clock
    x = 1
    y = 4.8
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

    # j & K
    x = 1
    y1 = 4.4
    y2 = 2.2
    jk_in = compose(
        context(),
        connect(jk1[:J1], (jk1[:J1][1], y1), (x, y1)),
        connect(jk1[:K1], (jk1[:K1][1], y2), (x, y2)),
    )

    # general wires
    x = 6
    y0 = 4.4
    y1 = 2.2
    y2 = 1.8
    y3 = 1.4
    # y4 = 1.0
    # y5 = 0.6
    wires = compose(
        context(),
        connect(jk1[notQ1], (jk1[notQ1][1], y1), (jk1[:K2][1], y1), jk1[:K2]),
        connect(jk1[notQ2], (jk1[notQ2][1], y1), (jk2[:K1][1], y1), jk2[:K1]),
        connect(jk2[notQ1], (jk2[notQ1][1], y1), (jk2[:K2][1], y1), jk2[:K2]),
        connect(jk1[:J2], (jk1[:J2][1], y2), (jk1[:Q1][1], y2), jk1[:Q1]),
        connect(jk2[:J2], (jk2[:J2][1], y2), (jk2[:Q1][1], y2), jk2[:Q1]),
        connect(
            jk2[:J1], (jk2[:J1][1], y0), (x, y0),
            (x, y3), (jk1[:Q2][1], y3), jk1[:Q2]
        )
    )

    # outputs
    y = 0.6
    outputs = compose(
        context(),
        connect(jk1[:Q1], y, :y), connect(jk1[:Q2], y, :y),
        connect(jk2[:Q1], y, :y), connect(jk2[:Q2], y, :y),
        dots((jk1[:Q1][1], y2), (jk1[:Q2][1], y3), (jk2[:Q1][1], y2)),
        dots(
            (jk1[:Q1][1], y), (jk1[:Q2][1], y),
            (jk2[:Q1][1], y), (jk2[:Q2][1], y),
            color = "orange"
        ),

        stroke("orange")
    )

    # labels
    labels = compose(
        context(),
        # text(0.9, 5.6, "VCC", hright, vcenter),
        text(0.9, 5.2, "CLR", hright, vcenter),
        text(0.9, 4.8, "CLK", hright, vcenter),
        text(0.9, 4.4, "J", hright, vcenter),
        text(0.9, 2.2, "K", hright, vcenter),
        # text(0.9, 1.0, "GND", hright, vcenter),
        text(2.3, 0.4, "OUT1", hcenter, vbottom),
        text(4.3, 0.4, "OUT2", hcenter, vbottom),
        text(7.3, 0.4, "OUT3", hcenter, vbottom),
        text(9.3, 0.4, "OUT4", hcenter, vbottom),
        text(2.3, 6.2, "IN1", hcenter, vtop),
        text(4.8, 6.2, "IN2", hcenter, vtop),
        text(7.3, 6.2, "IN3", hcenter, vtop),
        text(9.8, 6.2, "IN4", hcenter, vtop),
        fontsize(20pt), font("Helvetica-Bold"), linewidth(0mm)
    )

    circuit = compose(
        context(units = UnitBox(0, 0, width, height)),
        render(jk1), render(jk2),

        # box,
        power, ground,
        clear, clock, preset,
        jk_in, wires, outputs,
        labels,

        stroke("black"), linewidth(2mm)
    )

    circuit |> SVG("shift_register.svg", autosize(width, height)...)
    # circuit |> PDF("shift_register.pdf", autosize(width, height)...)
end
