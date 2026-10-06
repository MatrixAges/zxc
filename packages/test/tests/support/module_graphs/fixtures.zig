const std = @import("std");
const rx = @import("rx");
pub const Shape = enum { call, import, case, parallel_task };

pub fn location(size: usize, edge: usize) rx.ast.Location {
    return .{ .offset = 100 + edge, .line = edge / size + 1, .column = edge % size + 1 };
}

pub fn sources(allocator: std.mem.Allocator, size: usize, shape: Shape, edges: []const usize) ![]const rx.ModuleSource {
    const result = try allocator.alloc(rx.ModuleSource, size);

    for (result, 0..) |*source, index| {
        const owner = if (shape == .import) size - index - 1 else index;
        var children: std.ArrayList(rx.ast.Node) = .empty;

        for (edges) |edge| {
            if (edge / size != owner) continue;

            const target = edge % size;

            const reference = if (shape == .import)
                try std.fmt.allocPrint(allocator, "./n{d}.rx", .{target})
            else
                try std.fmt.allocPrint(allocator, "./nested/../n{d}", .{target});

            const point = location(size, edge);

            const leaf = if (shape == .import)
                try node(allocator, "Import", &.{.{ "from", reference }}, &.{}, point)
            else
                try node(allocator, "Call", &.{ .{ "module", reference }, .{ "in", "$in" } }, &.{}, point);

            const child = switch (shape) {
                .call, .import => leaf,
                .case => try node(allocator, "Switch", &.{.{ "on", "$in.mode" }}, &.{
                    try node(allocator, "Case", &.{.{ "value", "rare" }}, &.{leaf}, point),
                }, point),
                .parallel_task => try node(allocator, "Parallel", &.{}, &.{
                    try node(allocator, "Task", &.{.{ "name", "nested" }}, &.{leaf}, point),
                }, point),
            };

            try children.append(allocator, child);
        }

        source.* = .{
            .path = try std.fmt.allocPrint(allocator, "graph/./n{d}.rx", .{owner}),
            .node = try node(allocator, "Module", &.{}, children.items, .{ .offset = 0, .line = 1, .column = 1 }),
        };
    }

    return result;
}

fn node(allocator: std.mem.Allocator, name: []const u8, fields: []const [2][]const u8, children: []const rx.ast.Node, point: rx.ast.Location) !rx.ast.Node {
    const attributes = try allocator.alloc(rx.ast.Attribute, fields.len);

    for (attributes, fields) |*attribute, field| {
        attribute.* = .{ .name = field[0], .value = field[1], .location = point, .value_location = point };
    }

    return .{ .name = name, .location = point, .attributes = attributes, .children = try allocator.dupe(rx.ast.Node, children) };
}
