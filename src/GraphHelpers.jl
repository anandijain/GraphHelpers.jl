module GraphHelpers
using Graphs, Base.Iterators
using AbstractTrees, Combinatorics
using Boolin
# using GraphMakie, WGLMakie

for f in [cartesian_product, tensor_product]
    fname = Symbol(f)
    @eval Graphs.$fname(xs) = foldl($f, xs)
end

include("gen.jl")
include("utils.jl")
# include("viz.jl")

export all_graphs, all_labeled_graphs, all_unicyclic_graphs
export push_graph!, unique_graphs
# export grid_plot, array_plot

end # module
