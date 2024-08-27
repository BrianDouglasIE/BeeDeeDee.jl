module BeeDeeDee
using Crayons.Box

include("TestSuite.jl")
include("Comparators.jl")

export TestSuite, Comparators, run_test_files

function run_test_files(files::Vector{String})
	for file in files
		include(file)
	end

    for (_, s) in TestSuite.suites    	
        if any(it -> it.status === :Fail, s.tests)
	    	println()
            println("[", BOLD(s.description), "]")

            for t in s.tests
                if t.status === :Fail
                    println("  [", t.description, "]")
                    println("    [Failing Expectations]: ", BOLD("$(length(count(it -> !it.result, t.expectations)))"))
                    for e in t.expectations
                        if !e.result
                            println("      ", RED_FG(BOLD(join(e.logs, " "))))
                            println("\n    ", BOLD("Stacktrace: "))
                            for (i, frame) in enumerate(t.stacktrace)
                                println("    [$i]: ", frame)
                            end
                        end
                    end
                end
            end
        end
    end

	return true
end

end
