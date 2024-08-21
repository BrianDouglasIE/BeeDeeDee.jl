using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

struct User
    name::String
    age::Int8
end

describe("User Tests", () -> begin
    user = nothing

    before_all(() -> begin
        user = User("Emma", 28)
    end)

    describe("User Age Test", () -> begin
        # examples of testing age, all with same outcome
        it("should have an age greater than or equal 18", () -> expect(user.age) |> to_be_greater_than(100))
        it("should have an age greater than or equal 18", () -> expect(user.age) |> to_be_greater_than_or_equal(18))
        it("should have an age greater than or equal 18", () -> expect(user.age) |> not |> to_be_less_than(18))
    end)

    describe("User Name Test", () -> begin
    	it("should have a valid name", () -> expect(user.name) |> not |> to_be_empty())
    end)
end)