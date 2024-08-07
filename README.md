# BeeDeeDee

Behavior-Driven Development (BDD) is a software development methodology that extends Test-Driven Development (TDD) by emphasizing collaboration between developers, testers, and non-technical stakeholders. BDD focuses on specifying the behavior of a system through examples and scenarios written in a natural, readable language.

[![Build Status](https://github.com/BrianDouglasIE/BeeDeeDee.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/BrianDouglasIE/BeeDeeDee.jl/actions/workflows/CI.yml?query=branch%3Amain)


```julia
using BeeDeeDee

describe("Calculator", function()
    before_all(() -> println("Setting up before all tests"))
    before_each(() -> println("Setting up before each test"))

    it("should add two numbers correctly", function()
        result = add(1, 2)
        expect(result) |> to_be(3)
    end)

    it("should subtract two numbers correctly", function()
        result = subtract(5, 3)
        expect(result) |> to_be(2)
    end)

     it("should subtract two numbers correctly", function()
        result = subtract(5, 2)
        expect(result) |> not |> to_be(5)
    end)
end)
```

## Explanation

 - describe("Calculator", ...): Groups tests related to the Calculator feature.
 - before_all: Runs setup code once before all tests in the describe block.
 - before_each: Runs setup code before each individual test.
 - it("should add two numbers correctly", ...): Defines a test case for the addition functionality.
 - expect(result) |> to_be(3): Asserts that the result of the addition is 3.
 - expect(result) |> not |> to_be(3): Asserts that the result is not 3.

## Benefits

 - Readability: Makes tests more understandable by using natural language.
 - Organization: Groups tests logically, making it easier to maintain and understand.
 - Maintainability: Encourages writing tests that reflect the desired behavior of the system.