const std = @import("std");
const zx = @import("zx");
const Graph = @import("../../types.zig");
const Plan = @import("../plan.zig");
const merge = @import("../../unify.zig").merge;

pub fn combine(graph: *Graph, left: Graph.Fields, right: Graph.Fields, span: zx.Span, depth: usize) zx.Error!Graph.Fields {
    if (left.len == 0) return right;
    if (right.len == 0) return left;

    var arena = std.heap.ArenaAllocator.init(graph.scratch);
    var buffer: [std.heap.page_size_min / 16]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const allocator = scratch.allocator();
    const names = left.names();
    const values = left.values();
    var additions: std.ArrayList(Graph.Field) = .empty;

    for (right.names(), right.values()) |name, value| {
        if (Plan.position(names, name)) |position| {
            try merge(graph, values[position], value, span, depth);
        } else {
            try additions.append(allocator, .{ .name = name, .value = value });
        }
    }

    if (additions.items.len == 0) return left;

    const result = try Graph.Fields.init(graph.allocator, left.len + additions.items.len);

    left.copyTo(result);

    for (additions.items, left.len..) |field, index| result.set(index, field.name, field.value);

    return result;
}

pub fn applyKnown(graph: *Graph, inferred: Graph.Fields, known: zx.ir.TypeFields, span: zx.Span, depth: usize) zx.Error!void {
    const names = known.names[0..known.len];

    for (inferred.names(), inferred.values()) |name, field| {
        const index = Plan.position(names, name) orelse return graph.reporter.fail(.type_mismatch, span, "the complete input type does not contain a required field");
        const value = try graph.known(known.at(index).type_id, span);

        try merge(graph, field, value, span, depth);
    }
}
