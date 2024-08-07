using BeeDeeDee.Suite
using BeeDeeDee.Assertions

using Test

@testset "BeeDeeDee.jl" begin
    describe("A suite", function()
        it("contains spec with an expectation", function()
            expect(true) |> to_be(true);
        end);
    end);

    describe("A negative suite", function()
        it("contains spec with a negative expectation", function()
            expect(true) |> not |> to_be(true);
        end);
    end);

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
