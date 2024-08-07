module Suite
    using Test

    export describe, it, before_all, before_each

    mutable struct DescribeBlock
        before_all::Union{Nothing, Function}
        before_each::Union{Nothing, Function}
        tests::Vector{Tuple{String, Function}}
    end

    global suites = Dict{String, DescribeBlock}()
    global before_all_called = false
	global current_suite_name = ""

	# set top level as it's own block
	suites[current_suite_name] = DescribeBlock(nothing, nothing, [])
    
    function describe(description::String, f::Function)
    	global current_suite_name = description
        
        if !haskey(suites, description)
            suites[description] = DescribeBlock(nothing, nothing, [])
        end

        global before_all_called = false
        
        @testset "$description" begin
            f()
        end

        global current_suite_name = ""
    end

    function it(description::String, f::Function)
        suite = suites[current_suite_name]
        
        if !isnothing(suite.before_all) && !before_all_called
            suite.before_all()
            global before_all_called = true
        end
        
        if !isnothing(suite.before_each)
            suite.before_each()
        end
        
        @testset "$description" begin
            f()
        end
    end

    function before_all(f::Function)
        suite = suites[current_suite_name]
        suite.before_all = f
    end

    function before_each(f::Function)
        suite = suites[current_suite_name]
        suite.before_each = f
    end
end