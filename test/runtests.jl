using GraphHelpers, Graphs, Test
gs = all_labeled_graphs.(1:5)
@test length.(gs) == GraphHelpers.n_labeled_graphs.(1:5)

ug = unique_graphs.(gs)
ag = all_graphs.(1:5)
@test all(map(x -> GraphHelpers.is_set_isomorphic(x), zip(ug, ag)))
@test length.(ag) == [1, 2, 4, 11, 34] # A000088

cgs = map(xs -> unique_graphs(filter(is_connected, xs)), gs)
@test length.(cgs) == [1, 1, 2, 6, 21] # OEIS A001349

g = SimpleGraph(3)
@test !is_complete(g) && is_complete(complete!(g))
@test ne(g) == 3

g = SimpleDiGraph(3)
@test !is_complete(g) && is_complete(complete!(g))
@test ne(g) == 6

g = SimpleDiGraph(3)
add_edge!(g, 1, 2)
add_edge!(g, 2, 3)
@test GraphHelpers.is_tree(g)
add_edge!(g, 1, 3)
@test !GraphHelpers.is_tree(g)

# disabling to not add a bunch of deps
# @testset "fun" begin include("fun.jl") end
