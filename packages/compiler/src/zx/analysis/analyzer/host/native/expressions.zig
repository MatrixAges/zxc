const std = @import("std");
const Context = @import("context.zig");
const model = @import("model.zig");
const collections = @import("expression_collections.zig");
const operator = @import("../../../../frontend/syntax/operator.zig");

pub fn fill(context: *Context, pending: Context.Expression) std.mem.Allocator.Error!void {
    const source = pending.source;

    var node: model.Node = .{
        .kind = .Null,
        .span = try context.span(source.span),
        .depth = source.depth,
        .name = &model.empty_span,
        .flag = false,
        .operator = .None,
        .first = 0,
        .second = 0,
        .third = 0,
        .head = 0,
        .count = 0,
        .type_argument = 0,
    };

    switch (source.value) {
        .number, .string => |value| {
            node.kind = if (source.value == .number) .Number else .String;
            context.expression_values.items[pending.index] = value;
        },
        .boolean => |value| {
            node.kind = .Boolean;
            node.flag = value;
        },
        .null_value => {},
        .identifier => |name| {
            node.kind = .Identifier;
            node.name = try context.span(name.span);
            context.expression_names.items[pending.index] = name.text;
        },
        .field => |value| {
            node.kind = .Field;
            node.first = try context.expression(value.target);
            node.name = try context.span(value.name.span);
            context.expression_names.items[pending.index] = value.name.text;
        },
        .index => |value| {
            node.kind = .Index;
            node.first = try context.expression(value.target);
            node.second = try context.expression(value.index);
        },
        .capture, .task, .await_task, .cancel_task => |value| {
            node.kind = switch (source.value) {
                .capture => .Capture,
                .task => .Async,
                .await_task => .Await,
                .cancel_task => .Cancel,
                else => unreachable,
            };

            node.first = try context.expression(value);
        },
        .list => |values| {
            node.kind = .List;
            node.head = try collections.arguments(context, values);
            node.count = values.len;
        },
        .call => |value| {
            node.kind = .Call;
            node.first = try context.expression(value.callee);
            node.head = try collections.arguments(context, value.arguments);
            node.count = value.arguments.len;
            node.type_argument = if (value.type_argument) |argument| try context.typeReference(argument) + 1 else 0;
        },
        .lambda => |value| {
            node.kind = .Lambda;
            node.first = try context.expression(value.body);
            node.head = try collections.parameters(context, value.parameters);
            node.count = value.parameters.len;
        },
        .state_block => |value| {
            node.kind = .StateBlock;
            node.first = try context.block(value);
        },
        .template => |values| {
            node.kind = .Template;
            node.head = try collections.parts(context, values, source.span);
            node.count = values.len;
        },
        .unary => |value| {
            node.kind = .Unary;
            node.first = try context.expression(value.operand);
            node.flag = value.operator == .negate;
        },
        .binary => |value| {
            node.kind = .Binary;
            node.operator = operator.fromNative(model.Operator, value.operator);
            node.first = try context.expression(value.left);
            node.second = try context.expression(value.right);
        },
        .conditional => |value| {
            node.kind = .Conditional;
            node.first = try context.expression(value.condition);
            node.second = try context.expression(value.yes);
            node.third = try context.expression(value.no);
        },
        .match_expr => |value| {
            node.kind = .Match;
            node.first = if (value.subject) |subject| try context.expression(subject) + 1 else 0;
            node.second = try context.expression(value.fallback);
            node.head = try collections.arms(context, value.arms);
            node.count = value.arms.len;
        },
        .object => |values| {
            node.kind = .Object;
            node.head = try collections.fields(context, values);
            node.count = values.len;
        },
    }

    pending.target.* = node;
}
