module TestSuite
using Crayons.Box

export describe, it, test, before_all, before_each, after_all, after_each,
    Expectation, expect, not, and, create_expectation, construct_comparator,
    testset, suites, tests

struct Expectation
    value::Any
    comparator::Function
    result::Bool
    logs::Vector{String}
end

Base.@kwdef mutable struct Hooks
    before_all_called::Bool = false
    after_all_called::Bool = false
    before_all::Vector{Union{Nothing,Function}} = []
    after_all::Vector{Union{Nothing,Function}} = []
    before_each::Vector{Union{Nothing,Function}} = []
    after_each::Vector{Union{Nothing,Function}} = []
end

Base.@kwdef mutable struct TestResult
    description::String = ""
    status::Symbol = :Pending
    f::Union{Task,Function} = () -> nothing
    expectations::Vector{Expectation} = []
    stacktrace::Any = []
end

Base.@kwdef mutable struct Suite
    tests::Vector{TestResult} = []
    child_suites::Vector{Suite} = []
    f::Union{Task,Function} = () -> nothing
    status::Symbol = :Pending
    hooks::Hooks = Hooks()
    description::String = ""
    id::Int64 = 0
end

global suite_count = 0
global suites = Dict{Int64,Suite}()
global tests = Dict{Int64,TestResult}()
global current_suite_id = 0
global current_test = 0
global top_level_suite = Suite()

function handle_callback(callback)
    if isa(callback, Task)
        return fetch(callback)
    elseif isa(callback, Function)
        return callback()
    else
        throw(ArgumentError("Callback must be a Task or a Function"))
    end
end

function execute_before_all_hooks(hooks::Hooks)
    if hooks.before_all_called == false
        [handle_callback(f) for f in hooks.before_all]
        hooks.before_all_called = true
    end
end

function execute_before_each_hooks(hooks::Hooks)
    [handle_callback(f) for f in hooks.before_each]
end

function execute_after_all_hooks(hooks::Hooks)
    if hooks.after_all_called == false
        [handle_callback(f) for f in hooks.after_all]
        hooks.after_all_called = true
    end
end

function execute_after_each_hooks(hooks::Hooks)
    [handle_callback(f) for f in hooks.after_each]
end

function get_current_suite()::Suite
    if isempty(current_suite_id)
        return top_level_suite
    end

    if !haskey(suites, current_suite_id)
        suites[current_suite_id] = Suite()
    end

    return suites[current_suite_id]
end

function get_current_test()::TestResult
    if !haskey(tests, current_test)
        tests[current_test] = TestResult()
    end

    return tests[current_test]
end

function testset(description::String, f::Union{Task,Function})::Suite
    return testset(f, description)
end

function testset(f::Union{Task,Function}, description::String)::Suite
    global suite_count += 1
    parent_suite = nothing
    if current_suite_id !== 0
        parent_suite = get_current_suite()
    end

    global current_suite_id = suite_count
    suite = get_current_suite()
    suite.description = description
    suite.f = f
    suite.id = suite_count

    if !isnothing(parent_suite)
        push!(parent_suite.child_suites, suite)
    else
        execute_suite(suite)
    end

    if !isnothing(parent_suite)
        global current_suite_id = parent_suite.id
    else
        global current_suite_id = 0
    end

    return suite
end

function execute_suite(suite::Suite)
    global current_suite_id = suite.id
    handle_callback(suite.f)

    execute_before_all_hooks(suite.hooks)
    execute_queued_tests(suite)

    if !isempty(suite.child_suites)
        for child_suite in suite.child_suites
            execute_suite(child_suite)
        end
    end

    execute_after_all_hooks(suite.hooks)

    suite.status = :Complete
end

describe = testset

function execute_queued_tests(suite::Suite)
    for test in suite.tests
        if test.status === :Pending
            execute_before_each_hooks(suite.hooks)

            handle_callback(test.f)

            if any(it -> it.result === false, test.expectations)
                test.status = :Fail
            else
                test.status = :Pass
            end

            if test.status === :Pass
                print(GREEN_FG(BOLD(".")))
            else
                print(RED_FG(BOLD("x")))
            end

            execute_after_each_hooks(suite.hooks)
        end
    end

end

function test(description::String, f::Union{Task,Function})::TestResult
    return test(f, description)
end

function test(f::Union{Task,Function}, description::String)::TestResult
    global current_test += 1

    suite = get_current_suite()
    test = get_current_test()

    test.description = description
    test.f = f
    test.stacktrace = stacktrace()

    push!(suite.tests, test)

    return test
end

it = test

function before_all(f::Union{Task,Function})
    push!(get_current_suite().hooks.before_all, f)
end

function before_each(f::Union{Task,Function})
    push!(get_current_suite().hooks.before_each, f)
end

function after_all(f::Union{Task,Function})
    push!(get_current_suite().hooks.after_all, f)
end

function after_each(f::Union{Task,Function})
    push!(get_current_suite().hooks.after_each, f)
end

function create_expectation(value::Any,
    comparator::Function,
    result::Bool,
    logs::Vector{String})::Expectation
    expectation = Expectation(value, comparator, result, logs)
    push!(get_current_test().expectations, expectation)
    return expectation
end

function expect(value::Any)
    return create_expectation(value, ===, true, ["Expecting $value"])
end

function not(expected::Expectation)
    inverted_comparator = (x, y) -> !expected.comparator(x, y)
    log = "NOT"
    return create_expectation(expected.value, inverted_comparator, expected.result, [expected.logs...; log])
end

function and(expected::Expectation)
    log = "AND"
    return create_expectation(expected.value, expected.comparator, expected.result, [expected.logs...; log])
end

function construct_comparator(comparator::Function, description::String)
    return function (expected_value::Any=nothing)
        return (actual::Expectation) -> begin
            if isnothing(expected_value)
                result = comparator(actual.value)
            else
                result = comparator(actual.value, expected_value)
            end

            result = actual.comparator(result, true)

            log = ["$description $(expected_value)"]

            return create_expectation(actual.value, ===, actual.result && result, [actual.logs...; log])
        end
    end
end

end