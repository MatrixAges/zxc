const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
pub const Base = @import("assignment/base.zig");
pub const Edge = struct { value: Graph.Id, expected: Graph.Id, span: zx.Span };

pub fn materialize(graph: *Graph, base: Base, scratch: std.mem.Allocator) zx.Error!void {
    const depths = try @import("assignment/depth.zig").solve(graph, scratch);

    for (0..depths.len) |index| {
        const id: Graph.Id = @fromBackingInt(@intCast(index));

        if (graph.root(id) != id) continue;

        const node = graph.nodeAt(index);

        if (node.shape != .unknown or node.allowed != null) continue;
        if (@import("index.zig").isResult(graph, id)) continue;

        var value = (try base.representative(graph, id)) orelse continue;
        const depth: usize = @intCast(depths[index]);

        for (0..depth) |_| value = try graph.add(.{ .optional = value }, node.span);
        try graph.unify(id, value, node.span);
    }
}

pub fn validate(graph: *Graph) zx.Error!void {
    const edges = graph.assignments.slice();

    for (edges.items(.value), edges.items(.expected), edges.items(.span)) |source, target, span| {
        const actual = try graph.resolve(source);
        const expected = try graph.resolve(target);

        if (!@import("optional.zig").accepts(graph.types.items.view(), actual, expected)) return graph.reporter.fail(.type_mismatch, span, "inferred value cannot be passed to the required type");
    }
}
