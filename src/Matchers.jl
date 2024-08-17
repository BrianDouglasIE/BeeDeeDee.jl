module Matchers
using Test

export Expectation, expect, not, and

struct Expectation
    value::Any
    comparator::Function
    result::Bool
    logs::Vector{String}
end

function expect(value::Any)
    return Expectation(value, ===, true, ["Expecting $value"])
end

function not(expected::Expectation)
    inverted_comparator = (x, y) -> !expected.comparator(x, y)
	log = "NOT"
    return Expectation(expected.value, inverted_comparator, expected.result, [expected.logs...; log])
end

function and(expected::Expectation)
	log = "AND"
    return  Expectation(expected.value, expected.comparator, expected.result, [expected.logs...; log])
end

export to_be, to_be_true, to_be_false, to_be_nothing, to_be_typeof, to_be_empty,
    to_have_key, to_be_subset, to_be_setequal, to_be_disjoint, to_be_in

function to_be(expected_value::Any)
    expected = expect(expected_value)
    return (actual::Expectation) -> begin
        result = actual.comparator(expected.value, actual.value)
        log = ["to be $(expected.value)"]
        return Expectation(expected.value, actual.comparator, expected.result && result, [actual.logs...; log])
    end
end

function to_be_true(actual::Expectation)
    return actual.comparator(actual.value, true)
end

function to_be_false(actual::Expectation)
    return actual.comparator(actual.value, false)
end

function to_be_nothing(actual::Expectation)
    return actual.comparator(isnothing(actual.value), true)
end

function to_be_typeof(expected::Any)
    return (actual::Expectation) -> begin
        return actual.comparator(typeof(actual.value), expected)
    end
end

function to_be_empty(actual::Expectation)
    return actual.comparator(isempty(actual.value), true)
end

function to_have_key(expected::Any)
    return (actual::Expectation) -> begin
        return actual.comparator(haskey(actual.value, expected), true)
    end
end

function to_be_subset(expected::Any)
    return (actual::Expectation) -> begin
        return actual.comparator(issubset(actual.value, expected), true)
    end
end

function to_be_setequal(expected::Any)
    return (actual::Expectation) -> begin
        return actual.comparator(issetequal(actual.value, expected), true)
    end
end

function to_be_disjoint(expected::Any)
    return (actual::Expectation) -> begin
        return actual.comparator(isdisjoint(actual.value, expected), true)
    end
end

function to_be_in(expected::Any)
    return (actual::Expectation) -> begin
        return actual.comparator(in(actual.value, expected), true)
    end
end
end