const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;

pub fn lower(builder: Builder, objects: []const Object, enabled: bool) std.mem.Allocator.Error!node.Declaration {
    const allocator = builder.allocator;
    var body: std.ArrayList(node.Statement) = .empty;
    const self = try builder.identifier("self");

    if (!enabled) {
        try body.append(allocator, .{ .discard = self });
    } else {
        try body.append(allocator, .{ .branch = .{ .condition = try builder.field(self, "release_disabled"), .yes = try allocator.dupe(node.Statement, &.{.{ .result = null }}), .no = &.{} } });
        try body.append(allocator, .{ .variable = .{ .name = "link", .value = try builder.expression(.{ .address_of = try builder.field(self, "retained") }) } });

        const region = try builder.identifier("region");
        const link = try builder.identifier("link");
        var owned: ?*const node.Expression = null;

        for (objects, 0..) |object, index| {
            if (!object.writable) continue;

            const condition = try builder.expression(.{ .binary = .{ .operator = .equal, .left = try builder.field(self, try std.fmt.allocPrint(allocator, "owner_{d}", .{index})), .right = region } });
            owned = if (owned) |previous| try builder.expression(.{ .binary = .{ .operator = .logical_or, .left = previous, .right = condition } }) else condition;
        }

        const retained = try allocator.dupe(node.Statement, &.{
            .{ .assignment = .{ .target = link, .value = try builder.expression(.{ .address_of = try builder.field(region, "next") }) } },
            .continue_loop,
        });

        const loop = try allocator.dupe(node.Statement, &.{
            .{ .branch = .{ .condition = owned.?, .yes = retained, .no = &.{} } },
            .{ .assignment = .{ .target = try builder.expression(.{ .dereference = link }), .value = try builder.field(region, "next") } },
            .{ .expression = try builder.call(try builder.path(&.{ "region", "arena", "deinit" }), &.{}) },
            .{ .expression = try builder.call(try builder.path(&.{ "self", "arena", "child_allocator", "destroy" }), &.{region}) },
        });

        try body.append(allocator, .{ .while_loop = .{ .condition = try builder.expression(.{ .dereference = link }), .capture = "region", .body = loop } });
    }

    return .{ .function = .{
        .name = "releaseRetired",
        .parameters = try allocator.dupe(node.Field, &.{.{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Self") }) }}),
        .return_type = try builder.expression(.{ .primitive = .void }),
        .body = try body.toOwnedSlice(allocator),
        .exported = true,
    } };
}
