const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn lower(self: *Context, id: ir.ExprId) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    const expression = lowering.program.expression(id);
    const type_expr = try @import("types.zig").get(self, expression.type_id);
    var body: std.ArrayList(node.Statement) = .empty;

    if (expression.value == .tuple) {
        const items = try lowering.allocator.alloc(*const node.Expression, expression.value.tuple.len);

        for (expression.value.tuple, items) |item, *value| value.* = try aggregate.bind(lowering, &body, try lowering.expr(item));

        return aggregate.finish(lowering, &body, try lowering.cast(type_expr, try lowering.builder.expression(.{ .tuple = items })));
    }

    const object = expression.value.object;
    const saved = try lowering.allocator.alloc(?*const node.Expression, object.evaluation.len);
    const values = try lowering.allocator.alloc(*const node.Expression, object.evaluation.len);
    const counts = try lowering.allocator.alloc(usize, object.evaluation.len);

    for (object.evaluation, saved) |item, *previous| previous.* = self.cache.get(item);

    defer for (object.evaluation, saved) |item, previous| {
        if (previous) |value| self.cache.put(lowering.allocator, item, value) catch unreachable else _ = self.cache.remove(item);
    };

    for (object.evaluation, values, counts) |item, *value, *count| {
        value.* = try aggregate.bind(lowering, &body, try lowering.expr(item));
        count.* = self.reads.get(item) orelse 0;

        try self.cache.put(lowering.allocator, item, value.*);
    }

    const fields = try lowering.allocator.alloc(node.Field, object.fields.len);
    const definitions = lowering.program.typeOf(expression.type_id).object;

    for (object.fields, fields) |field, *value| value.* = .{ .name = definitions.at(field.index).name, .value = try lowering.expr(field.value) };

    for (object.evaluation, values, counts) |item, value, count| {
        if (count == (self.reads.get(item) orelse 0)) try body.append(lowering.allocator, .{ .discard = value });
    }

    return aggregate.finish(lowering, &body, try lowering.builder.expression(.{ .object = .{ .type_expr = type_expr, .fields = fields } }));
}
