module Matchers
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
	
	export to_be, to_be_true, to_be_false, to_be_nothing, to_be_typeof, to_be_empty,
	to_have_key, to_be_subset, to_be_setequal, to_be_disjoint, to_be_in
	
	function to_be(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(actual.value, expected)
		end
	end

	function to_be_true(actual::Expectation)
		@test actual.comparator(actual.value, true)
	end

	function to_be_false(actual::Expectation)
		@test actual.comparator(actual.value, false)
	end

	function to_be_nothing(actual::Expectation)
		@test actual.comparator(isnothing(actual.value), true)
	end

	function to_be_typeof(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(typeof(actual.value), expected)
		end
	end

	function to_be_empty(actual::Expectation)
		@test actual.comparator(isempty(actual.value), true)
	end

	function to_have_key(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(haskey(actual.value, expected), true)
		end
	end

	function to_be_subset(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(issubset(actual.value, expected), true)
		end
	end

	function to_be_setequal(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(issetequal(actual.value, expected), true)
		end
	end

	function to_be_disjoint(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(isdisjoint(actual.value, expected), true)
		end
	end

	function to_be_in(expected::Any)
		return (actual::Expectation) -> begin
			@test actual.comparator(in(actual.value, expected), true)
		end
	end
end