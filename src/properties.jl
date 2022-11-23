
function is_complete(g)
    isequal(Set(edges(g)), Set(possible_edges(g)))
end

"""
```julia
g = SimpleDiGraph(3)
add_edge!(g, 1, 2)
add_edge!(g, 1, 3)
add_edge!(g, 2, 3)
```
unless we check the indegree, the above graph would be considered a tree

"""
function is_tree(g)
    is_connected(g) && !is_cyclic(g) && all(<=(1), indegree(g))
end

is_simple(g::Graphs.AbstractSimpleGraph) = true

function is_simple(g)
    all(==(2), length.(edges(g)))
end

# "i don't think path and star will work with hypergraphs unless they are also simple"
# function is_path(g)
#     es = collect.(collect(edges(g)))

# end

function is_star(g)
    d = Graphs.degree(g)
    sort!(d; rev=true)
    d[1] == nv(g) - 1 && all(d[2:end] .== 1)
end

"todo"
function is_planar()
    error()
end

"make a cycles that doesn't do 132 and 123"
Graphs.simplecycles_iter(g::Graphs.SimpleGraph) = Iterators.filter(x->length(x)>2, simplecycles_iter(SimpleDiGraph(g)))
