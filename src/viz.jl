# not included since I don't want the deps
using NetworkLayout

grid_plot(xs) = grid_plot!(Figure(; Resolution=(1000, 1000)), xs)
array_plot(xs) = array_plot!(Figure(; Resolution=(1000, 1000)), xs)

function grid_plot!(fig, xs)
    n = length(xs)
    s = isqrt(n) + 1
    idxs = LinearIndices((1:s, 1:s))
    for i in 1:s
        for j in 1:s
            idx = idxs[j, i]
            @info idx
            if idx > n
                return fig
            end
            graphplot(fig[j, i], xs[idx])
        end
    end
    resize!(fig.scene, 4000, 4000)
    display(fig)
    fig
end

function array_plot!(fig, vecs)
    j = 1
    for v in vecs
        isempty(v) && continue
        for (i, g) in enumerate(v)
            graphplot(fig[j, i], g)
        end
        j += 1
    end
    display(resize!(fig.scene, 4000, 4000))
    # fig
end

"useful for visualizing f: Graph->Graph"
function graph_ab(fig, g1, g2)
    graphplot(fig[1, 1], g1)
    graphplot(fig[1, 2], g2)
end

"
copied from graphmakie docs

takes an expression and returns a SimpleDiGraph
"
function walk_tree(ex; show_call=false)
    g = SimpleDiGraph()
    labels = Any[]
    walk_tree!(g, labels, ex, show_call)
    return (g, labels)
end

function walk_tree!(g, labels, ex, show_call)
    add_vertex!(g)
    top_vertex = vertices(g)[end]

    where_start = 1  # which argument to start with
    typeof(ex) !== Expr && (return top_vertex)
    if !(show_call) && ex.head == :call
        f = ex.args[1]   # the function name
        push!(labels, f)
        where_start = 2   # drop "call" from tree
    else
        push!(labels, ex.head)
    end

    for i in where_start:length(ex.args)
        if isa(ex.args[i], Expr)
            child = walk_tree!(g, labels, ex.args[i], show_call)
            add_edge!(g, top_vertex, child)
        elseif !isa(ex.args[i], LineNumberNode)
            add_vertex!(g)
            n = vertices(g)[end]
            add_edge!(g, top_vertex, n)
            push!(labels, ex.args[i])
        end
    end

    return top_vertex
end

function expr_tree_plot(expr; show_call=false)
    g, labels = walk_tree(expr; show_call)
    nlabels_align = [(:left, :bottom) for v in vertices(g)]
    fig, ax, p = graphplot(g; layout=Buchheim(),
        nlabels=repr.(labels),
        nlabels_distance=5,
        nlabels_align,
        tangents=((0, -1), (0, -1)))
    hidedecorations!(ax)
    hidespines!(ax)
    for v in vertices(g)
        if isempty(inneighbors(g, v)) # root
            nlabels_align[v] = (:center, :bottom)
        elseif isempty(outneighbors(g, v)) #leaf
            nlabels_align[v] = (:center, :top)
        else
            self = p[:node_pos][][v]
            parent = p[:node_pos][][inneighbors(g, v)[1]]
            if self[1] < parent[1] # left branch
                nlabels_align[v] = (:right, :bottom)
            end
        end
    end
    p.nlabels_align = nlabels_align
    fig
end

# code to plot the graph all the time, sometimes nice
# function Graphs.show(io::IO, g::Graphs.SimpleGraph{Int64})
#     display(graphplot(g))
#     dir = is_directed(g) ? "directed" : "undirected"
#     print(io, "{$(nv(g)), $(ne(g))} $dir simple Int64 graph")
# end

# function Graphs.show(io::IO, g::Graphs.SimpleDiGraph{Int64})
#     display(graphplot(g); arrowsize=20)
#     dir = is_directed(g) ? "directed" : "undirected"
#     print(io, "{$(nv(g)), $(ne(g))} $dir simple Int64 graph")
# end
