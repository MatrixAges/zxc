const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Self = @This();

states: []const bool,
symbols: []const bool,
borrowed: []const bool,
type_id: ir.TypeId,
layout: node.ExpressionId,
seed: node.ExpressionId,
pub fn expression(self: *const Self, id: ir.ExprId) bool {
    return self.states[@backingInt(id)];
}

pub fn symbol(self: *const Self, id: ir.SymbolId) bool {
    return self.symbols[@backingInt(id)];
}

pub fn field(self: *const Self, lowering: *const Lower, target: ir.ExprId, name: []const u8) bool {
    if (!self.expression(target)) return false;

    const fields = lowering.program.typeOf(self.type_id).object;

    for (0..fields.len) |index| {
        if (std.mem.eql(u8, fields.at(index).name, name)) return self.borrowed[index];
    }

    unreachable;
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
