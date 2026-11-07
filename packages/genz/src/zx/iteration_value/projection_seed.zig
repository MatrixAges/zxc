const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn redirect(self: *Context, type_id: ir.TypeId, source: node.ExpressionId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    const owner = try lowering.field(source, "owner");
    var items = try lowering.field(source, "items");
    var records = self.transfers.iterator();

    while (records.next()) |previous| {
        if (previous.type_id != type_id) continue;

        items = try lowering.builder.expression(.{ .conditional = .{
            .condition = try @import("../intrinsics.zig").binary(lowering, .logical_and, previous.ready, try @import("../intrinsics.zig").binary(lowering, .equal, owner, previous.owner)),
            .yes = previous.value,
            .no = items,
        } });
    }

    return lowering.builder.expression(.{ .object = .{ .type_expr = try @import("types.zig").get(self, type_id), .fields = try lowering.allocator.dupe(node.Field, &.{
        .{ .name = "owner", .value = owner },
        .{ .name = "items", .value = items },
        .{ .name = "owned", .value = try lowering.field(source, "owned") },
    }) } });
}
