# BeeDeeDee.jl

BeeDeeDee.jl is a testing framework for Julia that provides a simple and flexible way to define and run tests with support for hooks, asynchronous operations, and various comparators.

[![Build Status](https://github.com/BrianDouglasIE/BeeDeeDee.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/BrianDouglasIE/BeeDeeDee.jl/actions/workflows/CI.yml?query=branch%3Amain)


## Features

 - **Hooks**: Define `before_all`, `before_each`, `after_all`, and `after_each` hooks at both the top level and within individual describe blocks.
 - **Asynchronous Testing**: Support for testing asynchronous code with tasks.
 - **Comparators**: A rich set of comparators for writing expressive tests.

## Installation

To install BeeDeeDee.jl, use the Julia package manager:

```julia
using Pkg
Pkg.add("BeeDeeDee")

using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators
```

## Usage

### Running tests

Test files can be run using the `run_test_files` function. This accepts a list of files to run.

```julia
run_test_files(["./basic.test.jl", "./multi-file.test.jl"])
```

### Tests

#### `it` and `test`

Both `it` and `test` can be used to define a test. Both can be nested inside `describe` or `testset` blocks. Expectations run inside a `test` or `it` block are captured and reported on.

#### Using `it`

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators

it("should have an age greater than or equal 18") do
    expect(user.age) |> to_be_greater_than(18)
    expect(user.age) |> to_be_greater_than_or_equal(18)
    expect(user.age) |> not |> to_be_less_than(18)
end
```

#### Using `test`

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators

test("should have an age greater than or equal 18") do
    expect(user.age) |> to_be_greater_than(18)
    expect(user.age) |> to_be_greater_than_or_equal(18)
    expect(user.age) |> not |> to_be_less_than(18)
end
```

### Test Suites

#### `describe` and `testset`

Both `describe` and `testset` can be used to group tests. Both can be nested inside other `describe` or `testset` blocks.

#### Using `describe`

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators

describe("User Age Tests") do
    it("should have an age greater than or equal 18") do
        expect(user.age) |> to_be_greater_than(18)
        expect(user.age) |> to_be_greater_than_or_equal(18)
        expect(user.age) |> not |> to_be_less_than(18)
    end
end
```

#### Using `testset`

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators

testset("User Age Tests") do
    test("should have an age greater than or equal 18") do
        expect(user.age) |> to_be_greater_than(18)
        expect(user.age) |> to_be_greater_than_or_equal(18)
        expect(user.age) |> not |> to_be_less_than(18)
    end
end
```

### Hooks

BeeDeeDee.jl supports hooks that can be used to set up and tear down tests. These include `before_all`, `before_each`, `after_all`, and `after_each`.

> Note: hooks should be placed inside a `testset` of `describe.`

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators

describe("Example of hooks, scoped to a describe") do
    test_subject_before_all = 0
    test_subject_before_each = 0
    test_subject_after_each = 0
    test_subject_after_all = 0

    before_all(() -> test_subject_before_all += 1)
    before_each(() -> test_subject_before_each += 1)
    after_all(() -> test_subject_after_all += 1)
    after_each(() -> test_subject_after_each += 1)

    it("should increment before_all") do
        expect(test_subject_before_all) |> to_be(1)
    end
    
    it("should increment before_each and not before_all") do
        expect(test_subject_before_all) |> to_be(1)
        expect(test_subject_before_each) |> to_be(2)
    end
    
    it("should increment after each") do
        expect(test_subject_after_each) |> to_be(2)
    end
end
```

### Asynchronous Testing

BeeDeeDee.jl allows you to test asynchronous functions using the `@async` macro and the `fetch` function.

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Comparators

function async_double(x)
    return @async begin
        sleep(1)
        return x * 2
    end
end

it("should correctly test async method call") do
    @async begin
        sleep(1)
        expect(1) |> to_be(1)
    end
end

describe("An async describe block with async calls") do
    it("should correctly test async method call") do
        four = async_double(2)
        result = fetch(four)
        expect(result) |> to_be(4)
    end
    
    it("should handle non async with async tests")
        expect(1) |> to_be(1)
    end
end
```
### Expectations

#### `expect`

Creates an expectation that can be used to pipe comparators.

```julia
expect(user.age) |> to_be_greater_than(18)
```

#### `not`

Negates an expectation, meaning that any piped comparators should evaluate to `false`.

```julia
expect(my_value) |> not |> to_be_true()
```

#### `and`

Used to combine expectations and comparators.

```julia
expect(user.age) |> to_be_greater_than(18) |> and |> to_be_less_than(120)
```

### Comparators

BeeDeeDee.jl provides a variety of comparators to write human readable assertions. Comparators are available from the `BeeDeeDee.Comparators` module.

```julia
using BeeDeeDee.Comparators
```

#### Assertions

##### to_be

Assert that the actual value is equal to the expected value. Uses `===`.

```julia
expect(1) |> to_be(1)
```

##### to_be_true

Assert that the actual value is equal to `true`. Uses `=== true`.

```julia
expect(true) |> to_be_true()
```

##### to_be_false

Assert that the actual value is equal to `false`. Uses `=== false`.

```julia
expect(false) |> to_be_false()
```

##### to_be_nothing

Assert that the actual value is equal to `nothing`. Uses `isnothing`.

```julia
expect(nothing) |> to_be_nothing()
```

##### to_be_empty

Assert that the actual value is empty. Uses `isempty`.

```julia
expect([]) |> to_be_empty()
```

##### to_be_typeof

Assert that the actual value is a type of the supplied type. Uses `isa`.

```julia
expect(1) |> to_be_typeof(Int8)
```

##### to_throw

Assert that the actual value throws an exception when called.

```julia
expect(() -> throw(ErrorException("This is an error message."))) |> to_throw()
```

#### Strings

##### to_match

Assert that the actual value matches the supplied `Regex` or `String`. Uses `occursin`.

```julia
expect("World") |> to_match("Hello, World!")
```

##### to_be_valid_email

Assert that the actual value is an email `String`. Uses `r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"`.

```julia
expect("my@email.com") |> to_be_valid_email()
```

#### Numbers

##### to_be_greater_than

Assert that the actual value is greater than the supplied value. Uses `>`.

```julia
expect(10) |> to_be_greater_than(9)
```

##### to_be_greater_than_or_equal

Assert that the actual value is greater or equal than the supplied value. Uses `>=`.

```julia
expect(10) |> to_be_greater_than_or_equal(9)
```

##### to_be_less_than

Assert that the actual value is less than the supplied value. Uses `<`.

```julia
expect(9) |> to_be_less_than(10)
```

##### to_be_less_than_or_equal

Assert that the actual value is less or equal than the supplied value. Uses `<=`.

```julia
expect(9) |> to_be_less_than_or_equal(10)
```

#### Collections

##### to_be_subset

Assert that the actual value is a subset of the supplied value. Uses `issubset`.

```julia
expect([1]) |> to_be_subset([1, 2])
```

##### to_be_setequal

Assert that the actual value is set equal to the supplied value. Uses `issetequal`.

```julia
expect([1, 2]) |> to_be_subset([2, 1])
```

##### to_be_disjoint

Assert that the actual value is a disjoint of the supplied value. Uses `isdisjoint`.

```julia
expect([1, 4]) |> to_be_disjoint([2, 3])
```

##### to_have_key

Assert that the actual value contains the supplied key. Uses `haskey`.

```julia
expect(Dict("a" => 1)) |> to_have_key("a")
```

##### to_be_in

Assert that the actual value is in the supplied `Vector`. Uses `in`.

```julia
expect(1) |> to_be_in([1])
```
