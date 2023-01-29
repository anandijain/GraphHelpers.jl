"push_graph! will only add g to set if there is no graph in set isomorphic to g"
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

"this dispatch is funky"
Base.collect(e::Graphs.SimpleEdge) = only(typeof(e).parameters)[e.src, e.dst]
self_loops(g) = Iterators.filter(e -> allequal(collect(e)), edges(g))
rem_self_loops!(g) = rem_edges!(g, self_loops(g))

possible_edges(g::SimpleGraph{T}) where {T} = Iterators.map(x -> edgetype(g)(Tuple(x)), combinations(1:nv(g), 2))
possible_edges(g::SimpleDiGraph{T}) where {T} = Iterators.map(x -> edgetype(g)(Tuple(x)), permutations(1:nv(g), 2))
Graphs.complete_graph(T, n) = complete!(T(n))

function complete!(g)
    is_complete(g) && return g
    for e in possible_edges(g)
        # for my implementation of Hypergraph this would create duplicates, since I don't check has_edge before pushing
        # this means that my Hyperedges can have multiplicities, but is undesirable here
        add_edge!(g, e)
    end
    g
end

function rem_edges!(g, es)
    # x = falses(length(es))
    for (i, e) in enumerate(es)
        # x[i] = rem_edge!(g, e)
        rem_edge!(g, e)
    end
    # x
end

function add_edges!(g, es)
    # x = falses(length(es))
    for (i, e) in enumerate(es)
        # x[i] = rem_edge!(g, e)
        add_edge!(g, e)
    end
    # x
end

"{{xs__, y}} -> {{xs, z}, {z, y}}"
function split_vertex_before!(g, v)
    add_vertex!(g)
    newv = nv(g)
    ins = copy(inneighbors(g, v))
    for n in ins
        rem_edge!(g, n, v)
        add_edge!(g, n, newv)
    end
    add_edge!(g, newv, v)
    g
end

"{{y, xs__}} -> {{y, z}, {z, xs}}"
function split_vertex_after!(g, v)
    add_vertex!(g)
    newv = nv(g)
    ons = copy(outneighbors(g, v))
    for n in ons
        rem_edge!(g, v, n)
        add_edge!(g, newv, n)
    end
    add_edge!(g, v, newv)
    g
end
