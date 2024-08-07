module Assertions
	using Test

	export not, expect, Expectation

	struct Expectation
		value::Any
		comparator::Function
	end

	function expect(value::Any)
		return Expectation(value, ===)
	end

	function not(expected::Expectation)
		return Expectation(expected.value, !==)
	end
end