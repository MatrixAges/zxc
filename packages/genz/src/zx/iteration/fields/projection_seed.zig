const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Self = @import("root.zig");

pub fn minimum(self: *const Self, lowering: *Lower, operation: ir.ExprId) Lower.Error!?node.ExpressionId {
    const capacity = self.capacity orelse return null;

    if (capacity.operation != operation) return null;

    const member = lowering.program.typeOf(self.type_id).object.at(capacity.source);
    const source = try lowering.field(self.seed, member.name);
    const items = try @import("../../state_value/list.zig").items(lowering, member.type_id, source);

    return try lowering.field(items, "len");
}

pub fn initial(self: *const Self, lowering: *Lower) Lower.Error!node.ExpressionId {
    const fields = lowering.program.typeOf(self.type_id).object;
    const items = try lowering.allocator.alloc(node.Field, fields.len + 1);

    for (items[0..fields.len], 0..) |*item, index| {
        const name = fields.at(index).name;
        const value = try lowering.field(self.seed, name);
        item.* = .{ .name = name, .value = if (self.borrowed[index]) try lowering.builder.expression(.{ .address_of = value }) else value };
    }

    const origin = try @import("../../state_value/origin.zig").name(lowering, self.type_id);

    items[fields.len] = .{ .name = origin, .value = try lowering.field(self.seed, origin) };

    return lowering.builder.expression(.{ .object = .{ .type_expr = self.layout, .fields = items } });
}

pub fn restore(self: *const Self, lowering: *Lower, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const fields = lowering.program.typeOf(self.type_id).object;
    const items = try lowering.allocator.alloc(node.Field, fields.len + 1);

    for (items[0..fields.len], 0..) |*item, index| {
        const name = fields.at(index).name;
        const value = try lowering.field(state, name);
        item.* = .{ .name = name, .value = if (self.borrowed[index]) try lowering.builder.expression(.{ .dereference = value }) else value };
    }

    const origin = try @import("../../state_value/origin.zig").name(lowering, self.type_id);

    items[fields.len] = .{ .name = origin, .value = try lowering.field(state, origin) };

    return lowering.builder.expression(.{ .object = .{ .type_expr = try lowering.layoutExpr(self.type_id), .fields = items } });
}
