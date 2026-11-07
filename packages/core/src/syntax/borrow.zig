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

pub fn bindingKind(pattern: anytype) std.meta.Tag(@FieldType(ast.BindingPattern, "value")) {
    if (@TypeOf(pattern) == *const ast.BindingPattern or @TypeOf(pattern) == *ast.BindingPattern) return std.meta.activeTag(pattern.value);

    return pattern.kind();
}

pub fn bindingName(pattern: anytype) ast.Name {
    if (@TypeOf(pattern) == *const ast.BindingPattern or @TypeOf(pattern) == *ast.BindingPattern) return pattern.value.name;

    return pattern.name();
}

pub fn bindingCount(pattern: anytype) usize {
    if (@TypeOf(pattern) == *const ast.BindingPattern or @TypeOf(pattern) == *ast.BindingPattern) return switch (pattern.value) {
        .name => 0,
        .object => |items| items.len,
        .sequence => |items| items.len,
    };

    return pattern.count();
}

pub fn bindingChild(pattern: anytype, index: usize) ?@TypeOf(pattern) {
    if (@TypeOf(pattern) == *const ast.BindingPattern or @TypeOf(pattern) == *ast.BindingPattern) return switch (pattern.value) {
        .object => |fields| fields[index].pattern,
        .sequence => |items| items[index],
        .name => unreachable,
    };

    return pattern.child(index);
}

pub fn bindingKey(pattern: anytype, index: usize) ast.Name {
    if (@TypeOf(pattern) == *const ast.BindingPattern or @TypeOf(pattern) == *ast.BindingPattern) return pattern.value.object[index].key;

    return pattern.key(index);
}
