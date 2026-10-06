const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;

pub fn separation(source: []const u8, left: anytype, right: @TypeOf(left)) ?bool {
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

fn sameExpression(left: anytype, right: @TypeOf(left)) bool {
    if (atom(left) and atom(right)) return true;
    if (std.meta.activeTag(syntax.value(left)) != std.meta.activeTag(syntax.value(right))) return false;

    return switch (syntax.value(left)) {
        .field => |field| sameExpression(field.target, syntax.value(right).field.target),
        .index => |index| sameExpression(index.target, syntax.value(right).index.target) and sameExpression(index.index, syntax.value(right).index.index),
        .capture => |child| sameExpression(child, syntax.value(right).capture),
        .task => |child| sameExpression(child, syntax.value(right).task),
        .await_task => |child| sameExpression(child, syntax.value(right).await_task),
        .cancel_task => |child| sameExpression(child, syntax.value(right).cancel_task),
        .unary => |unary| sameExpression(unary.operand, syntax.value(right).unary.operand),
        .binary => |binary| sameExpression(binary.left, syntax.value(right).binary.left) and sameExpression(binary.right, syntax.value(right).binary.right),
        .call => |call| sameExpression(call.callee, syntax.value(right).call.callee) and sameType(call.type_argument, syntax.value(right).call.type_argument) and sameItems(call.arguments, syntax.value(right).call.arguments),
        .list => |items| sameItems(items, syntax.value(right).list),
        .lambda => |lambda| sameExpression(lambda.body, syntax.value(right).lambda.body),
        .conditional => |conditional| sameExpression(conditional.condition, syntax.value(right).conditional.condition) and sameExpression(conditional.yes, syntax.value(right).conditional.yes) and sameExpression(conditional.no, syntax.value(right).conditional.no),
        .object => |fields| blk: {
            if (fields.len != syntax.value(right).object.len) break :blk false;

            for (0..fields.len) |index| {
                const a = syntax.item(fields, index);
                const b = syntax.item(syntax.value(right).object, index);

                if (a.spread != b.spread or !sameExpression(a.value, b.value)) break :blk false;
            }

            break :blk true;
        },
        else => false,
    };
}

fn sameItems(left: anytype, right: @TypeOf(left)) bool {
    if (left.len != right.len) return false;

    for (0..left.len) |index| {
        const a = syntax.item(left, index);
        const b = syntax.item(right, index);

        if (!sameExpression(a, b)) return false;
    }

    return true;
}

fn atom(expression: anytype) bool {
    return switch (syntax.value(expression)) {
        .identifier, .number, .string, .boolean, .null_value => true,
        else => false,
    };
}

fn sameType(left: anytype, right: @TypeOf(left)) bool {
    const a = left orelse return right == null;
    const b = right orelse return false;

    if (syntax.typeKind(a) != syntax.typeKind(b)) return false;

    return switch (syntax.typeKind(a)) {
        .named => true,
        .optional, .list, .application => sameType(@as(@TypeOf(left), syntax.typeChild(a)), @as(@TypeOf(right), syntax.typeChild(b))),
        else => false,
    };
}
