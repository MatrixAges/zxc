const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn view(self: *Context, id: ir.TypeId, owner: node.ExpressionId, items: node.ExpressionId, owned: bool) Lower.Error!node.ExpressionId {
    return self.lowering.builder.expression(.{ .object = .{ .type_expr = try @import("types.zig").get(self, id), .fields = try self.lowering.allocator.dupe(node.Field, &.{
        .{ .name = "owner", .value = owner },
        .{ .name = "items", .value = items },
        .{ .name = "owned", .value = try self.lowering.builder.expression(.{ .boolean = owned }) },
    }) } });
}

pub fn prepare(self: *Context, body: *std.ArrayList(node.Statement), source: node.ExpressionId) Lower.Error!void {
    const lowering = self.lowering;
    const owner = try lowering.field(source, "owner");
    const items = try lowering.field(source, "items");
    const copied = node.Statement{ .expression = try lowering.call(try lowering.field(owner, "appendSlice"), &.{ try lowering.builder.identifier("allocator"), items }, true) };
    const sync = node.Statement{ .assignment = .{ .target = try lowering.field(try lowering.field(owner, "items"), "len"), .value = try lowering.field(items, "len") } };

    try body.append(lowering.allocator, try lowering.builder.branch(try lowering.field(source, "owned"), &.{sync}, &.{copied}));
}
