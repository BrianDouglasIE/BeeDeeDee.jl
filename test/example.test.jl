using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

struct User
    name::String
    age::Int8
    email::String
end

describe("User Tests") do
    user = nothing

    before_all() do
        user = User("Emma", 28, "my@email.com")
    end

    describe("User Age Tests") do
	    it("should have an age greater than or equal 18") do
	        expect(user.age) |> to_be_greater_than(18)
	        expect(user.age) |> to_be_greater_than_or_equal(18)
	        expect(user.age) |> not |> to_be_less_than(18)
	    end
	end

    describe("User Name Tests") do
        it("should have a valid name") do
            expect(user.name) |> not |> to_be_empty()

            (expect(length(user.name))
             |> to_be_greater_than_or_equal(1)
             |> and
             |> to_be_less_than_or_equal(255))
        end
    end

    describe("User Email Tests") do
        it("should have a valid email") do
            expect(user.email) |> to_be_valid_email()
            expect(user.email) |> to_match(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        end
    end
end


