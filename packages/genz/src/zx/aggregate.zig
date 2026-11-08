const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn object(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "object")) Lower.Error!node.ExpressionId {
    return objectMode(self, id, value, false);
}

pub fn objectValue(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    return objectMode(self, id, self.program.expression(id).value.object, true);
}

fn objectMode(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "object"), layout: bool) Lower.Error!node.ExpressionId {
    if (try @import("object_update.zig").lower(self, id)) |updated| return updated;

    const saved = try self.allocator.alloc(?node.ExpressionId, value.evaluation.len);

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
    const context = if (self.loop_fields) |selected| (if (selected.expression(id)) selected else null) else null;

    for (0..value.fields.len) |index| {
        const field = value.fields.at(index);

        if (context) |selected| if (selected.borrowed[field.index]) {
            var evaluation: std.ArrayList(node.Statement) = .empty;

            try evaluation.append(self.allocator, .{ .discard = try self.expr(field.value) });

            const pointer = try self.builder.expression(.{ .address_of = try self.field(selected.seed, type_fields.at(field.index).name) });
            fields[index] = .{ .name = type_fields.at(field.index).name, .value = try finish(self, &evaluation, pointer) };

            continue;
        };

        var expression = try self.expr(field.value);

        if (self.state_active and !self.state_plan.selected[@backingInt(type_id)]) expression = try @import("state_value/conversion.zig").convert(self, &body, self.program.expression(field.value).type_id, try bind(self, &body, expression), .pointer);

        fields[index] = .{ .name = type_fields.at(field.index).name, .value = expression };
    }

    for (value.evaluation, 0..) |item, index| {
        if (counts[index] == self.cache_reads[@backingInt(item)]) try body.append(self.allocator, .{ .discard = try self.builder.identifier(names[index]) });
    }

    const result = try self.builder.expression(.{ .object = .{ .type_expr = if (context) |selected| selected.layout else try self.layoutExpr(type_id), .fields = fields } });

    return finish(self, &body, if (layout or context != null) result else try self.construct(type_id, result));
}

pub fn sequence(self: *Lower, value: ir.ExpressionRow, items: []const ir.ExprId) Lower.Error!node.ExpressionId {
    return sequenceMode(self, value, items, false);
}

pub fn tupleValue(self: *Lower, value: ir.ExpressionRow, items: []const ir.ExprId) Lower.Error!node.ExpressionId {
    return sequenceMode(self, value, items, true);
}

fn sequenceMode(self: *Lower, value: ir.ExpressionRow, items: []const ir.ExprId, layout: bool) Lower.Error!node.ExpressionId {
    if (value.value == .list) if (try @import("static_list.zig").lower(self, value, items)) |literal| return @import("state_value/list.zig").wrap(self, value.type_id, literal, false);

    var body: std.ArrayList(node.Statement) = .empty;
    const expressions = try self.allocator.alloc(node.ExpressionId, items.len);

    for (items, 0..) |item, index| {
        var expression = try bind(self, &body, try self.expr(item));

        if (value.value == .list) {
            expression = try @import("state_value/elements.zig").write(self, &body, value.type_id, expression);
        } else if (self.state_active and value.value == .tuple and !self.state_plan.selected[@backingInt(value.type_id)]) {
            expression = try @import("state_value/conversion.zig").convert(self, &body, self.program.expression(item).type_id, expression, .pointer);
        }

        expressions[index] = expression;
    }

    const result = switch (value.value) {
        .tuple => blk: {
            const tuple = try self.builder.expression(.{ .tuple = expressions });

            break :blk if (layout) try @import("state_value/origin.zig").tuple(self, value.type_id, tuple) else try self.construct(value.type_id, tuple);
        },
        .list => blk: {
            const element_type = try @import("state_value/elements.zig").typeExpr(self, value.type_id);
            const array = try self.builder.expression(.{ .array = .{ .element_type = element_type, .values = expressions } });
            const address = try self.builder.expression(.{ .address_of = array });

            break :blk if (items.len == 0) address else try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element_type, address }, true);
        },
        .template => try @import("templates.zig").lower(self, items, expressions),
        else => unreachable,
    };

    return finish(self, &body, if (value.value == .list) try @import("state_value/list.zig").wrap(self, value.type_id, result, false) else result);
}

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), expression: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("aggregate/binding_seed.zig").bind(self, body, expression);

    return @import("aggregate/binding.zig").bind(self, body, expression);
}

pub fn finish(self: *Lower, body: *std.ArrayList(node.Statement), result: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("aggregate/binding_seed.zig").finish(self, body, result);

    return @import("aggregate/binding.zig").finish(self, body, result);
}
