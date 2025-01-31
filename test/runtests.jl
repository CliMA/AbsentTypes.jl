#=
julia --project
using Revise; using TestEnv; TestEnv.activat(); include("test/runtests.jl")
=#
using Test
using AbsentTypes
using AbsentTypes: Absent
using Aqua
using LazyBroadcast: lazy
import Base.Broadcast: instantiate, materialize, Broadcasted, DefaultArrayStyle

@testset "Absent" begin
    x = [1]
    a = Absent()
    @test typeof(lazy.(x .+ a)) <: Broadcasted{
        DefaultArrayStyle{1},
        Tuple{Base.OneTo{Int64}},
        typeof(+),
        Tuple{Vector{Int64}},
    }
    @test typeof(lazy.(a .+ x)) <: Broadcasted{
        DefaultArrayStyle{1},
        Tuple{Base.OneTo{Int64}},
        typeof(+),
        Tuple{Vector{Int64}},
    }
    @test lazy.(a .* x) isa Absent
    @test lazy.(a ./ x) isa Absent

    # +
    @test materialize(lazy.(a .+ x .+ 1)) == [2]
    @test materialize(lazy.(a .+ 1 .+ x)) == [2]
    @test materialize(lazy.(1 .+ a .+ x)) == [2]
    @test materialize(lazy.(1 .+ x .+ a)) == [2]

    # -
    @test materialize(lazy.(a .- x .- 1)) == [-2]
    @test materialize(lazy.(a .- 1 .- x)) == [-2]
    @test materialize(lazy.(1 .- a .- x)) == [0]
    @test materialize(lazy.(1 .- x .- a)) == [0]
    @test materialize(lazy.(a .- a)) == Absent()
    @test materialize(lazy.(1 .- 1 .+ a .- a)) == 0
    @test materialize(lazy.(x .- x .+ a .- a)) == [0]

    # *
    @test materialize(lazy.(a .* x .* 1)) == Absent()
    @test materialize(lazy.(a .* 1 .* x)) == Absent()
    @test materialize(lazy.(1 .* a .* x)) == Absent()
    @test materialize(lazy.(1 .* x .* a)) == Absent()

    # /
    @test materialize(lazy.(a ./ x ./ 1)) == Absent()
    @test materialize(lazy.(a ./ 1 ./ x)) == Absent()
    @test materialize(lazy.(1 ./ a ./ x)) == Absent()
    @test materialize(lazy.(1 ./ x ./ a)) == Absent()

    @test_throws MethodError Absent() + 1
    @test_throws MethodError Absent() - 1
    @test_throws MethodError Absent() * 1
    @test_throws MethodError Absent() / 1

    @test materialize(Absent()) isa Absent
end

@testset "Aqua" begin
    Aqua.test_all(AbsentTypes)
end
