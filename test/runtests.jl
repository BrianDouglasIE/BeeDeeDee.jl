using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

using Test

@testset "BeeDeeDee.jl" begin
    @testset "Hooks" begin
        @testset "Top level hooks work" begin
            test_subject_before_all = 0
            test_subject_before_each = 0
            test_subject_after_each = 0
            test_subject_after_all = 0

            before_all(() -> test_subject_before_all += 1)
            before_each(() -> test_subject_before_each += 1)
            after_all(() -> test_subject_after_all += 1)
            after_each(() -> test_subject_after_each += 1)

            it("should increment before_all", () -> expect(test_subject_before_all) |> to_be(1))

            it("should increment before_each and not before_all", () -> begin
                expect(test_subject_before_all) |> to_be(1)
                expect(test_subject_before_each) |> to_be(2)
            end)

            it("should increment after each", () -> expect(test_subject_after_each) |> to_be(2))
        end

        @testset "Describe level hooks work" begin
            test_subject_before_all = 0
            test_subject_before_each = 0
            test_subject_after_each = 0
            test_subject_after_all = 0

            describe("A suite with hooks", () -> begin
                before_all(() -> test_subject_before_all += 1)
                before_each(() -> test_subject_before_each += 1)
                after_all(() -> test_subject_after_all += 1)
                after_each(() -> test_subject_after_each += 1)

                it("should increment before_all", () -> expect(test_subject_before_all) |> to_be(1))

                it("should increment before_each and not before_all", () -> begin
                    expect(test_subject_before_all) |> to_be(1)
                    expect(test_subject_before_each) |> to_be(2)
                end)

                it("should increment after each", () -> expect(test_subject_after_each) |> to_be(2))
            end)

            it("should increment after all", () -> expect(test_subject_after_all) |> to_be(1))
        end
    end

    @testset "Async" begin
        function async_double(x)
            return @async begin
                sleep(1)
                return x * 2
            end
        end

        it("should correctly test async method call", @async begin
            sleep(1)
            expect(1) |> to_be(1)
        end)

        describe("An async describe block with async calls", () -> begin
            it("should correctly test async method call", () -> begin
                four = async_double(2)
                result = fetch(four)
                expect(result) |> to_be(4)
            end)

            it("should handle non async with async tests", () -> expect(1) |> to_be(1))
        end)
    end

    @testset "Verbose describe blocks" begin
        describe("A verbose describe block", verbose=true, () -> begin
            for i in 1:3
                it("should log the test name $i", () -> expect(i) |> to_be(i))
            end
        end)
    end

    @testset "Comparators" begin
        it("should negate comparison", () -> expect(true) |> not |> to_be(false))
        it("should combine comparison", () -> expect(true)
                                              |> to_be(true)
                                              |> and
                                              |> not
                                              |> to_be(false))
        it("should combine comparison starting with negated", () -> expect(true)
                                                                    |> not
                                                                    |> to_be(false)
                                                                    |> and
                                                                    |> to_be(true))
    end

    @testset "Matchers" begin
        it("1 is 1", () -> expect(1) |> to_be(1))

        # it("to_be_true", () -> expect(true) |> to_be_true)

        # it("to_be_false", () -> expect(false) |> to_be_false)

        # it("to_be_nothing", () -> expect(nothing) |> to_be_nothing)

        # it("to_be_typeof", () -> expect(true) |> to_be_typeof(Bool))

        # it("to_be_empty", () -> expect([]) |> to_be_empty)

        # it("to_have_key", () -> expect(Dict(:a => 1)) |> to_have_key(:a))

        # it("to_be_subset", () -> expect([1]) |> to_be_subset([1, 2]))

        # it("to_be_setequal", () -> expect([1, 2]) |> to_be_setequal([1, 2]))

        # it("to_be_disjoint", () -> expect([1, 4]) |> to_be_disjoint([2, 3]))

        # it("to_be_in", () -> expect(1) |> to_be_in([1, 2, 3]))
    end
end
