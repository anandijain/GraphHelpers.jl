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

@test is_simple(g)
@test is_simple(SimpleGraph(g))

SE = Graphs.SimpleGraphs.SimpleEdge
g = DiGraph(SE.([1 => 2, 4 => 2, 2 => 3, 2 => 5]))

g2 = DiGraph(SE.([1 => 6, 4 => 6, 6 => 2, 2 => 3, 2 => 5]))
g3 = DiGraph(SE.([1 => 2, 4 => 2, 2 => 6, 6 => 3, 6 => 5]))

@test g2 == GraphHelpers.split_vertex_before!(deepcopy(g), 2)
@test g3 == GraphHelpers.split_vertex_after!(deepcopy(g), 2)

# disabling to not add a bunch of deps
# @testset "fun" begin include("fun.jl") end
