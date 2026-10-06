const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const Object = @import("../state.zig").Object;
const storage = @import("storage.zig");

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const Object) std.mem.Allocator.Error!void {
    const allocator = builder.allocator;
    const self = try builder.identifier("self");
    const changes = try builder.identifier("changes");
    const self_parameter = node.Field{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Self") }) };
    const changes_parameter = node.Field{ .name = "changes", .value = try builder.path(&.{ "application", "zx_pending" }) };
    const unit = try builder.expression(.{ .primitive = .void });
    const fallible = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = unit } });
    var initialize: std.ArrayList(node.Statement) = .empty;
    var apply: std.ArrayList(node.Statement) = .empty;
    var validate: std.ArrayList(node.Statement) = .empty;
    var commit: std.ArrayList(node.Statement) = .empty;

    if (objects.len == 0) {
        try initialize.append(allocator, .{ .discard = self });
        try validate.append(allocator, .{ .discard = changes });
    }

    const count = node.Constant{ .name = "count", .type_expr = try builder.expression(.{ .primitive = .usize }), .value = try builder.integer(0) };

    try validate.append(allocator, if (objects.len == 0) .{ .constant = count } else .{ .variable = count });

    if (!storage.writable(objects)) {
        try apply.appendSlice(allocator, &.{ .{ .discard = self }, .{ .discard = changes } });
    }

    for (objects, 0..) |object, index| {
        const value_name = try std.fmt.allocPrint(allocator, "value_{d}", .{index});
        const store_name = try std.fmt.allocPrint(allocator, "store_{d}", .{index});
        const module = try builder.identifier(try std.fmt.allocPrint(allocator, "initial_{d}", .{index}));
        const target = try builder.field(self, value_name);
        const source = try builder.field(changes, store_name);
        const execute = try builder.call(try builder.field(module, "execute"), &.{ try builder.field(self, "arena"), try builder.expression(.unit) });

        try initialize.appendSlice(allocator, &.{
            .{ .assignment = .{ .target = target, .value = try builder.expression(.{ .try_value = execute }) } },
            .{ .assignment = .{ .target = try builder.field(self, store_name), .value = try builder.expression(.{ .address_of = target }) } },
        });

        const present = try builder.expression(.{ .binary = .{ .operator = .not_equal, .left = source, .right = try builder.expression(.null_value) } });
        const increment = try builder.expression(.{ .binary = .{ .operator = .add, .left = try builder.identifier("count"), .right = try builder.integer(1) } });

        try validate.append(allocator, .{ .branch = .{ .condition = present, .yes = try allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = try builder.identifier("count"), .value = increment } }}), .no = &.{} } });
        if (object.writable) try apply.append(allocator, .{ .branch = .{ .condition = source, .capture = "value", .yes = try allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = target, .value = try builder.identifier("value") } }}), .no = &.{} } });
    }

    const multiple = try builder.expression(.{ .binary = .{ .operator = .greater, .left = try builder.identifier("count"), .right = try builder.integer(1) } });

    try validate.append(allocator, .{ .branch = .{ .condition = multiple, .yes = try allocator.dupe(node.Statement, &.{.{ .result = try builder.expression(.{ .error_value = "MultipleStoreObjects" }) }}), .no = &.{} } });

    for (objects, 0..) |object, index| {
        if (object.writable) continue;

        const present = try builder.expression(.{ .binary = .{ .operator = .not_equal, .left = try builder.field(changes, try std.fmt.allocPrint(allocator, "store_{d}", .{index})), .right = try builder.expression(.null_value) } });

        try validate.append(allocator, .{ .branch = .{ .condition = present, .yes = try allocator.dupe(node.Statement, &.{.{ .result = try builder.expression(.{ .error_value = "StoreNotWritable" }) }}), .no = &.{} } });
    }

    try validate.append(allocator, .{ .result = try builder.expression(.{ .binary = .{ .operator = .not_equal, .left = try builder.identifier("count"), .right = try builder.integer(0) } }) });

    const valid = try builder.expression(.{ .try_value = try builder.call(try builder.identifier("validate"), &.{changes}) });

    try commit.append(allocator, .{ .branch = .{ .condition = try builder.expression(.{ .unary = .{ .operator = .not, .operand = valid } }), .yes = try allocator.dupe(node.Statement, &.{.{ .result = null }}), .no = &.{} } });
    if (storage.reclaimable(objects)) try commit.append(allocator, .{ .assignment = .{ .target = try builder.field(self, "release_disabled"), .value = try builder.expression(.{ .boolean = true }) } });
    try commit.append(allocator, .{ .expression = try builder.call(try builder.field(self, "apply"), &.{changes}) });

    const self_parameters = try allocator.dupe(node.Field, &.{self_parameter});
    const update_parameters = try allocator.dupe(node.Field, &.{ self_parameter, changes_parameter });

    try declarations.appendSlice(allocator, &.{
        .{ .function = .{ .name = "initialize", .parameters = self_parameters, .return_type = fallible, .body = try initialize.toOwnedSlice(allocator), .exported = true } },
        .{ .function = .{ .name = "commit", .parameters = update_parameters, .return_type = fallible, .body = try commit.toOwnedSlice(allocator), .exported = true } },
        .{ .function = .{ .name = "validate", .parameters = try allocator.dupe(node.Field, &.{changes_parameter}), .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .bool }) } }), .body = try validate.toOwnedSlice(allocator) } },
        .{ .function = .{ .name = "apply", .parameters = update_parameters, .return_type = unit, .body = try apply.toOwnedSlice(allocator) } },
    });
}
