const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), writable: bool) std.mem.Allocator.Error!void {
    const allocator = builder.allocator;
    var body: std.ArrayList(node.Statement) = .empty;

    if (writable) {
        const fields = try allocator.dupe(node.Field, &.{
            .{ .name = "arena", .value = try builder.path(&.{ "std", "heap", "ArenaAllocator" }) },
            .{ .name = "next", .value = try builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.identifier("Region") }) }) },
        });

        try declarations.append(allocator, .{ .constant = .{ .name = "Region", .value = try builder.expression(.{ .struct_type = fields }) } });
        try body.append(allocator, .{ .variable = .{ .name = "region", .value = try builder.path(&.{ "self", "retained" }) } });

        try body.append(allocator, .{ .while_loop = .{ .condition = try builder.identifier("region"), .capture = "current", .body = try allocator.dupe(node.Statement, &.{
            .{ .constant = .{ .name = "next", .value = try builder.path(&.{ "current", "next" }) } },
            .{ .expression = try builder.call(try builder.path(&.{ "current", "arena", "deinit" }), &.{}) },
            .{ .expression = try builder.call(try builder.path(&.{ "self", "arena", "child_allocator", "destroy" }), &.{try builder.identifier("current")}) },
            .{ .assignment = .{ .target = try builder.identifier("region"), .value = try builder.identifier("next") } },
        }) } });

        try body.append(allocator, .{ .assignment = .{ .target = try builder.path(&.{ "self", "retained" }), .value = try builder.expression(.null_value) } });
    } else try body.append(allocator, .{ .discard = try builder.identifier("self") });

    try declarations.append(allocator, .{ .function = .{
        .name = "deinit",
        .parameters = try allocator.dupe(node.Field, &.{.{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Self") }) }}),
        .return_type = try builder.expression(.{ .primitive = .void }),
        .body = try body.toOwnedSlice(allocator),
        .exported = true,
    } });
}
