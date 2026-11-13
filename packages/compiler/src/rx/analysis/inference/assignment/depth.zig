const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");

pub fn solve(graph: *Graph, scratch: std.mem.Allocator) zx.Error![]const u64 {
    if (!@import("rx_options").generated_graph) return @import("depth/seed.zig").solve(graph, scratch);

    const rows = graph.nodes.slice();
    const assignments = graph.assignments.slice();
    const left: []u32 = @ptrCast(assignments.items(.value));
    const right: []u32 = @ptrCast(assignments.items(.expected));
    const parents: []u32 = @constCast(graph.forest.state.items);

    const solution = @import("generated_assignment_depth").executeValue(scratch, &.{
        .graph = &.{
            .nodes = &.{ .kinds = rows.items(.kind), .allowed = rows.items(.allowed) },
            .arguments = rows.items(.argument),
            .types = &.{ .kinds = graph.types.items.kinds.items, .children = graph.types.items.first.items },
        },
        .assignments = &.{ .left = left, .right = right },
        .write = &.{ .left = @ptrCast(&left), .right = @ptrCast(&right), .count = left.len },
        .parents = @ptrCast(&parents),
    }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (solution.issue == .None) return solution.depths;

    const spans = assignments.items(.span);

    const span = if (solution.node) |node|
        rows.items(.span)[node]

    else if (spans.len == 0)
        rows.items(.span)[0]
    else
        spans[solution.position];

    return graph.reporter.fail(.type_mismatch, span, switch (solution.issue) {
        .Bounds => "incompatible optional input requirements",
        .OptionalToRequired => "optional input cannot satisfy a non-optional requirement",
        .Recursive => "inference would require a recursive optional type",
        .None => unreachable,
    });
}
