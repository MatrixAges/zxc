const Graph = @import("../types.zig");
const Query = @import("../object_closure.zig").Query;

pub fn prove(graph: *const Graph, value: Graph.Id, query: Query, depth: usize) bool {
    if (graph.shape(value) == .known) return true;
    if (depth >= 256) return false;

    const root = graph.root(value);

    if (query == .spread) {
        for (graph.pending.selections.items(.result)) |selection| {
            if (graph.root(selection) == root) return true;
        }
    }

    for (0..graph.pending.constructions.len) |index| {
        const object = graph.pending.constructions.get(index);

        if (graph.root(object.result) != root) continue;

        const complete = for (0..@as(usize, @intCast(object.count))) |part_index| {
            const part = object.part(graph, part_index);

            if (part.name == null and !prove(graph, part.value, query, depth + 1)) break false;
        } else true;

        if (complete) return true;
    }

    if (query == .selection) {
        for (graph.pending.selections.items(.result), graph.pending.selections.items(.source)) |result, source| {
            if (graph.root(result) == root and prove(graph, source, query, depth + 1)) return true;
        }
    }

    return false;
}
