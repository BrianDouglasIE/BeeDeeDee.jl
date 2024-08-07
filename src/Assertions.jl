module Assertions
	using Test

	export to_be, not, expect

	struct Expectation
		value::Any
	end

	struct NegatedExpectation
		value::Any
	end

	function expect(value::Any)
		return Expectation(value)
	end

	function not(expected::Any)
		return NegatedExpectation(expected)
	end

	function comparator(actual::Expectation, expected::Any)
		@test actual.value === expected
	end

	function comparator(actual::NegatedExpectation, expected::Any)
		@test actual.value !== expected
	end

	function to_be(expected::Any)
		return (actual::Union{Expectation,NegatedExpectation}) -> begin
			comparator(actual, expected)
		end 
	end
end