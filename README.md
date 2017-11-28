# VisualCircuits

[![Build Status](https://travis-ci.org/Hydrolik/VisualCircuits.jl.svg?branch=master)](https://travis-ci.org/Hydrolik/VisualCircuits.jl)
[![Coverage Status](https://coveralls.io/repos/Hydrolik/VisualCircuits.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/Hydrolik/VisualCircuits.jl?branch=master)
[![codecov.io](http://codecov.io/github/Hydrolik/VisualCircuits.jl/coverage.svg?branch=master)](http://codecov.io/github/Hydrolik/VisualCircuits.jl?branch=master)

This project aims to simplify the drawing of (Logic) circuits with `Compose.jl`. To do this, a tpye `Block` is implemented, which holds a compose object, as well as pin positions. `Block` objects for logic gates can be generated with `Gate(x, y, logic)`, where logic is, for example, `:AND`. 

To install an unregistered package, use Pkg.clone(url), i.e.
```julia
Pkg.clone("git@github.com:ffreyer/VisualCircuits.jl.git")
```
