const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("graph.zig");

pub fn check(allocator: std.mem.Allocator, program: ir.Program, initial: ir.ExprId, path: []const usize) std.mem.Allocator.Error!bool {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const graph = try Graph.create(arena.allocator(), program);
    const region = graph.regions[@backingInt(initial)] orelse return false;
    var current = initial;
    var remaining = path;
    var depth: usize = 0;

    while (depth < program.expressions.count()) : (depth += 1) {
        const index = @backingInt(current);

        if (!graph.exclusive[index] or graph.regions[index] != region) return false;

        switch (program.expression(current).value) {
            .reference => |symbol| {
                if (graph.references[@backingInt(symbol)] != 1) return false;

                current = graph.bindings[@backingInt(symbol)] orelse return false;
            },
            .object => |object| {
                if (remaining.len == 0) return false;

                current = for (0..object.fields.len) |field_index| {
                    const field = object.fields.at(field_index);

                    if (field.index == remaining[0]) break field.value;
                } else return false;

                remaining = remaining[1..];
            },
            .tuple => |items| {
                if (remaining.len == 0 or remaining[0] >= items.len) return false;

                current = items[remaining[0]];
                remaining = remaining[1..];
            },
            .scope => |scope| current = scope.result,
            .transform => |transform| return remaining.len == 0 and (transform.kind == .map or transform.kind == .filter),
            else => return false,
        }
    }

    return false;
}
