
using StatsBase
"https://oeis.org/A058879, requires StatsBase"
connected_unicyclic_countmap(n::Integer) = connected_unicyclic_countmap(all_connected_unicyclic(n))
function connected_unicyclic_countmap(gs)
    nc = cycles.(gs)
    countmap(length.(first.(nc)))
end

cu = connected_unicyclic_countmap.(1:6)
t = @. sort(collect(values(cu)))
@test t == [Int64[], Int64[], [1], [1, 1], [1, 1, 3], [1, 1, 4, 7]]

using GraphMakie, WGLMakie, NetworkLayout, Boolin

f = boolean_function(256, 3)
expr = Symbolics.toexpr(f)

nnodes = length(collect(PostOrderDFS(expr)))
gexpr, labels = walk_tree(expr)
@test nv(gexpr) == nnodes

f2 = remove_arr_vars(f)
ex = Symbolics.toexpr(f)
f3 = simplify(f2)
ex2 = Symbolics.toexpr(f2)
@test isequal(f, f2) && isequal(ex, ex2) # no minimization happened 

g, labels = walk_tree(ex2)
expr_tree_plot(ex2)
