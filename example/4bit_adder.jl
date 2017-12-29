using VisualCircuits, Compose

begin
    notQ1 = Symbol("~Q1")
    notQ2 = Symbol("~Q2")

    # shift register
    IC7496(x, y) = IC(x, y, "7496", [
        :CLR    :QA     :QB     :QC     :GND    :QD     :QE     :SER;
        :CLK    :A      :B      :C      :VCC    :D      :E      :PRE
    ])
    # full adder
    IC7483(x, y) = IC(x, y, "7483", [
        :B4     :Q4     :C4     :C0     :GND    :B1     :A1     :Q1;
        :A4     :Q3     :A3     :B3     :VCC    :Q2     :B2     :A2
    ])
    # D-flipflop
    IC7474(x, y) = IC(x, y, "7474", [
        :VCC    :CLR2   :D2     :CLK2   :PRE2   :Q2     notQ2;
        :CLR1   :D1     :CLK1   :PRE1   :Q1     notQ1   :GND
    ])

    width, height = 18, 9.6
    le, re = 0, width
    reg1 = IC7496(4, 2.7)
    reg2 = IC7496(5.65, 7.1)
    add  = IC7483(9.2, 3.1)
    dff  = IC7474(10.45, 7.1)
    reg3 = IC7496(14.5, 3.1)

    # guide (not displayed)
    box = compose(
        context(),
        rectangle(0, 0, width, height),
        stroke("cyan"), fill(nothing)
    )

    # power
    y1 = 0.2
    y2 = 4.6
    y3 = 9.2
    power = compose(
        context(),
        connect((le, y1), (re, y1)), connect((le, y2), (re, y2)),
        connect((le, y3), (re, y3)),
        connect(reg1[:VCC], y2, :y), connect(reg2[:VCC], y3, :y),
        connect(reg3[:VCC], y2, :y), connect(add[:VCC], y2, :y),
        connect(dff[:VCC], y2, :y),
        connect(dff[:PRE2], y2, :y),
        dots(
            (reg1[:VCC][1], y2), (reg2[:VCC][1], y3),
            (reg3[:VCC][1], y2), (add[:VCC][1], y2),
            (dff[:VCC][1], y2),  (dff[:PRE2][1], y2),
            color = "darkred"
        ),
        stroke("darkred")
    )

    y1 = 0.4
    y2 = 4.8
    y3 = 9.4
    y4 = 4.2
    ground = compose(
        context(),
        connect((le, y1), (re, y1)), connect((le, y2), (re, y2)),
        connect((le, y3), (re, y3)),
        connect(reg1[:GND], y1, :y), connect(reg2[:GND], y2, :y),
        connect(reg3[:GND], y1, :y), connect(add[:GND], y1, :y),
        connect(dff[:GND], y3, :y),
        connect(add[:B2], y2, :y),
        connect(add[:A2], (add[:A2][1], y4), (add[:B2][1], y4)),
        connect(reg1[:SER], y1, :y),
        connect(reg2[:SER], y2, :y),
        connect(reg3[:PRE], y2, :y),
        dots(
            (reg1[:GND][1], y1), (reg2[:GND][1], y2),
            (reg3[:GND][1], y1), (add[:GND][1], y1),
            (dff[:GND][1], y3),  (add[:B2][1], y4),
            (add[:B2][1], y2),   (reg1[:SER][1], y1),
            (reg2[:SER][1], y2), (reg3[:PRE][1], y2),
            color = "darkblue"
        ),
        stroke("darkblue")
    )

    # input
    y1 = 3.8
    y2 = 8.2
    inputs = compose(
        context(),
        connect(reg1[:A], y1, :y), connect(reg2[:A], y2, :y),
        connect(reg1[:B], y1, :y), connect(reg2[:B], y2, :y),
        connect(reg1[:C], y1, :y), connect(reg2[:C], y2, :y),
        connect(reg1[:D], y1, :y), connect(reg2[:D], y2, :y),
        connect(reg1[:PRE], y1, :y), connect(reg2[:PRE], y2, :y),
        dots(
            (reg1[:A][1], y1),  (reg2[:A][1], y2),
            (reg1[:B][1], y1),  (reg2[:B][1], y2),
            (reg1[:C][1], y1),  (reg2[:C][1], y2),
            (reg1[:D][1], y1),  (reg2[:D][1], y2),
            (reg1[:PRE][1], y1),  (reg2[:PRE][1], y2),
            color = "darkgreen"
        ),
        stroke("darkgreen")
    )

    # input leds
    y1 = 1.6
    y2 = 6
    inputLEDs = compose(
        context(),
        connect(reg1[:QA], y1, :y), connect(reg2[:QA], y2, :y),
        connect(reg1[:QB], y1, :y), connect(reg2[:QB], y2, :y),
        connect(reg1[:QC], y1, :y), connect(reg2[:QC], y2, :y),
        connect(reg1[:QD], y1, :y), connect(reg2[:QD], y2, :y),
        dots(
            (reg1[:QA][1], y1),  (reg2[:QA][1], y2),
            (reg1[:QB][1], y1),  (reg2[:QB][1], y2),
            (reg1[:QC][1], y1),  (reg2[:QC][1], y2),
            (reg1[:QD][1], y1),  (reg2[:QD][1], y2),
            color = "orange"
        ),
        stroke("orange")
    )

    # input text
    y1 = 1.6
    y2 = 3.8
    y3 = 6
    y4 = 8.2
    input_labels = compose(
        context(),
        text(reg1[:QA][1], y1-0.2, "b1", hcenter, vbottom),
        text(reg1[:QB][1], y1-0.2, "b2", hcenter, vbottom),
        text(reg1[:QC][1], y1-0.2, "b3", hcenter, vbottom),
        text(reg1[:QD][1]+0.2, y1, "b4", hleft, vcenter),

        text(reg1[:A][1], y2+0.2, "b1", hcenter, vtop),
        text(reg1[:B][1], y2+0.2, "b2", hcenter, vtop),
        text(reg1[:C][1], y2+0.2, "b3", hcenter, vtop),
        text(reg1[:D][1], y2+0.2, "b4", hcenter, vtop),

        text(reg2[:QA][1], y3-0.2, "b'1", hcenter, vbottom),
        text(reg2[:QB][1], y3-0.2, "b'2", hcenter, vbottom),
        text(reg2[:QC][1], y3-0.2, "b'3", hcenter, vbottom),
        text(reg2[:QD][1]+0.2, y3, "b'4", hleft, vcenter),

        text(reg2[:A][1], y4+0.2, "b'1", hcenter, vtop),
        text(reg2[:B][1], y4+0.2, "b'2", hcenter, vtop),
        text(reg2[:C][1], y4+0.2, "b'3", hcenter, vtop),
        text(reg2[:D][1], y4+0.2, "b'4", hcenter, vtop),

        text(reg1[:PRE][1], y2+0.2, "SET", hcenter, vtop),
        text(reg2[:PRE][1], y4+0.2, "SET", hcenter, vtop),
        fontsize(20pt), font("Helvetica-Bold"), linewidth(0mm)
    )

    # output
    y1 = 2.0
    outputs = compose(
        context(),
        connect(reg3[:QA], y1, :y), connect(reg3[:QB], y1, :y),
        connect(reg3[:QC], y1, :y), connect(reg3[:QD], y1, :y),
        connect(reg3[:QE], y1, :y),
        dots(
            (reg3[:QA][1], y1), (reg3[:QB][1], y1),
            (reg3[:QC][1], y1), (reg3[:QD][1], y1),
            (reg3[:QE][1], y1), color = "orange"
        ),
        stroke("orange")
    )

    output_labels = compose(
        context(),
        text(reg3[:QA][1], y1-0.2, "B1", hcenter, vbottom),
        text(reg3[:QB][1], y1-0.2, "B2", hcenter, vbottom),
        text(reg3[:QC][1], y1-0.2, "B3", hcenter, vbottom),
        text(reg3[:QD][1], y1-0.2, "B4", hcenter, vbottom),
        text(reg3[:QE][1], y1-0.2, "B5", hcenter, vbottom),
        fontsize(20pt), font("Helvetica-Bold"), linewidth(0mm)
    )

    # clock
    x1 = 1
    x2 = 8.2
    y1 = 8.8
    y2 = 6
    clock = compose(
        context(),
        connect((x1, y1), (reg3[:CLK][1], y1), reg3[:CLK]),
        connect(dff[:CLK2], (dff[:CLK2][1], y2), (x2, y2), (x2, y1)),
        connect(reg1[:CLK], y1, :y),
        connect(reg2[:CLK], y1, :y),
        stroke("darkcyan")
    )

    # clear
    x1 = 1
    x2 = 1.75
    y1 = 0.8
    y2 = 5.2
    y3 = 5.6
    clear = compose(
        context(),
        connect((x1, y1), (reg3[:CLR][1], y1), reg3[:CLR]),
        connect(reg1[:CLR], y1, :y),
        connect(reg2[:CLR], (reg2[:CLR][1], y2), (x2, y2), (x2, y1)),
        connect(dff[:CLR2], (dff[:CLR2][1], y2), (reg2[:CLR][1], y2)),
        dots((reg2[:CLR][1], y2), color = "purple"),
        stroke("purple")
    )

    # d flip flop
    x1 = 6.8
    x2 = 6.4
    y1 = 5.6
    y2 = 2
    y3 = 1.2
    y4 = 1.6
    y5 = 6
    wires = compose(
        context(),
        connect(dff[:D2], add[:Q2]),
        connect(
            dff[:Q2], (dff[:Q2][1], y1), (x1, y1),
            (x1, y2), (add[:C0][1], y2), add[:C0]
        ),
        connect(add[:Q1], (add[:Q1][1], y3), (reg3[:SER][1], y3), reg3[:SER]),
        connect(add[:A1], (add[:A1][1], y3), (reg1[:QD][1], y3), reg1[:QD]),
        connect(add[:B1], (add[:B1][1], y4), (x2, y4), (x2, y5), (reg2[:QD][1], y5))
    )

    x = 1
    y1 = 0.8
    y2 = 8.8
    labels = compose(
        context(),
        text(x-0.2, y1, "CLR", hright, vcenter),
        text(x-0.2, y2, "CLK", hright, vcenter),
        fontsize(20pt), font("Helvetica-Bold"), linewidth(0mm)
    )


    circuit = compose(
        context(units = UnitBox(0, 0, width, height)),
        render(reg1), render(reg2), render(reg3), render(add), render(dff),

        # box,
        power, ground,
        inputs, inputLEDs, input_labels,
        outputs, output_labels,
        clock, clear,
        wires, labels,

        stroke("black"), linewidth(2mm)
    )

    circuit |> SVG("4bit_adder.svg", autosize(width, height)...)
    # circuit |> PDF("4bit_adder.pdf", autosize(width, height)...)
end
