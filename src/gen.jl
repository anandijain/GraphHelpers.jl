
"https://oeis.org/A006125"
function all_labeled_graphs(n)
    e = binomial(n, 2)
    V = Vector{SimpleGraph}(undef, 2^e)
    b = bool_itr(e)
    el = collect(combinations(1:n, 2))
    for (i, x) in enumerate(b)
        g = SimpleGraph(n)
        V[i] = graph_from_bitstring!(g, x, el)
    end
    V
end

n_labeled_graphs(n) = 2^(binomial(n, 2))

"https://oeis.org/A000088"
function all_graphs(n)
    S = Set{SimpleGraph}()
    e = binomial(n, 2)
    b = bool_itr(e)
    el = collect(combinations(1:n, 2))
    for x in b
        g = SimpleGraph(n)
        # for (idx, v) in enumerate(reverse(x))
        #     v && add_edge!(g, el[idx]...)
        # end
        graph_from_bitstring!(g, x, el)
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
