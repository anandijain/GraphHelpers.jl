function push_graph!(set::AbstractSet, g::AbstractGraph)
    for e in set
        if Graphs.Experimental.has_isomorph(g, e)
            return set
        end
    end
    push!(set, g)
end

function unique_graphs(gs)
    S = Set{AbstractGraph}()
    for g in gs
        push_graph!(S, g)
    end
    S
end

"
given two Set{AbstractGraph}, 
determine if the graphs contain the same 
"
is_set_isomorphic(a, b) = length(unique_graphs(union(a, b))) == length(a) == length(b)
is_set_isomorphic(xs) = foldl(is_set_isomorphic, xs)

possible_edges(g) = combinations(1:nv(g), 2)

"
tbh idk what this does
graph_from_bits(Bool.((0, 1, 0, 1)))
"
graph_from_bits(b) = graph_from_bitstring!(SimpleGraph(length(b)), b)
graph_from_bits(b, el) = graph_from_bitstring!(SimpleGraph(length(b)), b, el)
graph_from_bitstring!(g, b) = graph_from_bitstring!(g, b, collect(possible_edges(g)))

function graph_from_bitstring!(g, b, c)
    for (i, v) in enumerate(b)
        v && add_edge!(g, c[i]...)
    end
    g
end

"we remove the cycles of length two since converting SimpleGraph to SimpleDiGraph does `add_edge(g, a, b)` and `add_edge(g, b, a)`"
cycles(g::SimpleGraph) = Iterators.filter(x -> length(x) > 2, simplecycles_iter(SimpleDiGraph(g)))
self_loops(g) = Iterators.filter(e -> e.src == e.dst, edges(g))
