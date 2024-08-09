module TestSuite
    using Test

    export describe, it, before_all, before_each, after_all, after_each

    Base.@kwdef mutable struct Hooks
        before_all_called::Bool = false
        after_all_called::Bool = false
        before_all::Vector{Union{Nothing, Function}} = []
        after_all::Vector{Union{Nothing, Function}} = []
        before_each::Vector{Union{Nothing, Function}} = []
        after_each::Vector{Union{Nothing, Function}} = []
    end

    Base.@kwdef mutable struct Suite
        tests::Vector{Tuple{String, Union{Task,Function}}} = []
        hooks::Hooks = Hooks()
    end

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
    
    global suites = Dict{String, Suite}()
	global current_suite_name = ""
    global top_level_suite = Suite()

    function get_current_suite()::Suite
        if isempty(current_suite_name)
            return top_level_suite
        end

        if !haskey(suites, current_suite_name)
            suites[current_suite_name] = Suite()
        end
        
        return suites[current_suite_name]
    end

    
    function describe(description::String, f::Union{Task,Function}; verbose::Bool = false)
    	global current_suite_name = description
        
        suite = get_current_suite()
        
        @testset verbose=verbose "$description" begin
            handle_callback(f)
        end

        execute_after_all_hooks(suite.hooks)
        
        global current_suite_name = ""
    end

    function it(description::String, f::Union{Task,Function};  verbose::Bool = false)
        suite = get_current_suite()
        
        execute_before_all_hooks(suite.hooks)
        execute_before_each_hooks(suite.hooks)
        
        @testset verbose=verbose "$description" begin
            handle_callback(f)
        end

        execute_after_each_hooks(suite.hooks)
    end
 
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
end