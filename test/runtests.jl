using GraphHelpers, Graphs, Test
gs = all_labeled_graphs.(1:5)
@test length.(gs) == GraphHelpers.n_labeled_graphs.(1:5)

g5 = gs[end]
ug = unique_graphs.(gs)
ag = all_graphs.(1:5)
@test all(map(x -> GraphHelpers.is_set_isomorphic(x), zip(ug, ag)))
@test length.(ag) == [1, 2, 4, 11, 34] # A000088

cgs = map(xs -> unique_graphs(filter(is_connected, xs)), gs)
@test length.(cgs) == [1, 1, 2, 6, 21] # OEIS A001349

# disabling to not add a bunch of deps
# @testset "fun" begin include("fun.jl") end
