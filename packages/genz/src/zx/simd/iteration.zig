const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;
const expression = @import("expression.zig");
const proof = @import("iteration_proof.zig");

pub fn lower(self: *Lower, value: ir.Iteration, consumer: Consumer) Lower.Error!?*const node.Expression {
    const program = self.program;
    const output = program.typeOf(program.expression(consumer.result).type_id);

    if (value.postcondition or output != .list) return null;

    const scalar = program.typeOf(output.list);

    if (scalar != .scalar or (scalar.scalar != .f32 and scalar.scalar != .f64)) return null;

    const result_index = expression.field(program, consumer.result, consumer.symbol) orelse return null;
    const condition = program.expression(value.condition).value;

    if (condition != .binary or condition.binary.operator != .less) return null;

    const index = expression.field(program, condition.binary.left, value.condition_parameter) orelse return null;
    const bound = program.expression(condition.binary.right).value;

    if (bound != .length) return null;

    const source_index = expression.field(program, bound.length, value.condition_parameter) orelse return null;

    if (index == source_index or index == result_index or source_index == result_index) return null;

    const initial = program.expression(value.initial).value;
    const body = program.expression(value.body).value;

    if (initial != .object or body != .scope) return null;

    const next = program.expression(body.scope.result).value;

    if (next != .object or next.object.fields.len != initial.object.fields.len) return null;

    const source = proof.member(program, value.initial, source_index) orelse return null;
    const start = proof.member(program, value.initial, index) orelse return null;
    const empty = proof.member(program, value.initial, result_index) orelse return null;

    if (program.expression(source).type_id != program.expression(consumer.result).type_id or !proof.integer(program, start, 0)) return null;

    const index_type = program.typeOf(program.expression(start).type_id);

    if (index_type != .scalar or index_type.scalar != .u64) return null;

    const empty_value = program.expression(empty).value;

    if (empty_value != .list or empty_value.list.len != 0) return null;

    const context = expression.Context{ .bindings = body.scope.bindings, .iteration = .{ .symbol = value.parameter, .source = source_index, .index = index } };
    const appended = proof.member(program, body.scope.result, result_index) orelse return null;
    const projection = program.expression(appended).value;

    if (projection != .tuple_field or projection.tuple_field.index != 0) return null;

    const push = program.expression(projection.tuple_field.target).value;

    if (push != .list_operation or push.list_operation.kind != .push or push.list_operation.arguments.len != 1) return null;
    if (expression.field(program, push.list_operation.target, value.parameter) != result_index) return null;

    const callback = push.list_operation.arguments[0];

    if (!expression.supported(program, callback, context, output.list)) return null;

    for (0..body.scope.bindings.len) |position| {
        const binding = body.scope.bindings.at(position);
        var prefix = context;

        prefix.bindings.len = position;

        if (!expression.supported(program, binding.value, prefix, output.list) and !proof.passive(program, binding.value, prefix)) return null;
    }

    for (0..next.object.fields.len) |position| {
        const field = next.object.fields.at(position);

        if (field.index == result_index) continue;

        if (field.index == index) {
            const step = program.expression(field.value).value;

            if (step != .binary or step.binary.operator != .add or !proof.integer(program, step.binary.right, 1)) return null;
            if (expression.field(program, step.binary.left, value.parameter) != index) return null;
        } else if (expression.field(program, field.value, value.parameter) != field.index) return null;
    }

    for (0..initial.object.fields.len) |position| {
        const field = initial.object.fields.at(position);

        if (field.index != result_index and !proof.passive(program, field.value, .{})) return null;
    }

    if (!proof.evaluation(program, value.initial) or !proof.evaluation(program, body.scope.result)) return null;

    return @import("root.zig").emit(self, source, callback, output.list, context);
}
