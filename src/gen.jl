"graph_from_bits(Bool.((0, 1, 0, 1)))"
graph_from_bits(b) = graph_from_bitstring!(SimpleGraph(length(b)), b)
graph_from_bits(b, el) = graph_from_bitstring!(SimpleGraph(length(b)), b, el)
graph_from_bitstring!(g, b) = graph_from_bitstring!(g, b, collect(combinations(1:nv(g), 2)))


function graph_from_bitstring!(g, b, c)
    for (idx, v) in enumerate(b)
        v && add_edge!(g, c[idx]...)
    end
    g
end

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

function all_graphs(n)
    S = Set{SimpleGraph}()
    e = binomial(n, 2)
    b = bool_itr(e)
    # el = collect(combinations(1:n, 2))
    for x in b
        g = SimpleGraph(n)
        # for (idx, v) in enumerate(reverse(x))
        #     v && add_edge!(g, el[idx]...)
        # end
        graph_from_bitstring!(g, x, b)
        push_graph!(S, g)
    end
    S
end

"all graphs where ne(g) == nv(g). i don't know if balanced is the literature term for this property"
function all_balanced_graphs(n)
    S = Set{SimpleGraph}()
    all_balanced_graphs!(S, n)
end

function all_balanced_graphs!(S, n)
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
