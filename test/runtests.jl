using BeeDeeDee.Suite
using BeeDeeDee.Matchers
using BeeDeeDee.Assertions

using Test

@testset "BeeDeeDee.jl" begin
    @testset "Matchers" begin
        it("to_be", () -> expect(1) |> to_be(1))
        it("not |> to_be", () -> expect(2) |> not |> to_be(1))

        it("to_be_true", () -> expect(true) |> to_be_true)
        it("not |> to_be_true", () -> expect(false) |> not |> to_be_true)

        it("to_be_false", () -> expect(false) |> to_be_false)
        it("not |> to_be_false", () -> expect(true) |> not |> to_be_false)
        
        it("to_be_nothing", () -> expect(nothing) |> to_be_nothing)
        it("not |> to_be_nothing", () -> expect(1) |> not |> to_be_nothing)

        it("to_be_typeof", () -> expect(true) |> to_be_typeof(Bool))
        it("not |> to_be_typeof", () -> expect("x") |> not |> to_be_typeof(Bool))

        it("to_be_empty", () -> expect([]) |> to_be_empty)
        it("not |> to_be_empty", () -> expect([1]) |> not |> to_be_empty)

        it("to_have_key", () -> expect(Dict(:a => 1)) |> to_have_key(:a))
        it("not |> to_have_key", () -> expect(Dict(:a => 1)) |> not |> to_have_key(:b))

        it("to_be_subset", () -> expect([1]) |> to_be_subset([1, 2]))
        it("not |> to_be_subset", () -> expect([3]) |> not |> to_be_subset([1, 2]))

        it("to_be_setequal", () -> expect([1, 2]) |> to_be_setequal([1, 2]))
        it("not |> to_be_setequal", () -> expect([1, 2, 3]) |> not |> to_be_setequal([1, 2]))

        it("to_be_disjoint", () -> expect([1, 4]) |> to_be_disjoint([2, 3]))
        it("not |> to_be_disjoint", () -> expect([1, 2, 3]) |> not |> to_be_disjoint([1, 4]))
    end

    @testset "Assertions" begin
        describe("Suite 1 - with set up", function()
            before_all(() -> println("Setup before all tests in Suite 1"))
            before_each(() -> println("Setup before each test in Suite 1"))

            it("test 1", function()
                expect(true) |> to_be(true)
            end)

            it("test 2", function()
                expect(true) |> not |> to_be(false)
            end)
        end)

        describe("Suite 2 - with different set up", function()
            before_all(() -> println("Setup before all tests in Suite 2"))
            before_each(() -> println("Setup before each test in Suite 2"))

            it("test 3", function()
                expect(true) |> to_be(true)
            end)

            it("test 4", function()
                expect(true) |> not |> to_be(false)
            end)
        end)
    end
end
