const ir = @import("zx").ir;
const expression = @import("expression.zig");

pub fn member(program: ir.Program, id: ir.ExprId, index: u32) ?ir.ExprId {
    const object = program.expression(id).value.object;

    for (0..object.fields.len) |position| {
        const field = object.fields.at(position);

        if (field.index == index) return field.value;
    }

    return null;
}

pub fn integer(program: ir.Program, id: ir.ExprId, expected: u64) bool {
    const value = program.expression(id).value;

    return value == .integer and value.integer == expected;
}

pub fn passive(program: ir.Program, id: ir.ExprId, context: expression.Context) bool {
    const value = program.expression(context.resolve(program, id)).value;

    return switch (value) {
        .reference, .integer, .negative_integer, .float, .boolean, .unit, .none, .string, .enum_value, .error_value => true,
        .field, .tuple_field => |field| passive(program, field.target, context),
        .tuple => |items| result: {
            for (items) |item| if (!passive(program, item, context)) break :result false;

            break :result true;
        },
        else => false,
    };
}

pub fn evaluation(program: ir.Program, id: ir.ExprId) bool {
    const object = program.expression(id).value.object;

    if (object.evaluation.len != object.fields.len) return false;

    for (object.evaluation, 0..) |evaluated, index| {
        for (object.evaluation[0..index]) |previous| if (previous == evaluated) return false;

        var matched = false;

        for (0..object.fields.len) |position| {
            if (object.fields.at(position).value == evaluated) {
                matched = true;

                break;
            }
        }

        if (!matched) return false;
    }

    return true;
}
