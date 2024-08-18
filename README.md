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

### Matchers

BeeDeeDee.jl provides a variety of matchers to write expressive and readable tests.

```julia
using BeeDeeDee.TestSuite
using BeeDeeDee.Matchers

describe("Matchers", () -> begin
    it("to_be", () -> expect(1) |> to_be(1))
    it("not |> to_be", () -> expect(2) |> not |> to_be(1))
    
    it("to_be_true", () -> expect(true) |> to_be_true)
    it("not |> to_be_true", () -> expect(false) |> not |> to_be_true)
    
    it("to_be_false", () -> expect(false) |> to_be_false)
    it("not |> to_be_false", () -> expect(true) |> not |> to_be_false)
    
    it("to_be_nothing", () -> expect(nothing) |> to_be_nothing)
    it("not |> to_be_nothing", () -> expect(1) |> not |> to_be_nothing)
    
    it("to_be_typeof", () -> expect(true) |> to_be_typeof(Bool))
    it("not |> to_be_typeof", () -> expect("x") |> not |> to_be_typeof(Bool))
    
    it("to_be_empty", () -> expect([]) |> to_be_empty)
    it("not |> to_be_empty", () -> expect([1]) |> not |> to_be_empty)
    
    it("to_have_key", () -> expect(Dict(:a => 1)) |> to_have_key(:a))
    it("not |> to_have_key", () -> expect(Dict(:a => 1)) |> not |> to_have_key(:b))
    
    it("to_be_subset", () -> expect([1]) |> to_be_subset([1, 2]))
    it("not |> to_be_subset", () -> expect([3]) |> not |> to_be_subset([1, 2]))
    
    it("to_be_setequal", () -> expect([1, 2]) |> to_be_setequal([1, 2]))
    it("not |> to_be_setequal", () -> expect([1, 2, 3]) |> not |> to_be_setequal([1, 2]))
    
    it("to_be_disjoint", () -> expect([1, 4]) |> to_be_disjoint([2, 3]))
    it("not |> to_be_disjoint", () -> expect([1, 2, 3]) |> not |> to_be_disjoint([1, 4]))
    
    it("to_be_in", () -> expect(1) |> to_be_in([1, 2, 3]))
    it("not |> to_be_in", () -> expect(4) |> not |> to_be_in([1, 2, 3]))
end)
```