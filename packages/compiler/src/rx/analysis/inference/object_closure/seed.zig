const Graph = @import("../types.zig");
const Query = @import("../object_closure.zig").Query;

pub fn prove(graph: *const Graph, value: Graph.Id, query: Query, depth: usize) bool {
    if (graph.shape(value) == .known) return true;
    if (depth >= 256) return false;

    const root = graph.root(value);

    if (query == .spread) {
        for (graph.selections.items) |selection| {
            if (graph.root(selection.result) == root) return true;
        }
    }

    for (graph.constructions.items) |object| {
        if (graph.root(object.result) != root) continue;

        const complete = for (object.parts) |part| {
            if (part.name == null and !prove(graph, part.value, query, depth + 1)) break false;
        } else true;

        if (complete) return true;
    }

    if (query == .selection) {
        for (graph.selections.items) |selection| {
            if (graph.root(selection.result) == root and prove(graph, selection.source, query, depth + 1)) return true;
        }
    }

    return false;
}
