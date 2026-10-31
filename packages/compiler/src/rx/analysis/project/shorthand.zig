const std = @import("std");
const rx = @import("rx");
const target = @import("../call/target.zig");

pub fn call(allocator: std.mem.Allocator, node: rx.ast.Node, has_input: bool) std.mem.Allocator.Error!rx.ast.Node {
    const attributes = try allocator.alloc(rx.ast.Attribute, if (has_input) 2 else 1);

    attributes[0] = target.attribute(node, "fn");

    if (has_input) attributes[1] = .{
        .name = "in",
        .value = "$in",
        .kind = .expression,
        .location = attributes[0].location,
        .value_location = attributes[0].value_location,
    };

    return .{ .name = "Call", .location = node.location, .attributes = attributes };
}

pub fn result(allocator: std.mem.Allocator, node: rx.ast.Node) std.mem.Allocator.Error!rx.ast.Attribute {
    const binding = @import("../result_name.zig").resolve(node);

    return .{
        .name = "value",
        .value = try std.fmt.allocPrint(allocator, "$ctx.{s}", .{binding.name}),
        .kind = .expression,
        .location = binding.attribute.location,
        .value_location = binding.attribute.value_location,
    };
}
