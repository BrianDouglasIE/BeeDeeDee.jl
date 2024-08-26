using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

struct Animal
    name::String
    legs::Int8
end

describe("Animal Tests") do
    animal = nothing

    before_all() do
        animal = Animal("Dog", 4)
    end

    describe("Animal Legs Tests") do
	    it("should more than 1 leg and less than 4") do
	        expect(animal.legs) |> to_be_greater_than_or_equal(1) |> and |> to_be_less_than_or_equal(4)
	    end
	end

    describe("Animal Name Tests") do
        it("should have a valid name") do
            expect(animal.name) |> not |> to_be_empty()
            expect(length(animal.name)) |> to_be_greater_than_or_equal(1) |> and |> to_be_less_than_or_equal(255)
        end
    end
end


