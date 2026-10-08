const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("../../iteration_buffer/ownership/graph.zig");
const Self = @This();

symbol: ir.SymbolId,
anchor: ir.ExprId,
path: []const u32,
pub fn resolve(allocator: std.mem.Allocator, program: ir.Program, graph: Graph, argument: ir.ExprId, path: []const u32) std.mem.Allocator.Error!?Self {
    var selected = argument;
    var remaining = path;

    while (remaining.len != 0) {
        if (graph.regions[@backingInt(selected)] != 0 or graph.uses[@backingInt(selected)] != 1) return null;

        switch (program.expression(selected).value) {
            .object => |object| {
                selected = for (0..object.fields.len) |index| {
                    const field = object.fields.at(index);

                    if (field.index == remaining[0]) break field.value;
                } else return null;
            },
            .tuple => |items| {
                if (remaining[0] >= items.len) return null;

                selected = items[remaining[0]];
            },
            else => break,
        }

        remaining = remaining[1..];
    }

    const anchor = selected;
    var full: std.ArrayList(u32) = .empty;

    try full.appendSlice(allocator, remaining);

    while (true) {
        switch (program.expression(selected).value) {
            .field, .tuple_field => |field| {
                try full.insert(allocator, 0, field.index);

                selected = field.target;
            },
            .reference => |symbol| return .{ .symbol = symbol, .anchor = anchor, .path = full.items },
            else => return null,
        }
    }
}
