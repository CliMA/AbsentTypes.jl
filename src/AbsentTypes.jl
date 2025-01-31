module AbsentTypes

"""
    Absent()

A `Base.AbstractBroadcasted` that represents arithmetic object.

An `Absent()` can be added to, subtracted from, or multiplied by any value in a
broadcast expression without incurring a runtime performance penalty.

For example, the following rules hold when broadcasting instances of `Absent`:
```
1 + Absent() == 1
Absent() + 1 == 1
1 - Absent() == 1
1 * Absent() == Absent()
1 / Absent() == Absent()
 ```
"""
struct Absent <: Base.AbstractBroadcasted end
Base.broadcastable(x::Absent) = x

struct AbsentStyle <: Base.BroadcastStyle end
Base.BroadcastStyle(::Type{<:Absent}) = Absent()

# Specialize on AbstractArrayStyle to avoid ambiguities with AbstractBroadcasted.
Base.BroadcastStyle(::Absent, ::Base.Broadcast.AbstractArrayStyle) = Absent()
Base.BroadcastStyle(::Base.Broadcast.AbstractArrayStyle, ::Absent) = Absent()

# Add another method to avoid ambiguity between the previous two.
Base.BroadcastStyle(::Absent, ::Absent) = Absent()

broadcasted_sum(args) =
    if isempty(args)
        Absent()
    elseif length(args) == 1
        args[1]
    else
        Base.broadcasted(+, args...)
    end
Base.broadcasted(::Absent, ::typeof(+), args...) =
    broadcasted_sum(filter(arg -> !(arg isa Absent), args))

Base.broadcasted(op::typeof(-), ::Absent, arg) = Base.broadcasted(op, arg)
Base.broadcasted(op::typeof(-), arg, ::Absent) = Base.broadcasted(Base.identity, arg)
Base.broadcasted(op::typeof(-), a::Absent) = Absent()
Base.broadcasted(op::typeof(-), a::Absent, ::Absent) = Base.broadcasted(op, a)

Base.broadcasted(op::typeof(+), ::Absent, args...) = Base.broadcasted(op, args...)
Base.broadcasted(op::typeof(+), arg, ::Absent) = Base.broadcasted(op, arg)
Base.broadcasted(op::typeof(+), a::Absent, ::Absent) = Base.broadcasted(op, a)

Base.broadcasted(op::typeof(*), ::Absent, args...) = Absent()
Base.broadcasted(op::typeof(*), arg, ::Absent) = Absent()
Base.broadcasted(op::typeof(*), ::Absent, ::Absent) = Absent()
Base.broadcasted(op::typeof(/), ::Absent, args...) = Absent()
Base.broadcasted(op::typeof(/), arg, ::Absent) = Absent()
Base.broadcasted(op::typeof(/), ::Absent, ::Absent) = Absent()

function skip_materialize(dest, bc::Base.Broadcast.Broadcasted)
    if typeof(bc.f) <: typeof(+) || typeof(bc.f) <: typeof(-)
        if length(bc.args) == 2 &&
           bc.args[1] === dest &&
           bc.args[2] === Base.Broadcast.Broadcasted(Absent, ())
            return true
        else
            return false
        end
    else
        return false
    end
end

Base.Broadcast.instantiate(bc::Base.Broadcast.Broadcasted{AbsentStyle}) = x

end # module AbsentTypes
