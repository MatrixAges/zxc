const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn store(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const slot = try storage(self, id);

    try body.append(self.allocator, .{ .assignment = .{ .target = slot, .value = value } });

    return self.builder.expression(.{ .address_of = slot });
}

pub fn copy(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const slot = try storage(self, id);

    try body.append(self.allocator, .{ .assignment = .{
        .target = slot,
        .value = try self.builder.expression(.{ .dereference = value }),
    } });

    return slot;
}

fn storage(self: *Lower, id: ir.TypeId) Lower.Error!node.ExpressionId {
    const name = try self.fresh("state_reference");

    try self.reference_storage.append(self.allocator, .{ .variable = .{
        .name = name,
        .type_expr = try @import("../types.zig").get(self, self.state_layouts, id),
        .value = try self.builder.expression(.undefined_value),
    } });

    return self.builder.identifier(name);
}
