const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const object_fields = @import("aggregate/object.zig");
const operands = @import("aggregate/operands.zig");

pub fn object(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "object")) Lower.Error!node.ExpressionId {
    return objectMode(self, id, value, false);
}

pub fn objectValue(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    return objectMode(self, id, self.program.expression(id).value.object, true);
}

fn objectMode(self: *Lower, id: ir.ExprId, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "object"), layout: bool) Lower.Error!node.ExpressionId {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: @TypeOf(self.cache).SnapshotBuffer = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    const saved = try self.cache.snapshot(temporary, value.evaluation);

    defer self.cache.restore(self.allocator, value.evaluation, saved);

    var body: std.ArrayList(node.Statement) = .empty;
    const length = value.evaluation.len;
    const counts = try temporary.alloc(u64, length);
    const references = try temporary.alloc(node.ExpressionId, length);
    const names = if (operands.generated) try temporary.alloc([]const u8, length) else &.{};
    const values = if (operands.generated) try temporary.alloc(u32, length) else &.{};

    for (value.evaluation, 0..) |item, index| {
        const name = try self.fresh("operand");
        const expression = try self.expr(item);

        if (operands.generated) {
            names[index] = name;
            values[index] = @backingInt(expression);
        } else try body.append(self.allocator, .{ .constant = .{ .name = name, .value = expression } });

        counts[index] = self.cache_reads[@backingInt(item)];

        const reference = try self.builder.identifier(name);

        references[index] = reference;

        try self.cache.put(self.allocator, item, reference);
    }

    if (operands.generated) try operands.bind(self, temporary, &body, names, values);

    const observation: operands.Observation = .{
        .evaluation = value.evaluation,
        .prior = counts,
        .references = references,
    };

    const updated = try @import("object_update.zig").lower(self, temporary, id, &body);
    const type_id = self.program.expression(id).type_id;
    const plan = @import("aggregate/layout.zig").plan(self, id, type_id, layout, updated != null);

    if (updated) |result| {
        try operands.retire(self, temporary, &body, observation);

        return finish(self, &body, if (plan.construct) try self.construct(type_id, result) else result);
    }

    const field_names = self.program.typeOf(type_id).object.names;
    const fields = try object_fields.allocate(self, temporary, value.fields.len);

    for (0..value.fields.len) |index| {
        const field = value.fields.at(index);

        if (plan.projection) |projection| if (projection.borrowed[field.index]) {
            const name = field_names[field.index];
            const expression = try self.expr(field.value);
            const borrowed = try @import("aggregate/borrowed.zig").field(self, expression, projection.seed, name);
            fields[index] = object_fields.operand(field_names, field.index, borrowed);

            continue;
        };

        var expression = try self.expr(field.value);

        if (plan.convert_fields) expression = try @import("state_value/conversion.zig").convert(self, &body, self.program.expression(field.value).type_id, try bind(self, &body, expression), .pointer);

        fields[index] = object_fields.operand(field_names, field.index, expression);
    }

    try operands.retire(self, temporary, &body, observation);

    const object_type = if (plan.projection) |projection| projection.layout else try self.layoutExpr(type_id);

    const result = try object_fields.lower(self, temporary, .{
        .type_expr = object_type,
        .names = field_names,
        .indices = value.fields.indices,
        .fields = fields,
    });

    return finish(self, &body, if (plan.construct) try self.construct(type_id, result) else result);
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
            const tuple = try @import("aggregate/literals.zig").tuple(self, expressions);

            break :blk if (layout) try @import("state_value/origin.zig").tuple(self, value.type_id, tuple) else try self.construct(value.type_id, tuple);
        },
        .list => try @import("aggregate/list.zig").literal(self, value.type_id, expressions),
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
