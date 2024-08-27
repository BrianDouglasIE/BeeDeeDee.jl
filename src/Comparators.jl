module Comparators

using ..TestSuite

macro export_const(e)
    Base.isexpr(e, :(=), 2) || error("Must be used on an assignment form, got $e")
    quote
        export $(e.args[1])
        const $(e.args[1]) = $(e.args[2])
    end |> esc
end

@export_const to_be = construct_comparator(===, "to be")
@export_const to_be_true = Returns(to_be(true))
@export_const to_be_false = Returns(to_be(false))
@export_const to_be_greater_than = construct_comparator(>, "to be greater than")
@export_const to_be_less_than = construct_comparator(<, "to be less than")
@export_const to_be_greater_than_or_equal = construct_comparator(>=, "to be greater than or equal")
@export_const to_be_less_than_or_equal = construct_comparator(<=, "to be less than or equal")
@export_const to_be_in = construct_comparator(in, "to be in")
@export_const to_be_nothing = construct_comparator(isnothing, "to be nothing")
@export_const to_be_typeof = construct_comparator(isa, "to be type of")
@export_const to_be_empty = construct_comparator(isempty, "to be empty")
@export_const to_have_key = construct_comparator(haskey, "to have key")
@export_const to_be_subset = construct_comparator(issubset, "to be subset of")
@export_const to_be_setequal = construct_comparator(issetequal, "to have equal set")
@export_const to_be_disjoint = construct_comparator(isdisjoint, "to be disjoint of")
@export_const to_match = construct_comparator((expected, actual) -> occursin(actual, expected), "to match")
@export_const to_be_valid_email = Returns(to_match(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"))
@export_const to_throw = construct_comparator("to throw") do actual
    try
        actual()
        return false
    catch
        return true
    end
end

end