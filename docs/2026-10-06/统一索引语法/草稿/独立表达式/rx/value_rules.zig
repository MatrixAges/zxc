const zx = @import("zx");
const syntax = zx.syntax.borrow;
pub const message = "RX values cannot contain calls or callbacks; move logic to ZX and use Call.fn or Call.module";

pub fn validate(expression: anytype) ?zx.Diagnostic {
    switch (syntax.value(expression)) {
        .call, .lambda, .state_block, .capture, .task, .await_task, .cancel_task => return .{ .code = .unsupported, .span = expression.span, .message = message },
        .field => |field| return validate(field.target),
        .index => |item| return validate(item.target) orelse validate(item.index),
        .unary => |unary| return validate(unary.operand),
        .binary => |binary| return validate(binary.left) orelse validate(binary.right),
        .conditional => |branch| return validate(branch.condition) orelse validate(branch.yes) orelse validate(branch.no),
        .object => |fields| for (0..fields.len) |index| {
            const field = syntax.item(fields, index);

            if (validate(field.value)) |issue| return issue;
        },
        .list => |items| for (0..items.len) |index| {
            const item = syntax.item(items, index);

            if (validate(item)) |issue| return issue;
        },
        .template => |parts| for (0..parts.len) |index| {
            const part = syntax.item(parts, index);

            if (part == .expression) if (validate(part.expression)) |issue| return issue;
        },
        .match_expr => |selection| {
            if (selection.subject) |subject| if (validate(subject)) |issue| return issue;

            for (0..selection.arms.len) |index| {
                const arm = syntax.item(selection.arms, index);

                if (validate(arm.condition) orelse validate(arm.result)) |issue| return issue;
            }

            return validate(selection.fallback);
        },
        .identifier, .number, .boolean, .string, .null_value => {},
    }

    return null;
}
