const std = @import("std");
const syntax = @import("zx").syntax.borrow;

pub fn matches(expression: anytype, name: []const u8) bool {
    const node = syntax.value(expression);

    if (node == .identifier) return std.mem.eql(u8, node.identifier.text, name);
    if (node != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, name, '.') orelse return false;
    const field = node.field;

    return std.mem.eql(u8, field.name.text, name[separator + 1 ..]) and matches(field.target, name[0..separator]);
}

pub fn contains(expression: anytype, name: []const u8) bool {
    if (matches(expression, name)) return true;

    return switch (syntax.value(expression)) {
        .field => |field| contains(field.target, name),
        .index => |item| contains(item.target, name) or contains(item.index, name),
        .list => |items| sequence(items, name),
        .call => |call| contains(call.callee, name) or sequence(call.arguments, name),
        .template => |parts| block: {
            for (0..parts.len) |index| {
                const part = syntax.item(parts, index);

                if (part == .expression and contains(part.expression, name)) {
                    break :block true;
                }
            }

            break :block false;
        },
        .capture, .task, .await_task, .cancel_task => |child| contains(child, name),
        .unary => |unary| contains(unary.operand, name),
        .binary => |binary| contains(binary.left, name) or contains(binary.right, name),
        .conditional => |branch| contains(branch.condition, name) or contains(branch.yes, name) or contains(branch.no, name),
        .match_expr => |selection| block: {
            if (selection.subject) |subject| if (contains(subject, name)) {
                break :block true;
            };

            for (0..selection.arms.len) |index| {
                const arm = syntax.item(selection.arms, index);

                if (contains(arm.condition, name) or contains(arm.result, name)) {
                    break :block true;
                }
            }

            break :block contains(selection.fallback, name);
        },
        .object => |fields| block: {
            for (0..fields.len) |index| if (contains(syntax.item(fields, index).value, name)) {
                break :block true;
            };

            break :block false;
        },
        .number, .string, .boolean, .null_value, .identifier, .lambda, .state_block => false,
    };
}

fn sequence(expressions: anytype, name: []const u8) bool {
    for (0..expressions.len) |index| if (contains(syntax.item(expressions, index), name)) {
        return true;
    };

    return false;
}
