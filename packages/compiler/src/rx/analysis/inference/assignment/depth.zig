const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");

pub fn solve(graph: *Graph, scratch: std.mem.Allocator) zx.Error![]const u64 {
    if (!@import("rx_options").generated_graph) return @import("depth/seed.zig").solve(graph, scratch);

    const generated = @import("generated_assignment_depth");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Fact = std.meta.Elem(@FieldType(Input, "facts"));
    const nodes = graph.nodes.items;
    const depths = try scratch.alloc(u64, nodes.len);
    const facts = try scratch.alloc(Fact, nodes.len);
    var optional_count: usize = 0;

    for (nodes, depths, facts, 0..) |node, *depth, *fact, index| {
        depth.* = 0;
        fact.* = .Exact;

        switch (node.shape) {
            .known => |id| {
                var current = graph.types.get(id);

                while (current == .optional) : (depth.* += 1) current = graph.types.get(current.optional);
            },
            .optional => {
                depth.* = 1;
                fact.* = .Optional;

                const id: Graph.Id = @fromBackingInt(@intCast(index));
                optional_count += @intFromBool(graph.forest.parent(id) == id);
            },
            .unknown => if (node.allowed == null) {
                fact.* = .Open;
            },
            else => {},
        }
    }

    const assignments = graph.assignments.slice();

    for (assignments.items(.value), assignments.items(.expected)) |*value, *expected| {
        value.* = graph.root(value.*);
        expected.* = graph.root(expected.*);
    }

    const left = try scratch.alloc(u32, optional_count);
    const right = try scratch.alloc(u32, optional_count);
    var position: usize = 0;

    for (nodes, 0..) |node, index| {
        if (node.shape != .optional) continue;

        const id: Graph.Id = @fromBackingInt(@intCast(index));

        if (graph.forest.parent(id) != id) continue;

        left[position] = @backingInt(graph.root(node.shape.optional));
        right[position] = @intCast(index);
        position += 1;
    }

    const solution = generated.executeValue(scratch, &.{
        .facts = facts,
        .depths = depths,
        .assignments = &.{ .left = @ptrCast(assignments.items(.value)), .right = @ptrCast(assignments.items(.expected)) },
        .optionals = &.{ .left = left, .right = right },
    }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    return switch (solution.issue) {
        .None => solution.depths,
        .Bounds, .OptionalToRequired => failure(graph, right, @intCast(solution.position), switch (solution.issue) {
            .Bounds => "incompatible optional input requirements",
            .OptionalToRequired => "optional input cannot satisfy a non-optional requirement",
            else => unreachable,
        }),
        .Recursive => graph.reporter.fail(.type_mismatch, if (assignments.len != 0) assignments.items(.span)[0] else nodes[0].span, "inference would require a recursive optional type"),
    };
}

fn failure(graph: *Graph, parents: []const u32, position: usize, message: []const u8) zx.Error {
    const assignments = graph.assignments.items(.span);
    const span = if (position < assignments.len) assignments[position] else graph.nodes.items[parents[position - assignments.len]].span;

    return graph.reporter.fail(.type_mismatch, span, message);
}
