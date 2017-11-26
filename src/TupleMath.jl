XYTuple{T} = NTuple{2, T} where T<:Real

+(p1::XYTuple, p2::XYTuple) = (p1[1] + p2[1], p1[2] + p2[2])
-(p1::XYTuple, p2::XYTuple) = (p1[1] - p2[1], p1[2] - p2[2])
*(p::XYTuple, c::Real) = (c * p[1], c * p[2])
*(c::Real, p::XYTuple) = (c * p[1], c * p[2])
/(p::XYTuple, c::Real) = (p[1] / c, p[2] / c)


"""
    partition(start, stop, N)

Generates N equally spaced, centered points between start and stop.
"""
function partition(start::XYTuple, stop::XYTuple, N::Integer)
    dist = stop -start
    step = dist / N
    [start + (i - 0.5) * step for i in 1:N]
end
