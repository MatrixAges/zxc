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
capacity: ?struct { operation: ir.ExprId, source: u32 } = null,
pub fn minimum(self: *const Self, lowering: *Lower, operation: ir.ExprId) Lower.Error!?node.ExpressionId {
    const capacity = self.capacity orelse return null;

    if (capacity.operation != operation) return null;

    const member = lowering.program.typeOf(self.type_id).object.at(capacity.source);
    const source = try lowering.field(self.seed, member.name);
    const items = try @import("../../state_value/list.zig").items(lowering, member.type_id, source);

    return try lowering.field(items, "len");
}

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

pub fn maskBorrowed(self: *Self, lowering: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    const ownership = @import("../../state_value/ownership.zig");
    const fields = lowering.program.typeOf(self.type_id).object;
    var changed = false;

    for (self.borrowed, 0..) |borrowed, index| {
        if (borrowed and ownership.carries(lowering, fields.at(index).type_id)) changed = true;
    }

    if (!changed) return;

    const items = try lowering.allocator.alloc(node.Field, fields.len + 1);

    for (items[0..fields.len], 0..) |*item, index| {
        const member = fields.at(index);
        const value = try lowering.field(self.seed, member.name);
        item.* = .{ .name = member.name, .value = if (self.borrowed[index]) try ownership.erase(lowering, body, member.type_id, value) else value };
    }

    const origin = try @import("../../state_value/origin.zig").name(lowering, self.type_id);

    items[fields.len] = .{ .name = origin, .value = try lowering.field(self.seed, origin) };
    self.seed = try @import("../../aggregate.zig").bind(lowering, body, try lowering.builder.expression(.{ .object = .{ .type_expr = try lowering.layoutExpr(self.type_id), .fields = items } }));
}

pub fn qualify(self: *const Self, lowering: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const ownership = @import("../../state_value/ownership.zig");
    const source = try @import("../../aggregate.zig").bind(lowering, body, value);
    const fields = lowering.program.typeOf(self.type_id).object;
    const items = try lowering.allocator.alloc(node.Field, fields.len + 1);
    var slot: u32 = 0;

    for (items[0..fields.len], 0..) |*item, index| {
        const member = fields.at(index);
        const child = try lowering.field(source, member.name);
        item.* = .{ .name = member.name, .value = if (self.borrowed[index]) child else try ownership.projected(lowering, body, id, member.type_id, child, slot) };
        slot += lowering.slot_counts[@backingInt(member.type_id)];
    }

    const origin = try @import("../../state_value/origin.zig").name(lowering, self.type_id);

    items[fields.len] = .{ .name = origin, .value = try lowering.field(source, origin) };

    return lowering.builder.expression(.{ .object = .{ .type_expr = self.layout, .fields = items } });
}
