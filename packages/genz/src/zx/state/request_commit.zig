const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;
const storage = @import("storage.zig");

pub fn lower(builder: Builder, objects: []const Object) std.mem.Allocator.Error!node.Declaration {
    const allocator = builder.allocator;
    const changes = try builder.identifier("changes");
    var body: std.ArrayList(node.Statement) = .empty;

    if (storage.writable(objects)) {
        const valid = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "Self", "validate" }), &.{changes}) });

        try body.append(allocator, .{ .branch = .{ .condition = try builder.expression(.{ .unary = .{ .operator = .not, .operand = valid } }), .yes = try allocator.dupe(node.Statement, &.{.{ .result = null }}), .no = &.{} } });

        const retained = try builder.path(&.{ "self", "retained" });
        const region = try builder.identifier("region");
        const child_allocator = try builder.path(&.{ "self", "parent", "arena", "child_allocator" });

        const fields = try allocator.dupe(node.Field, &.{
            .{ .name = "arena", .value = try builder.call(try builder.path(&.{ "std", "heap", "ArenaAllocator", "init" }), &.{child_allocator}) },
            .{ .name = "next", .value = try builder.path(&.{ "self", "parent", "retained" }) },
        });

        const create = try allocator.dupe(node.Statement, &.{
            .{ .constant = .{ .name = "region", .value = try builder.expression(.{ .try_value = try builder.call(try builder.field(child_allocator, "create"), &.{try builder.identifier("Region")}) }) } },
            .{ .assignment = .{ .target = try builder.expression(.{ .dereference = region }), .value = try builder.expression(.{ .object = .{ .fields = fields } }) } },
            .{ .assignment = .{ .target = try builder.path(&.{ "self", "parent", "retained" }), .value = region } },
            .{ .assignment = .{ .target = retained, .value = region } },
        });

        try body.append(allocator, .{ .branch = .{ .condition = try builder.expression(.{ .binary = .{ .operator = .equal, .left = retained, .right = try builder.expression(.null_value) } }), .yes = create, .no = &.{} } });
        try body.append(allocator, .{ .expression = try builder.call(try builder.path(&.{ "self", "parent", "apply" }), &.{changes}) });

        if (storage.reclaimable(objects)) for (objects, 0..) |object, index| {
            if (!object.writable) continue;

            const present = try builder.expression(.{ .binary = .{ .operator = .not_equal, .left = try builder.field(changes, try std.fmt.allocPrint(allocator, "store_{d}", .{index})), .right = try builder.expression(.null_value) } });
            const assign = try allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = try builder.field(try builder.path(&.{ "self", "parent" }), try std.fmt.allocPrint(allocator, "owner_{d}", .{index})), .value = retained } }});

            try body.append(allocator, .{ .branch = .{ .condition = present, .yes = assign, .no = &.{} } });
        };
    } else try body.append(allocator, .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "self", "parent", "commit" }), &.{changes}) }) });

    return .{ .function = .{
        .name = "commit",
        .parameters = try allocator.dupe(node.Field, &.{
            .{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Request") }) },
            .{ .name = "changes", .value = try builder.path(&.{ "application", "zx_pending" }) },
        }),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try body.toOwnedSlice(allocator),
        .exported = true,
    } };
}
