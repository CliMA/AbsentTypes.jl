using Test
using AbsentTypes
using Aqua

@testset "AbsentTypes" begin
	@test 1 == 1
end

@testset "Aqua" begin
	@test Aqua.test_all(AbsentTypes)
end
