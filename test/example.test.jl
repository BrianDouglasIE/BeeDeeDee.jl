using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

struct User
    name::String
    age::Int8
    email::String
end

describe("User Tests", () -> begin
    user = nothing

    before_all(() -> begin
        user = User("Emma", 28, "my@email.com")
    end)

    describe("User Age Tests", () -> begin
        # examples of testing age, all with same outcome
        it("should have an age greater than or equal 18", () -> begin
            expect(user.age) |> to_be_greater_than(18)
            expect(user.age) |> to_be_greater_than_or_equal(18)
            expect(user.age) |> not |> to_be_less_than(18)
        end)
    end)

    describe("User Name Tests", () -> begin
        it("should have a valid name", () -> begin
            expect(user.name) |> not |> to_be_empty()

            (expect(length(user.name))
             |> to_be_greater_than_or_equal(1)
             |> and
             |> to_be_less_than_or_equal(255))
        end)
    end)

    describe("User Email Tests", () -> begin
    	it("should have a valid email", () -> begin
    		expect(user.email) |> to_be_valid_email()
    		expect(user.email) |> to_match(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
    	end)
    end)
end)