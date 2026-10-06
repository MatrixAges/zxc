const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn object(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.Expression, "value"), "object")) Lower.Error!*const node.Expression {
    return objectMode(self, id, value, false);
}

pub fn objectValue(self: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    return objectMode(self, id, self.program.expression(id).value.object, true);
}

fn objectMode(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.Expression, "value"), "object"), layout: bool) Lower.Error!*const node.Expression {
    const saved = try self.allocator.alloc(?*const node.Expression, value.evaluation.len);

    for (value.evaluation, 0..) |item, index| saved[index] = self.cache.get(item);

    defer {
        for (value.evaluation, 0..) |item, index| {
            if (saved[index]) |previous| self.cache.put(self.allocator, item, previous) catch unreachable else _ = self.cache.remove(item);
        }
    }

    var body: std.ArrayList(node.Statement) = .empty;
    const counts = try self.allocator.alloc(usize, value.evaluation.len);
    const names = try self.allocator.alloc([]const u8, value.evaluation.len);

    for (value.evaluation, 0..) |item, index| {
        const name = try self.fresh("operand");
        const expression = try self.expr(item);

        try body.append(self.allocator, .{ .constant = .{ .name = name, .value = expression } });

        names[index] = name;
        counts[index] = self.cache_reads[@backingInt(item)];

        try self.cache.put(self.allocator, item, try self.builder.identifier(name));
    }

    const type_id = self.program.expression(id).type_id;
    const type_fields = self.program.typeOf(type_id).object;
    const fields = try self.allocator.alloc(node.Field, value.fields.len);

    for (value.fields, 0..) |field, index| fields[index] = .{ .name = type_fields.at(field.index).name, .value = try self.expr(field.value) };

    for (value.evaluation, 0..) |item, index| {
        if (counts[index] == self.cache_reads[@backingInt(item)]) try body.append(self.allocator, .{ .discard = try self.builder.identifier(names[index]) });
    }

    const result = try self.builder.expression(.{ .object = .{ .type_expr = self.layouts[@backingInt(type_id)], .fields = fields } });

    return finish(self, &body, if (layout) result else try self.construct(type_id, result));
}

pub fn sequence(self: *Lower, value: ir.Expression, items: []const ir.ExprId) Lower.Error!*const node.Expression {
    return sequenceMode(self, value, items, false);
}

pub fn tupleValue(self: *Lower, value: ir.Expression, items: []const ir.ExprId) Lower.Error!*const node.Expression {
    return sequenceMode(self, value, items, true);
}

fn sequenceMode(self: *Lower, value: ir.Expression, items: []const ir.ExprId, layout: bool) Lower.Error!*const node.Expression {
    if (value.value == .list) if (try @import("static_list.zig").lower(self, value, items)) |literal| return literal;

    var body: std.ArrayList(node.Statement) = .empty;
    const expressions = try self.allocator.alloc(*const node.Expression, items.len);

    for (items, 0..) |item, index| expressions[index] = try bind(self, &body, try self.expr(item));

    const result = switch (value.value) {
        .tuple => blk: {
            const tuple = try self.builder.expression(.{ .tuple = expressions });

            break :blk if (layout) try @import("state_value/origin.zig").tuple(self, value.type_id, tuple) else try self.construct(value.type_id, tuple);
        },
        .list => blk: {
            const element_type = self.types[@backingInt(self.program.typeOf(value.type_id).list)];
            const array = try self.builder.expression(.{ .array = .{ .element_type = element_type, .values = expressions } });

            break :blk try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element_type, try self.builder.expression(.{ .address_of = array }) }, true);
        },
        .template => try @import("templates.zig").lower(self, items, expressions),
        else => unreachable,
    };

    return finish(self, &body, result);
}

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), expression: *const node.Expression) Lower.Error!*const node.Expression {
    const name = try self.fresh("operand");

    try body.append(self.allocator, .{ .constant = .{ .name = name, .value = expression } });

    return self.builder.identifier(name);
}

pub fn finish(self: *Lower, body: *std.ArrayList(node.Statement), result: *const node.Expression) Lower.Error!*const node.Expression {
    const label = try self.fresh("block");

    try body.append(self.allocator, .{ .break_value = .{ .label = label, .value = result } });

    return self.builder.expression(.{ .block = .{ .label = label, .statements = try body.toOwnedSlice(self.allocator) } });
}
