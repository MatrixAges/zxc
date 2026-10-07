const std = @import("std");
const rx = @import("rx");
const frontend = @import("frontend");
const syntax = @import("zx").syntax.borrow;

pub fn truth(allocator: std.mem.Allocator, owner: []const u8, label: ?rx.ast.Attribute, cases: anytype) std.mem.Allocator.Error!?bool {
    if (label) |attribute| return boolean(allocator, owner, attribute);

    var yes = false;
    var no = false;

    for (cases) |case| {
        const attribute = case.value orelse continue;
        const value = (try boolean(allocator, owner, attribute)) orelse return null;

        yes = yes or value;
        no = no or !value;
    }

    return if (yes != no) !yes else null;
}

fn boolean(allocator: std.mem.Allocator, owner: []const u8, attribute: rx.ast.Attribute) std.mem.Allocator.Error!?bool {
    var parsed = try @import("attribute.zig").parse(allocator, attribute, owner);

    defer parsed.deinit();

    if (parsed.diagnostic() != null) return null;

    return switch (parsed) {
        .native => |result| booleanValue(result.value.parsed.expression),
        .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) block: {
            var scratch = std.heap.ArenaAllocator.init(allocator);

            defer scratch.deinit();

            const view = try result.view(scratch.allocator());

            break :block booleanValue(view.expression(result.output.result));
        } else unreachable,
    };
}

fn booleanValue(expression: anytype) ?bool {
    const value = syntax.value(expression);

    return if (value == .boolean) value.boolean else null;
}

pub fn assume(allocator: std.mem.Allocator, owner: []const u8, attribute: rx.ast.Attribute, present: bool, context: anytype) @import("zx").Error!void {
    var parsed = try @import("attribute.zig").parse(allocator, attribute, owner);

    defer parsed.deinit();

    if (parsed.diagnostic() != null) return;

    switch (parsed) {
        .native => |result| try visit(result.value.parsed.expression, present, context),
        .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) {
            var scratch = std.heap.ArenaAllocator.init(allocator);

            defer scratch.deinit();

            const view = try result.view(scratch.allocator());

            try visit(view.expression(result.output.result), present, context);
        } else unreachable,
    }
}

fn visit(expression: anytype, present: bool, context: anytype) @import("zx").Error!void {
    const value = syntax.value(expression);

    if (value == .unary and value.unary.operator == .not) return visit(value.unary.operand, !present, context);
    if (value != .binary) return;

    const binary = value.binary;

    if ((binary.operator == .logical_and and present) or (binary.operator == .logical_or and !present)) {
        try visit(binary.left, present, context);
        try visit(binary.right, present, context);

        return;
    }

    if (binary.operator != .equal and binary.operator != .not_equal) return;
    if ((binary.operator == .not_equal) != present) return;

    if (syntax.value(binary.left) == .null_value) {
        try context.assumeNonNull(binary.right);
    } else if (syntax.value(binary.right) == .null_value) {
        try context.assumeNonNull(binary.left);
    }
}

pub fn matches(expression: anytype, name: []const u8) bool {
    const value = syntax.value(expression);

    if (value == .identifier) return std.mem.eql(u8, value.identifier.text, name);
    if (value != .field) return false;

    const separator = std.mem.lastIndexOfScalar(u8, name, '.') orelse return false;

    return std.mem.eql(u8, value.field.name.text, name[separator + 1 ..]) and matches(value.field.target, name[0..separator]);
}
