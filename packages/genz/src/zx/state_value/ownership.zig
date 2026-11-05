const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn eligible(self: *const Lower, id: ir.ExprId, slot: u32) bool {
    const index: usize = @backingInt(id);

    if (index + 1 >= self.plan.slot_first.len) return false;

    const first = self.plan.slot_first[index];
    const end = self.plan.slot_first[index + 1];
    const base = self.plan.slot_first[0];

    if (slot >= end - first) return false;

    const bit = first - base + slot;
    const width = @bitSizeOf(u64);
    const word = bit / width;

    return word < self.plan.transfers.len and self.plan.transfers[word] & (@as(u64, 1) << @intCast(bit % width)) != 0;
}

pub fn clip(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const type_id = self.program.expression(id).type_id;

    return projected(self, body, id, type_id, value, 0);
}

pub fn carries(self: *const Lower, type_id: ir.TypeId) bool {
    return needed(self, @fromBackingInt(std.math.maxInt(u32)), type_id, 0);
}

pub fn erase(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return projected(self, body, @fromBackingInt(std.math.maxInt(u32)), type_id, value, 0);
}

pub fn projected(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!node.ExpressionId {
    if (!needed(self, id, type_id, slot)) return value;

    const name = try self.fresh("qualified");
    const source = try self.builder.identifier(name);

    try body.append(self.allocator, .{ .variable = .{
        .name = name,
        .type_expr = try @import("../types.zig").get(self, self.state_types, type_id),
        .value = value,
    } });

    try clear(self, body, id, type_id, source, slot);

    return source;
}

fn count(self: *const Lower, id: ir.TypeId) u32 {
    return if (@backingInt(id) < self.slot_counts.len) self.slot_counts[@backingInt(id)] else 0;
}

fn needed(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) bool {
    const target = self.program.typeOf(type_id);

    if (target == .optional) return needed(self, id, target.optional, slot);
    if (!self.state_plan.selected[@backingInt(type_id)]) return false;

    var offset = slot;

    switch (target) {
        .list => return !eligible(self, id, slot),
        .object => |fields| for (0..fields.len) |index| {
            const child = fields.at(index).type_id;

            if (needed(self, id, child, offset)) return true;

            offset += count(self, child);
        },
        .tuple => |children| for (0..children.len) |index| {
            const child = children.at(index);

            if (needed(self, id, child, offset)) return true;

            offset += count(self, child);
        },
        else => {},
    }

    return false;
}

fn clear(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!void {
    if (!needed(self, id, type_id, slot)) return;

    const target = self.program.typeOf(type_id);

    if (self.state_plan.referenced(type_id)) {
        const copied = try @import("reference.zig").copy(self, body, type_id, value);

        try clearFields(self, body, id, target.object, copied, slot);

        try body.append(self.allocator, .{ .assignment = .{
            .target = value,
            .value = try self.builder.expression(.{ .address_of = copied }),
        } });

        return;
    }

    switch (target) {
        .optional => |child| {
            var present: std.ArrayList(node.Statement) = .empty;
            const payload = try self.builder.expression(.{ .optional_unwrap = value });

            try clear(self, &present, id, child, payload, slot);

            try body.append(self.allocator, try self.builder.branch(
                try @import("../intrinsics.zig").binary(self, .not_equal, value, try self.builder.expression(.null_value)),
                present.items,
                &.{},
            ));
        },
        .list => try body.append(self.allocator, .{ .assignment = .{
            .target = try self.field(value, "storage"),
            .value = try @import("list.zig").weakened(self, value),
        } }),
        .object => |items| try clearFields(self, body, id, items, value, slot),
        .tuple => |children| {
            var offset = slot;

            for (0..children.len) |index| {
                const child = children.at(index);
                const source = try self.field(value, try std.fmt.allocPrint(self.allocator, "{d}", .{index}));

                try clear(self, body, id, child, source, offset);

                offset += count(self, child);
            }
        },
        else => unreachable,
    }
}

fn clearFields(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, items: anytype, value: node.ExpressionId, slot: u32) Lower.Error!void {
    var offset = slot;

    for (0..items.len) |index| {
        const field = items.at(index);

        try clear(self, body, id, field.type_id, try self.field(value, field.name), offset);

        offset += count(self, field.type_id);
    }
}
