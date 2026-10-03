const std = @import("std");
const zx = @import("zx");
const ast = zx.ast;

pub fn separation(source: []const u8, left: ast.Statement, right: ast.Statement) ?bool {
    if (multiline(source, left.span) or multiline(source, right.span)) return true;
    if (std.meta.activeTag(left.value) != std.meta.activeTag(right.value)) return true;

    const same = switch (left.value) {
        .constant => |binding| sameType(binding.annotation, right.value.constant.annotation) and sameExpression(binding.value, right.value.constant.value),
        .destructure => |binding| sameExpression(binding.value, right.value.destructure.value),
        .store_set => |setter| sameExpression(setter.target, right.value.store_set.target) and sameExpression(setter.value, right.value.store_set.value),
        else => false,
    };

    return if (same) false else null;
}

pub fn multiline(source: []const u8, span: zx.Span) bool {
    return std.mem.indexOfScalar(u8, source[span.start..span.end], '\n') != null;
}

fn sameExpression(left: *const ast.Expression, right: *const ast.Expression) bool {
    if (atom(left) and atom(right)) return true;
    if (std.meta.activeTag(left.value) != std.meta.activeTag(right.value)) return false;

    return switch (left.value) {
        .field => |field| sameExpression(field.target, right.value.field.target),
        .index => |index| sameExpression(index.target, right.value.index.target) and sameExpression(index.index, right.value.index.index),
        .unary => |unary| sameExpression(unary.operand, right.value.unary.operand),
        .binary => |binary| sameExpression(binary.left, right.value.binary.left) and sameExpression(binary.right, right.value.binary.right),
        .call => |call| sameExpression(call.callee, right.value.call.callee) and sameType(call.type_argument, right.value.call.type_argument) and sameItems(call.arguments, right.value.call.arguments),
        .list => |items| sameItems(items, right.value.list),
        .lambda => |lambda| sameExpression(lambda.body, right.value.lambda.body),
        .conditional => |conditional| sameExpression(conditional.condition, right.value.conditional.condition) and sameExpression(conditional.yes, right.value.conditional.yes) and sameExpression(conditional.no, right.value.conditional.no),
        .object => |fields| blk: {
            if (fields.len != right.value.object.len) break :blk false;

            for (fields, right.value.object) |a, b| {
                if (a.spread != b.spread or !sameExpression(a.value, b.value)) break :blk false;
            }

            break :blk true;
        },
        else => false,
    };
}

fn sameItems(left: []const *const ast.Expression, right: []const *const ast.Expression) bool {
    if (left.len != right.len) return false;

    for (left, right) |a, b| {
        if (!sameExpression(a, b)) return false;
    }

    return true;
}

fn atom(expression: *const ast.Expression) bool {
    return switch (expression.value) {
        .identifier, .number, .string, .boolean, .null_value => true,
        else => false,
    };
}

fn sameType(left: ?*const ast.Type, right: ?*const ast.Type) bool {
    const a = left orelse return right == null;
    const b = right orelse return false;

    if (std.meta.activeTag(a.*) != std.meta.activeTag(b.*)) return false;

    return switch (a.*) {
        .named => true,
        .optional => |child| sameType(child, b.optional),
        .list => |child| sameType(child, b.list),
        .application => |application| sameType(application.argument, b.application.argument),
        else => false,
    };
}
