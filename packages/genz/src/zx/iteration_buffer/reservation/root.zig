const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const shape = @import("shape.zig");

pub fn limit(lowering: *Lower, iteration: ir.Iteration, initial: *const node.Expression, output: []const usize, updates: []const ir.ExprId) Lower.Error!?*const node.Expression {
    const program = lowering.program;

    if (iteration.postcondition or updates.len != 1) return null;

    const update = program.expression(updates[0]).value;

    if (update != .list_operation or update.list_operation.kind != .push or update.list_operation.arguments.len != 1) return null;

    const seed = shape.select(program, iteration.initial, output) orelse return null;
    const seed_value = program.expression(seed).value;

    if (seed_value != .list or seed_value.list.len != 0) return null;

    const condition = program.expression(iteration.condition).value;

    if (condition != .binary or condition.binary.operator != .less) return null;

    const comparison = condition.binary;
    const counter_type = program.typeOf(program.expression(comparison.left).type_id);

    if (counter_type != .scalar or counter_type.scalar != .u64) return null;

    const bound = program.expression(comparison.right).value;

    if (bound != .length or program.typeOf(program.expression(bound.length).type_id) != .list) return null;

    const counter = try shape.path(lowering.allocator, program, comparison.left, iteration.condition_parameter) orelse return null;
    const source = try shape.path(lowering.allocator, program, bound.length, iteration.condition_parameter) orelse return null;
    const start = shape.select(program, iteration.initial, counter) orelse return null;

    if (!shape.integer(program, start, 0)) return null;

    const next_source = shape.select(program, iteration.body, source) orelse return null;

    if (!shape.matches(program, next_source, iteration.parameter, source)) return null;

    const next_counter = shape.select(program, iteration.body, counter) orelse return null;
    const increment = program.expression(next_counter).value;

    if (increment != .binary or increment.binary.operator != .add) return null;
    if (!shape.matches(program, increment.binary.left, iteration.parameter, counter) or !shape.integer(program, increment.binary.right, 1)) return null;
    if (!try @import("visits.zig").once(lowering.allocator, program, iteration.body, updates[0])) return null;

    var value = initial;
    var type_id = program.expression(iteration.initial).type_id;

    for (source) |part| switch (program.typeOf(type_id)) {
        .object => |fields| {
            const field = fields.at(part);

            value = try lowering.field(value, field.name);
            type_id = field.type_id;
        },
        .tuple => |items| {
            value = try lowering.field(value, try std.fmt.allocPrint(lowering.allocator, "{d}", .{part}));
            type_id = items.at(part);
        },
        else => unreachable,
    };

    return try lowering.field(value, "len");
}
