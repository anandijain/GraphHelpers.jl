using GraphHelpers, Graphs, Test

gs = all_labeled_graphs.(1:5)
g5 = gs[end]
ug5 = unique_graphs(g5)
@test length(g5) == 2^(binomial(5, 2))
@test length(ug5) == 34

cgs = map(xs -> unique_graphs(filter(is_connected, xs)), gs)

@test length.(cgs) == [1, 1, 2, 6, 21] # OEIS A001349
