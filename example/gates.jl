using VisualCircuits, Compose

for logic in [:NOT, :AND, :NAND, :OR, :NOR, :XOR, :XNOR]
    g = Gate(1, 1, logic)
    c = compose(
        context(units = UnitBox(0.25, 0.25, 1.6, 1.5)),
        render(g),
        # Draw input & output lines (connected to x = 0; x = 2)
        connect(g[:in1], 0),
        connect(g[:in2], 0),
        connect(g[:out], 2),
        stroke("black"), linewidth(1mm)
    )
    draw(PDF(string(logic) * ".pdf", 40mm, 40mm), c)
end
