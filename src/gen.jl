"
enumeration of graphs

requires the functions:
 `T(n)`, `possible_edges(g::T)`, `add_edge!(g::T, e::Tuple)` and 
 `Graphs.Experimental.has_isomorph(g1::T, g2::T)`
 "
function all_graphs(T, n)
    S = Set{T}()
    g = T(n) # would rather add another method to `possible_edges`
    pes = collect(possible_edges(g))
    eis = powerset(pes)
    for es in eis
        g = T(n)
        for e in es
            add_edge!(g, Tuple(e))
        end
        push_graph!(S, g)
    end
    S
end
"""

enumeration of labeled graphs

requires the functions:
 `T(n)`, `possible_edges(g::T)`, `add_edge!(g::T, e::Tuple)` 
"""
function all_labeled_graphs(T, n)
    g = T(n) # would rather add another method to `possible_edges`
    # would be nice to avoid collecting
    pes = collect(possible_edges(g))
    eis = collect(powerset(pes))
    V = collect(T(n) for _ in 1:length(eis))
    for (i, es) in enumerate(eis)
        for e in es
            add_edge!(V[i], Tuple(e))
        end
    end
    V
end

"https://oeis.org/A006125"
function all_labeled_graphs(n)
    all_labeled_graphs(SimpleGraph, n)
end

n_labeled_graphs(n) = 2^(binomial(n, 2))

"https://oeis.org/A000088"
function all_graphs(n)
    all_graphs(SimpleGraph, n)
end

# S = Vector{SimpleGraph}()
# all_unicyclic_graphs!(S, n; f=push!) # less code duplication but prob slower
# all_unicyclic_graphs!(S, n; f=(i,g)->setindex!(V, g, i))
function all_unicyclic_labeled_graphs(n)
    S = Vector{SimpleGraph}(undef, binomial(binomial(n, 2), n))
    all_unicyclic_labeled_graphs!(S, n)
end

function all_unicyclic_labeled_graphs!(S, n)
    possible_gs = combinations(1:binomial(n, 2), n)
    e_labels = collect(combinations(1:n, 2))
    for (i, p) in enumerate(possible_gs)
        g = SimpleGraph(n)
        for ev in e_labels[p]
            add_edge!(g, ev...)
        end
        S[i] = g
    end
    S
end

"
all graphs where ne(g) == nv(g)
    
https://oeis.org/A001434
"
function all_unicyclic_graphs(n)
    S = Set{SimpleGraph}()
    all_unicyclic_graphs!(S, n)
end

function all_unicyclic_graphs!(S, n)
    possible_gs = combinations(1:binomial(n, 2), n)
    e_labels = collect(combinations(1:n, 2))
    for p in possible_gs
        g = SimpleGraph(n)
        for ev in e_labels[p]
            add_edge!(g, ev...)
        end
        push_graph!(S, g)
    end
    S
end


"
n-node connected unicyclic graphs
https://oeis.org/A001429
"
all_connected_unicyclic(n) = Iterators.filter(is_connected, all_unicyclic_graphs(n))
