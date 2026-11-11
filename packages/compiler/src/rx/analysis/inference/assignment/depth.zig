const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");

pub fn solve(graph: *Graph, scratch: std.mem.Allocator) zx.Error![]const u64 {
    if (!@import("rx_options").generated_graph) return @import("depth/seed.zig").solve(graph, scratch);

    const rows = graph.nodes.slice();
    const kinds = rows.items(.kind);
    const arguments = rows.items(.argument);
    const assignments = graph.assignments.slice();

    for (assignments.items(.value), assignments.items(.expected)) |*value, *expected| {
        value.* = graph.root(value.*);
        expected.* = graph.root(expected.*);
    }

    const optional = @import("generated_assignment_optional_edges").executeState(scratch, .{
        .kinds = .{ .items = kinds, .storage = .plain },
        .arguments = .{ .items = arguments, .storage = .plain },
        .parents = graph.forest.state,
        .left = .{ .items = &.{}, .storage = .plain },
        .right = .{ .items = &.{}, .storage = .plain },
        .index = 0,
        .position = 0,
        .count = 0,
        .collecting = false,
    }) catch |err| return allocationFailure(err);

    std.debug.assert(optional.parents.items.ptr == graph.forest.state.items.ptr);

    const solution = @import("generated_assignment_depth").executeValue(scratch, &.{
        .graph = &.{
            .nodes = &.{ .kinds = kinds, .allowed = rows.items(.allowed) },
            .arguments = arguments,
            .types = &.{ .kinds = graph.types.items.kinds.items, .children = graph.types.items.first.items },
        },
        .assignments = &.{ .left = @ptrCast(assignments.items(.value)), .right = @ptrCast(assignments.items(.expected)) },
        .optionals = &.{ .left = optional.left.items, .right = optional.right.items },
    }) catch |err| return allocationFailure(err);

    return switch (solution.issue) {
        .None => solution.depths,
        .Bounds, .OptionalToRequired => failure(graph, optional.right.items, @intCast(solution.position), switch (solution.issue) {
            .Bounds => "incompatible optional input requirements",
            .OptionalToRequired => "optional input cannot satisfy a non-optional requirement",
            else => unreachable,
        }),
        .Recursive => graph.reporter.fail(.type_mismatch, if (assignments.len != 0) assignments.items(.span)[0] else rows.items(.span)[0], "inference would require a recursive optional type"),
    };
}

fn allocationFailure(err: anyerror) zx.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}

fn failure(graph: *Graph, parents: []const u32, position: usize, message: []const u8) zx.Error {
    const assignments = graph.assignments.items(.span);
    const span = if (position < assignments.len) assignments[position] else graph.nodes.items(.span)[parents[position - assignments.len]];

    return graph.reporter.fail(.type_mismatch, span, message);
}
