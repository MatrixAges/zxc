const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");

pub fn arguments(context: *Context, values: []const *const zx.ast.Expression) std.mem.Allocator.Error!u64 {
    var head: u64 = 0;

    for (values) |value| {
        const index = try context.expression(value);

        try context.items.append(context.allocator, try context.keep(model.Edge, .{ .value = index, .previous = head }));

        head = context.items.items.len;
    }

    return head;
}

pub fn parameters(context: *Context, values: []const zx.ast.Name) std.mem.Allocator.Error!u64 {
    var head: u64 = 0;

    for (values) |value| {
        try context.parameters.append(context.allocator, try context.keep(model.Parameter, .{ .name = try context.span(value.span), .previous = head }));
        try context.parameter_names.append(context.allocator, value.text);

        head = context.parameters.items.len;
    }

    return head;
}

pub fn fields(context: *Context, values: []const zx.ast.Field) std.mem.Allocator.Error!u64 {
    var head: u64 = 0;

    for (values) |value| {
        try context.fields.append(context.allocator, try context.keep(model.Field, .{
            .name = try context.span(value.name.span),
            .value = try context.expression(value.value),
            .spread = value.spread,
            .previous = head,
        }));

        try context.field_names.append(context.allocator, value.name.text);

        head = context.fields.items.len;
    }

    return head;
}

pub fn parts(context: *Context, values: []const zx.ast.TemplatePart, span: zx.Span) std.mem.Allocator.Error!u64 {
    var head: u64 = 0;

    for (values) |value| {
        const expression = value == .expression;

        try context.parts.append(context.allocator, try context.keep(model.Part, .{
            .span = try context.span(if (expression) value.expression.span else span),
            .value = if (expression) try context.expression(value.expression) else 0,
            .expression = expression,
            .previous = head,
        }));

        try context.template_values.append(context.allocator, if (expression) "" else value.text);

        head = context.parts.items.len;
    }

    return head;
}

pub fn arms(context: *Context, values: []const zx.ast.MatchArm) std.mem.Allocator.Error!u64 {
    var head: u64 = 0;

    for (values) |value| {
        try context.arms.append(context.allocator, try context.keep(model.Arm, .{
            .condition = try context.expression(value.condition),
            .result = try context.expression(value.result),
            .previous = head,
        }));

        head = context.arms.items.len;
    }

    return head;
}
