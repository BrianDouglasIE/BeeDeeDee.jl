# BeeDeeDee.jl

BeeDeeDee.jl is a testing framework for Julia that provides a simple and flexible way to define and run tests with support for hooks, asynchronous operations, and various matchers.

[![Build Status](https://github.com/BrianDouglasIE/BeeDeeDee.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/BrianDouglasIE/BeeDeeDee.jl/actions/workflows/CI.yml?query=branch%3Amain)


## Features

 - **Hooks**: Define `before_all`, `before_each`, `after_all`, and `after_each` hooks at both the top level and within individual describe blocks.
 - **Asynchronous Testing**: Support for testing asynchronous code with tasks.
 - **Matchers**: A rich set of matchers for writing expressive tests.

## Installation

To install BeeDeeDee.jl, use the Julia package manager:

```julia
using Pkg
Pkg.add("BeeDeeDee")

using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers
```

## Usage

### Hooks

BeeDeeDee.jl supports hooks that can be used to set up and tear down tests. These include `before_all`, `before_each`, `after_all`, and `after_each`.

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

describe("Example of hooks, scoped to a describe", () -> begin
    test_subject_before_all = 0
    test_subject_before_each = 0
    test_subject_after_each = 0
    test_subject_after_all = 0

    before_all(() -> test_subject_before_all += 1)
    before_each(() -> test_subject_before_each += 1)
    after_all(() -> test_subject_after_all += 1)
    after_each(() -> test_subject_after_each += 1)

    it("should increment before_all", () -> expect(test_subject_before_all) |> to_be(1))
    it("should increment before_each and not before_all", () -> begin
        expect(test_subject_before_all) |> to_be(1)
        expect(test_subject_before_each) |> to_be(2)
    end)
    it("should increment after each", () -> expect(test_subject_after_each) |> to_be(2))
end)
```

### Asynchronous Testing

BeeDeeDee.jl allows you to test asynchronous functions using the `@async` macro and the `fetch` function.

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

function async_double(x)
    return @async begin
        sleep(1)
        return x * 2
    end
end

it("should correctly test async method call", @async begin
    sleep(1)
    expect(1) |> to_be(1)
end)

describe("An async describe block with async calls", () -> begin
    it("should correctly test async method call", () -> begin
        four = async_double(2)
        result = fetch(four)
        expect(result) |> to_be(4)
    end)
    it("should handle non async with async tests", () -> expect(1) |> to_be(1))
end)
```

### Comparators

BeeDeeDee.jl provides a variety of comparators to write human readable assertions. Comparators are available from the `BeeDeeDee.Comparators` module.

```julia
using BeeDeeDee.Comparators
```

#### to_be

Assert that the actual value is equal to the expected value. Equivalent of `===`.

```julia
expect(1) |> to_be(1)
```

#### to_be_true

Assert that the actual value is equal to `true`. Uses `===`.

```julia
expect(true) |> to_be_true()
```

#### to_be_false

Assert that the actual value is equal to `false`. Uses `===`.

```julia
expect(false) |> to_be_false()
```

#### to_be_nothing

Assert that the actual value is equal to `nothing`. Uses `isnothing`.

```julia
expect(nothing) |> to_be_nothing()
```

#### to_be_empty

Assert that the actual value is empty. Uses `isempty`.

```julia
expect([]) |> to_be_empty()
```

#### to_be_typeof

Assert that the actual value is a type of the supplied type. Uses `isa`.

```julia
expect(1) |> to_be_typeof(Int8)
```

#### to_have_key

Assert that the actual value contains the supplied key. Uses `haskey`.

```julia
expect(Dict("a" => 1)) |> to_have_key("a")
```

#### to_be_in

Assert that the actual value is in the supplied `Vector`. Uses `in`.

```julia
expect(1) |> to_be_in([1])
```

#### to_match

Assert that the actual value matches the supplied `Regex` or `String`. Uses `occursin`.

```julia
expect("World") |> to_match("Hello, World!")
```

#### to_be_valid_email

Assert that the actual value is an email `String`. Uses `r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"`.

```julia
expect("my@email.com") |> to_be_valid_email()
```

#### to_throw

Assert that the actual value throws an exception when called.

```julia
expect(() -> throw(ErrorException("This is an error message."))) |> to_throw()
```

<!-- to_be_greater_than = construct_comparator(>, "to be greater than")
to_be_less_than = construct_comparator(<, "to be less than")
to_be_greater_than_or_equal = construct_comparator(>=, "to be greater than or equal")
to_be_less_than_or_equal = construct_comparator(<=, "to be less than or equal")
to_be_subset = construct_comparator(issubset, "to be subset of")
to_be_setequal = construct_comparator(issetequal, "to have equal set")
to_be_disjoint = construct_comparator(isdisjoint, "to be disjoint of") -->

