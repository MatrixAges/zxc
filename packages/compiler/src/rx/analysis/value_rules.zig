const zx = @import("zx");
const ast = zx.ast;

pub const message = "RX values cannot contain calls or callbacks; move logic to ZX and use Call.fn or Call.module";

pub fn validate(expression: *const ast.Expression) ?zx.Diagnostic {
    switch (expression.value) {
        .call, .lambda, .state_block => return .{ .code = .unsupported, .span = expression.span, .message = message },
        .field => |field| return validate(field.target),
        .index => |item| return validate(item.target) orelse validate(item.index),
        .unary => |unary| return validate(unary.operand),
        .binary => |binary| return validate(binary.left) orelse validate(binary.right),
        .conditional => |branch| return validate(branch.condition) orelse validate(branch.yes) orelse validate(branch.no),
        .object => |fields| for (fields) |field| {
            if (validate(field.value)) |issue| return issue;
        },
        .list => |items| for (items) |item| {
            if (validate(item)) |issue| return issue;
        },
        .template => |parts| for (parts) |part| {
            if (part == .expression) if (validate(part.expression)) |issue| return issue;
        },
        .match_expr => |selection| {
            if (selection.subject) |subject| if (validate(subject)) |issue| return issue;

            for (selection.arms) |arm| {
                if (validate(arm.condition) orelse validate(arm.result)) |issue| return issue;
            }

            return validate(selection.fallback);
        },
        .identifier, .number, .boolean, .string, .null_value => {},
    }

    return null;
}
