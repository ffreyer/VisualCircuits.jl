using VisualCircuits, Compose

begin
    IC7476(x, y) = IC(x, y, [
        :CLK1 :PRE1 :CLR1 :J1 :VCC :CLK2 :PRE2 :CLR2;
        :K1 :Q1 Symbol("~Q1") :GND :K2 :Q2 Symbol("~Q2") :J2
    ])

    notQ1 = Symbol("~Q1")
    notQ2 = Symbol("~Q2")

    width, height = 11, 5.0
    ic1 = IC7476(3, 2.5)
    ic2 = IC7476(8, 2.5)

    le = 0.5 # left edge
    circuit = compose(
        context(units = UnitBox(-0.5, 0.3, width, height)),

        render(ic1), render(ic2),

        # clock
        connect((ic1[:CLK1][1], 1.2), ic1[:CLK1]),
        connect((ic1[:CLK2][1], 1.2), ic1[:CLK2]),
        connect((ic2[:CLK1][1], 1.2), ic2[:CLK1]),
        connect((le, 1.2), (ic2[:CLK2][1], 1.2), ic2[:CLK2]),
        dots((ic1[:CLK1][1], 1.2), (ic1[:CLK2][1], 1.2), (ic2[:CLK1][1], 1.2)),

        # Power
        compose(
            context(),
            connect(ic1[:VCC], (ic1[:VCC][1], 0.6)),
            connect(ic2[:VCC], (ic2[:VCC][1], 0.6)),
            connect(ic1[:PRE1], (ic1[:PRE1][1], 0.6)),
            connect(ic1[:PRE2], (ic1[:PRE2][1], 0.6)),
            connect(ic2[:PRE1], (ic2[:PRE1][1], 0.6)),
            connect(ic2[:PRE2], (ic2[:PRE2][1], 0.6), (le, 0.6)),
            dots(
                (ic1[:VCC][1], 0.6), (ic2[:VCC][1], 0.6),
                (ic1[:PRE1][1], 0.6), (ic1[:PRE2][1], 0.6),
                (ic2[:PRE1][1], 0.6), color = "darkred"
            ),
            stroke("darkred")
        ),
        compose(
            context(),
            connect(ic1[:GND], (ic1[:GND][1], 3.8)),
            connect(ic2[:GND], (ic2[:GND][1], 3.8), (le, 3.8)),
            dots((ic1[:GND][1], 3.8), color="darkblue"),
            stroke("darkblue")
        ),

        # latch to latch
        connect(ic1[:Q1], (ic1[:Q1][1], 4.1), (ic1[:J2][1], 4.1), ic1[:J2]),
        connect(ic1[notQ1], (ic1[notQ1][1], 3.5), (ic1[:K2][1], 3.5), ic1[:K2]),
        connect(ic1[notQ2], (ic1[notQ2][1], 3.5), (ic2[:K1][1], 3.5), ic2[:K1]),
        connect(
            ic1[:Q2], (ic1[:Q2][1], 4.4), (5.5, 4.4),
            (5.5, 1.5), (ic2[:J1][1], 1.5), ic2[:J1]
        ),
        connect(ic2[:Q1], (ic2[:Q1][1], 4.1), (ic2[:J2][1], 4.1), ic2[:J2]),
        connect(ic2[notQ1], (ic2[notQ1][1], 3.5), (ic2[:K2][1], 3.5), ic2[:K2]),


        # CLR
        compose(
            context(),
            connect(ic2[:CLR2], (ic2[:CLR2][1], 0.9), (le, 0.9)),
            connect(ic2[:CLR1], (ic2[:CLR1][1], 0.9)),
            connect(ic1[:CLR2], (ic1[:CLR2][1], 0.9)),
            connect(ic1[:CLR1], (ic1[:CLR1][1], 0.9)),
            dots(
                (ic1[:CLR1][1], 0.9),
                (ic1[:CLR2][1], 0.9),
                (ic2[:CLR1][1], 0.9),
                color="darkgreen"
            ),
            stroke("darkgreen")
        ),

        # light out (Qs)
        compose(
            context(),
            connect(ic2[:Q2], (ic2[:Q2][1], 4.8)),
            connect(ic2[:Q1], (ic2[:Q1][1], 4.8)),
            connect(ic1[:Q2], (ic1[:Q2][1], 4.8)),
            connect(ic1[:Q1], (ic1[:Q1][1], 4.8)),
            dots(
                (ic1[:Q1][1], 4.8),
                (ic1[:Q2][1], 4.8),
                (ic2[:Q1][1], 4.8),
                (ic2[:Q2][1], 4.8),
                color="orange"
            ),
            dots(
                (ic1[:Q1][1], 4.1),
                (ic1[:Q2][1], 4.4),
                (ic2[:Q1][1], 4.1),
                color="black"
            ),
            stroke("orange")
        ),

        # input
        connect(ic1[:J1], (ic1[:J1][1], 1.5), (le, 1.5)),
        connect(ic1[:K1], (ic1[:K1][1], 3.5), (le, 3.5)),

        # names
        compose(
            context(),
            text(0.4, 0.6, "VCC", hright, vcenter),
            text(0.4, 0.9, "CLR", hright, vcenter),
            text(0.4, 1.2, "CLK", hright, vcenter),
            text(0.4, 1.5, "J", hright, vcenter),
            text(0.4, 3.5, "K", hright, vcenter),
            text(0.4, 3.8, "GND", hright, vcenter),

            text(ic1[:Q1][1], 5.0, "OUT1", hcenter, vtop),
            text(ic1[:Q2][1], 5.0, "OUT2", hcenter, vtop),
            text(ic2[:Q1][1], 5.0, "OUT3", hcenter, vtop),
            text(ic2[:Q2][1], 5.0, "OUT4", hcenter, vtop),
            fontsize(8), font("Helvetica-Bold"),
            linewidth(0mm)
        ),

        stroke("black"), linewidth(2mm)
    )

    circuit |> SVG("shift_register.svg", autosize(width, height)...)
    # circuit |> PDF("shift_register.pdf", autosize(width, height)...)
end
