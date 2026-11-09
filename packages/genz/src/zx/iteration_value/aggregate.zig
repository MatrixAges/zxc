const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Operand = @import("operand.zig");
const emitting = @import("literals.zig");

pub fn lower(self: *Context, id: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("aggregate_seed.zig").lower(self, id);

    const lowering = self.lowering;
    const expression = lowering.program.expression(id);
    const type_expr = try @import("types.zig").get(self, expression.type_id);
    var scratch = std.heap.ArenaAllocator.init(lowering.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = memory.allocator();

    if (expression.value == .tuple) {
        const bindings = try emitting.Bindings.init(allocator, expression.value.tuple.len);

        for (expression.value.tuple, 0..) |item, index| bindings.set(index, try Operand.lower(lowering, item));

        return emitting.lower(self, .{ .mode = .Tuple, .type_id = expression.type_id, .layout = type_expr, .bindings = bindings });
    }

    const object = expression.value.object;
    const saved = try allocator.alloc(?node.ExpressionId, object.evaluation.len);
    const counts = try allocator.alloc(u64, object.evaluation.len);
    const bindings = try emitting.Bindings.init(allocator, object.evaluation.len);

    for (object.evaluation, saved) |item, *previous| previous.* = self.cache.get(item);

    defer for (object.evaluation, saved) |item, previous| {
        if (previous) |value| self.cache.put(lowering.allocator, item, value) catch unreachable else _ = self.cache.remove(item);
    };

    for (object.evaluation, counts, 0..) |item, *count, index| {
        const value = try Operand.lower(lowering, item);

        bindings.set(index, value);

        count.* = self.reads.get(item) orelse 0;

        try self.cache.put(lowering.allocator, item, value.reference);
    }

    const values = try allocator.alloc(u32, object.fields.len);

    for (0..object.fields.len, values) |index, *value| value.* = @backingInt(try lowering.expr(object.fields.at(index).value));

    return emitting.lower(self, .{
        .mode = .Object,
        .type_id = expression.type_id,
        .layout = type_expr,
        .bindings = bindings,
        .field_indices = object.fields.indices,
        .field_values = values,
        .evaluation = object.evaluation,
        .prior = counts,
    });
}
