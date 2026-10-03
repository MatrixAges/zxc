const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn object(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.Expression, "value"), "object")) Lower.Error!*const node.Expression {
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
        counts[index] = self.cache_reads[@intFromEnum(item)];

        try self.cache.put(self.allocator, item, try self.builder.identifier(name));
    }

    const type_id = self.program.expression(id).type_id;
    const type_fields = self.program.typeOf(type_id).object;
    const fields = try self.allocator.alloc(node.Field, value.fields.len);

    for (value.fields, 0..) |field, index| fields[index] = .{ .name = type_fields[field.index].name, .value = try self.expr(field.value) };

    for (value.evaluation, 0..) |item, index| {
        if (counts[index] == self.cache_reads[@intFromEnum(item)]) try body.append(self.allocator, .{ .discard = try self.builder.identifier(names[index]) });
    }

    return finish(self, &body, try self.construct(type_id, try self.builder.expression(.{ .object = .{ .type_expr = self.layouts[@intFromEnum(type_id)], .fields = fields } })));
}

pub fn sequence(self: *Lower, value: ir.Expression, items: []const ir.ExprId) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const expressions = try self.allocator.alloc(*const node.Expression, items.len);

    for (items, 0..) |item, index| expressions[index] = try bind(self, &body, try self.expr(item));

    const result = switch (value.value) {
        .tuple => try self.construct(value.type_id, try self.builder.expression(.{ .tuple = expressions })),
        .list => blk: {
            const element_type = self.types[@intFromEnum(self.program.typeOf(value.type_id).list)];
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
