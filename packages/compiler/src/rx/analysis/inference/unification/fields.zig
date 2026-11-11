const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Plan = @import("plan.zig");
const merge = @import("../unify.zig").merge;

pub fn combine(graph: *Graph, left: []const Graph.Field, right: []const Graph.Field, span: zx.Span, depth: usize) zx.Error![]const Graph.Field {
    if (left.len == 0) return right;
    if (right.len == 0) return left;

    var arena = std.heap.ArenaAllocator.init(graph.scratch);
    var buffer: [std.heap.page_size_min / 16]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const allocator = scratch.allocator();
    const names = if (Plan.enabled) try borrowNames(allocator, left) else &.{};
    var additions: std.ArrayList(Graph.Field) = .empty;

    for (right) |field| {
        const index = if (Plan.enabled) Plan.position(names, field.name) else seedPosition(left, field.name);

        if (index) |position| {
            try merge(graph, left[position].value, field.value, span, depth);
        } else {
            try additions.append(allocator, field);
        }
    }

    if (additions.items.len == 0) return left;

    const result = try graph.allocator.alloc(Graph.Field, left.len + additions.items.len);

    @memcpy(result[0..left.len], left);
    @memcpy(result[left.len..], additions.items);

    return result;
}

pub fn applyKnown(graph: *Graph, inferred: []const Graph.Field, known: zx.ir.TypeFields, span: zx.Span, depth: usize) zx.Error!void {
    const names = known.names[0..known.len];

    for (inferred) |field| {
        const index = Plan.position(names, field.name) orelse return graph.reporter.fail(.type_mismatch, span, "the complete input type does not contain a required field");
        const value = try graph.known(known.at(index).type_id, span);

        try merge(graph, field.value, value, span, depth);
    }
}

fn borrowNames(allocator: std.mem.Allocator, fields: []const Graph.Field) std.mem.Allocator.Error![]const []const u8 {
    const names = try allocator.alloc([]const u8, fields.len);

    for (names, fields) |*name, field| name.* = field.name;

    return names;
}

fn seedPosition(fields: []const Graph.Field, key: []const u8) ?usize {
    for (fields, 0..) |field, index| {
        if (std.mem.eql(u8, field.name, key)) return index;
    }

    return null;
}
