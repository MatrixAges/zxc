const zx = @import("zx");
const Graph = @import("types.zig");
pub const Base = @import("assignment/base.zig");
pub const Edge = struct { value: Graph.Id, expected: Graph.Id, span: zx.Span };

pub fn materialize(graph: *Graph, base: Base) zx.Error!void {
    const depths = try @import("assignment/depth.zig").solve(graph);

    defer graph.allocator.free(depths);

    for (0..depths.len) |index| {
        const id: Graph.Id = @enumFromInt(index);

        if (graph.root(id) != id) continue;

        const node = graph.nodes.items[index];

        if (node.shape != .unknown or node.allowed != null) continue;

        var value = (try base.representative(graph, id)) orelse continue;

        for (0..depths[index]) |_| value = try graph.add(.{ .optional = value }, node.span);
        try graph.unify(id, value, node.span);
    }
}

pub fn validate(graph: *Graph) zx.Error!void {
    for (graph.assignments.items) |edge| {
        const actual = try graph.resolve(edge.value);
        var expected = try graph.resolve(edge.expected);

        while (actual != expected) {
            const value = graph.types.get(expected);

            if (value != .optional) return graph.reporter.fail(.type_mismatch, edge.span, "inferred value cannot be passed to the required type");

            expected = value.optional;
        }
    }
}
