const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
pub const Base = @import("assignment/base.zig");
pub const validate = @import("assignment/validation.zig").validate;
pub const Edge = struct { value: Graph.Id, expected: Graph.Id, span: zx.Span };

pub fn materialize(graph: *Graph, base: Base, scratch: std.mem.Allocator) zx.Error!void {
    const depths = try @import("assignment/depth.zig").solve(graph, scratch);

    if (!@import("rx_options").generated_graph) return seedMaterialize(graph, base, depths);

    const generated = @import("generated_assignment_next_materialization");
    const indexes = graph.indexes.slice();
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var start: usize = 0;

    while (start < depths.len) {
        const nodes = graph.nodes.slice();

        const result = generated.executeState(empty.allocator(), .{
            .nodes = &.{ .kinds = nodes.items(.kind), .allowed = nodes.items(.allowed) },
            .indexes = &.{ .values = @ptrCast(indexes.items(.value)), .resolved = indexes.items(.resolved) },
            .classes = &.{ .groups = base.parents, .representatives = base.representatives },
            .parents = graph.forest.state,
            .next = start,
            .other = null,
            .limit = depths.len,
        }) catch unreachable;

        std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

        const other: Graph.Id = @fromBackingInt(result.other orelse break);
        start = @intCast(result.next);

        const index = start - 1;

        try apply(graph, index, other, depths[index]);
    }
}

fn seedMaterialize(graph: *Graph, base: Base, depths: []const u64) zx.Error!void {
    for (0..depths.len) |index| {
        const id: Graph.Id = @fromBackingInt(@intCast(index));

        if (graph.root(id) != id) continue;

        const node = graph.nodeAt(index);

        if (node.shape != .unknown or node.allowed != null) continue;
        if (@import("index.zig").isResult(graph, id)) continue;

        const value = (try base.representative(graph, id)) orelse continue;

        try apply(graph, index, value, depths[index]);
    }
}

fn apply(graph: *Graph, index: usize, payload: Graph.Id, depth: u64) zx.Error!void {
    const span = graph.nodes.items(.span)[index];
    var value = payload;

    for (0..depth) |_| value = try graph.add(.{ .optional = value }, span);

    try graph.unify(@fromBackingInt(@intCast(index)), value, span);
}
