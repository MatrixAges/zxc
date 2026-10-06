const std = @import("std");
const ast = @import("../ast.zig");

pub fn value(expression: anytype) ExpressionValue(@TypeOf(expression)) {
    if (comptime nativeExpression(@TypeOf(expression))) return expression.value;

    return expression.read();
}

fn ExpressionValue(comptime Ref: type) type {
    return if (nativeExpression(Ref)) @FieldType(ast.Expression, "value") else Ref.Value;
}

fn nativeExpression(comptime Ref: type) bool {
    return Ref == *const ast.Expression or Ref == *ast.Expression;
}

pub fn item(collection: anytype, index: usize) Item(@TypeOf(collection)) {
    return switch (@typeInfo(@TypeOf(collection))) {
        .pointer, .array => collection[index],
        else => collection.at(index),
    };
}

fn Item(comptime Collection: type) type {
    return switch (@typeInfo(Collection)) {
        .pointer => |pointer| if (pointer.size == .slice) pointer.child else @typeInfo(pointer.child).array.child,
        .array => |array| array.child,
        else => Collection.Item,
    };
}

pub fn typeKind(reference: anytype) std.meta.Tag(ast.Type) {
    if (@TypeOf(reference) == *const ast.Type or @TypeOf(reference) == *ast.Type) return std.meta.activeTag(reference.*);

    return reference.view.kind(reference.ref);
}

pub fn typeChild(reference: anytype) @TypeOf(reference) {
    if (@TypeOf(reference) == *const ast.Type or @TypeOf(reference) == *ast.Type) return switch (reference.*) {
        .optional, .list => |child| child,
        .application => |application| application.argument,
        else => unreachable,
    };

    return .{ .view = reference.view, .ref = reference.view.child(reference.ref) };
}
