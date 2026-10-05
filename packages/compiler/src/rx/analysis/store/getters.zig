const std = @import("std");
const Expression = @import("zx").ast.Expression;

pub fn matches(expression: *const Expression, name: []const u8) bool {
    if (expression.value == .identifier) return std.mem.eql(u8, expression.value.identifier.text, name);
    if (expression.value != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, name, '.') orelse return false;
    const field = expression.value.field;

    return std.mem.eql(u8, field.name.text, name[separator + 1 ..]) and matches(field.target, name[0..separator]);
}

pub fn contains(expression: *const Expression, name: []const u8) bool {
    if (matches(expression, name)) return true;

    return switch (expression.value) {
        .field => |field| contains(field.target, name),
        .index => |item| contains(item.target, name) or contains(item.index, name),
        .list => |items| sequence(items, name),
        .call => |call| contains(call.callee, name) or sequence(call.arguments, name),
        .template => |parts| block: {
            for (parts) |part| if (part == .expression and contains(part.expression, name)) {
                break :block true;
            };

            break :block false;
        },
        .capture => |child| contains(child, name),
        .unary => |unary| contains(unary.operand, name),
        .binary => |binary| contains(binary.left, name) or contains(binary.right, name),
        .conditional => |branch| contains(branch.condition, name) or contains(branch.yes, name) or contains(branch.no, name),
        .match_expr => |selection| block: {
            if (selection.subject) |subject| if (contains(subject, name)) {
                break :block true;
            };

            for (selection.arms) |arm| if (contains(arm.condition, name) or contains(arm.result, name)) {
                break :block true;
            };

            break :block contains(selection.fallback, name);
        },
        .object => |fields| block: {
            for (fields) |field| if (contains(field.value, name)) {
                break :block true;
            };

            break :block false;
        },
        .number, .string, .boolean, .null_value, .identifier, .lambda, .state_block => false,
    };
}

fn sequence(expressions: []const *const Expression, name: []const u8) bool {
    for (expressions) |expression| if (contains(expression, name)) {
        return true;
    };

    return false;
}
