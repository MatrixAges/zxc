const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const emitting = @import("mutation_emission.zig");

pub fn operation(self: *Context, id: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("mutation_seed.zig").operation(self, id);

    const lowering = self.lowering;
    const row = lowering.program.expression(id);
    const operation_value = row.value.list_operation;
    const list_type = lowering.program.expression(operation_value.target).type_id;
    const target = try operand(lowering, operation_value.target);

    const mode: emitting.Mode = switch (operation_value.kind) {
        .push => .Push,
        .pop => .Pop,
        else => unreachable,
    };

    const value = if (mode == .Push) try operand(lowering, operation_value.arguments[0]) else emitting.Operand.empty;
    const list_layout = try @import("types.zig").get(self, list_type);
    const result_layout = try @import("types.zig").get(self, row.type_id);

    return emitting.lower(self, .{
        .mode = mode,
        .target = target,
        .index = .empty,
        .value = value,
        .list_layout = list_layout,
        .result_layout = result_layout,
    });
}

pub fn update(self: *Context, id: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("mutation_seed.zig").update(self, id);

    const lowering = self.lowering;
    const write = lowering.program.expression(id).value.list_update;
    const list_type = lowering.program.expression(write.target).type_id;
    const target = try operand(lowering, write.target);
    const index = try operand(lowering, write.index);
    const value = try operand(lowering, write.value);
    const layout = try @import("types.zig").get(self, list_type);

    return emitting.lower(self, .{
        .mode = .Update,
        .target = target,
        .index = index,
        .value = value,
        .list_layout = layout,
        .result_layout = @fromBackingInt(0),
    });
}

fn operand(lowering: *Lower, id: ir.ExprId) Lower.Error!emitting.Operand {
    var storage: [1]node.Statement = undefined;
    var body = std.ArrayList(node.Statement).initBuffer(&storage);
    const reference = try aggregate.bind(lowering, &body, try lowering.expr(id));
    const binding = body.items[0].constant;

    std.debug.assert(body.items.len == 1);

    return .{ .name = binding.name, .value = binding.value, .reference = reference };
}
