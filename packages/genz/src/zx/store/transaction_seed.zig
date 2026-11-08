const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn active(self: *const Lower) bool {
    return self.program.stores.count() > 0 and self.program.store_mode == .transaction;
}

pub fn declaration(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (self.program.stores.count() == 0) return;

    const fields = try self.allocator.alloc(node.Field, self.program.stores.count());

    for (self.program.stores.types, 0..) |type_id, index| fields[index] = .{
        .name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{index}),
        .value = try self.builder.expression(.{ .optional_type = try self.typeExpr(@fromBackingInt(type_id)) }),
    };

    try output.append(self.allocator, .{ .constant = .{ .name = self.pending_name, .value = try self.builder.expression(.{ .struct_type = fields }), .exported = true } });
}

pub fn initialize(self: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    if (!active(self)) return;

    const fields = try self.allocator.alloc(node.Field, self.program.stores.count());

    for (fields, 0..) |*item, index| item.* = .{ .name = try std.fmt.allocPrint(self.allocator, "store_{d}", .{index}), .value = try self.builder.expression(.null_value) };

    const pending = node.Constant{ .name = "pending", .type_expr = try self.builder.identifier(self.pending_name), .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier(self.pending_name), .fields = fields } }) };

    try body.append(self.allocator, if (@import("../statements.zig").writes(self.program.body.block())) .{ .variable = pending } else .{ .constant = pending });
}

pub fn commit(self: *Lower) Lower.Error!node.ExpressionId {
    return self.call(try self.field(try self.builder.identifier("context"), "commit"), &.{try self.builder.identifier("pending")}, true);
}
