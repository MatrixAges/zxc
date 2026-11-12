const zx = @import("zx");
const std = @import("std");
const paths = @import("frontend").binding_path;

pub fn includes(expression: *const zx.ast.Expression, facts: []const []const u8, name: []const u8) bool {
    if (mentions(expression, name)) return true;

    for (facts) |fact| {
        if (name.len <= fact.len and paths.overlaps(name, fact)) return true;
    }

    return false;
}

fn mentions(expression: *const zx.ast.Expression, name: []const u8) bool {
    const value = expression.value;

    return switch (value) {
        .identifier => std.mem.eql(u8, value.identifier.text, name),
        .field => paths.matches(expression, name) or mentions(value.field.target, name),
        .index => mentions(value.index.target, name) or mentions(value.index.index, name),
        .unary => mentions(value.unary.operand, name),
        .binary => mentions(value.binary.left, name) or mentions(value.binary.right, name),
        .conditional => mentions(value.conditional.condition, name) or mentions(value.conditional.yes, name) or mentions(value.conditional.no, name),
        .call => mentions(value.call.callee, name) or items(value.call.arguments, name),
        .list => items(value.list, name),
        .object => for (value.object) |field| {
            if (mentions(field.value, name)) break true;
        } else false,
        .template => for (value.template) |part| {
            if (part == .expression and mentions(part.expression, name)) break true;
        } else false,
        .match_expr => |selection| block: {
            if (selection.subject) |subject| {
                if (mentions(subject, name)) break :block true;
            }

            for (selection.arms) |arm| {
                if (mentions(arm.condition, name) or mentions(arm.result, name)) break :block true;
            }

            break :block mentions(selection.fallback, name);
        },
        .number, .string, .boolean, .null_value => false,
        .capture, .task, .await_task, .cancel_task, .lambda, .state_block, .pipeline => unreachable,
    };
}

fn items(expressions: []const *const zx.ast.Expression, name: []const u8) bool {
    for (expressions) |expression| {
        if (mentions(expression, name)) return true;
    }

    return false;
}
