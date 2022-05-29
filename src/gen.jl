"https://oeis.org/A006125"
function all_labeled_graphs(n)
    _ne = binomial(n, 2)
    V = collect(SimpleGraph(n) for _ in 1:(2^_ne))
    pes = collect(possible_edges(V[1]))
    eis = powerset(1:_ne)
    for (i, es) in enumerate(eis)
        for e in es
            add_edge!(V[i], pes[e])
        end
    end
    V
end

n_labeled_graphs(n) = 2^(binomial(n, 2))

"https://oeis.org/A000088"
function all_graphs(n)
    S = Set{SimpleGraph}()
    _ne = binomial(n, 2)
    pes = collect(Iterators.map(x -> Edge(Tuple(x)), combinations(1:n, 2)))
    eis = powerset(1:_ne)
    for es in eis
        g = SimpleGraph(n)
        for e in es
            add_edge!(g, pes[e])
        end
        push_graph!(S, g)
    end
    S
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
