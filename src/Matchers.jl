module Matchers
using Test
using ..TestSuite

export to_be, to_be_true, to_be_false, to_be_nothing, to_be_typeof, to_be_empty,
    to_have_key, to_be_subset, to_be_setequal, to_be_disjoint, to_be_in,
    to_be_greater_than,
    to_be_less_than,
    to_be_greater_than_or_equal,
    to_be_less_than_or_equal,
    to_be_valid_email, to_match

to_be = construct_comparator(===, "to be")
to_be_true = () -> to_be(true)
to_be_false = () -> to_be(false)
to_be_greater_than = construct_comparator(>, "to be greater than")
to_be_less_than = construct_comparator(<, "to be less than")
to_be_greater_than_or_equal = construct_comparator(>=, "to be greater than or equal")
to_be_less_than_or_equal = construct_comparator(<=, "to be less than or equal")
to_be_in = construct_comparator(in, "to be in")
to_be_nothing = construct_comparator(isnothing, "to be nothing")
to_be_typeof = construct_comparator(isa, "to be type of")
to_be_empty = construct_comparator(isempty, "to be empty")
to_have_key = construct_comparator(haskey, "to have key")
to_be_subset = construct_comparator(issubset, "to be subset of")
to_be_setequal = construct_comparator(issetequal, "to have equal set")
to_be_disjoint = construct_comparator(isdisjoint, "to be disjoint of")
to_match = construct_comparator((expected, actual) -> occursin(actual, expected), "to match")

function is_valid_email(email::String)::Bool
    # Define a regular expression for a basic email format
    email_regex = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return occursin(email_regex, email)
end

to_be_valid_email = construct_comparator(is_valid_email, "to be valid email")

end