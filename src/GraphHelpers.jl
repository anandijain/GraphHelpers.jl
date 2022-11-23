module GraphHelpers
using Graphs, Base.Iterators
using AbstractTrees, Combinatorics
# using GraphMakie, WGLMakie

for f in [cartesian_product, tensor_product]
    fname = Symbol(f)
    @eval Graphs.$fname(xs) = foldl($f, xs)
    @eval Graphs.$fname(xs...) = foldl($f, xs)
end

include("gen.jl")
include("utils.jl")
include("properties.jl")
# include("viz.jl")

export all_graphs, all_labeled_graphs, all_unicyclic_graphs
export push_graph!, unique_graphs
# export grid_plot, array_plot
export possible_edges, complete!, is_complete, is_simple
export add_edges!, rem_edges!

end # module
