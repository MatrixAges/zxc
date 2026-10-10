const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");
const operator = @import("../../../../frontend/syntax/operator.zig");

pub fn fill(context: *Context, pending: Context.Body) std.mem.Allocator.Error!void {
    var head: u64 = 0;

    for (pending.source.statements) |value| {
        const index = try statement(context, value);

        try context.block_items.append(context.allocator, try context.keep(model.BlockItem, .{ .value = index, .previous = head }));

        head = context.block_items.items.len;
    }

    pending.target.* = .{ .span = try context.span(pending.source.span), .head = head, .count = pending.source.statements.len };
}

fn statement(context: *Context, source: zx.ast.Statement) std.mem.Allocator.Error!u64 {
    const index = context.statements.items.len;
    var name: []const u8 = "";

    var node: model.Statement = .{
        .kind = .Result,
        .span = try context.span(source.span),
        .name = &model.empty_span,
        .annotation = 0,
        .first = 0,
        .second = 0,
        .third = 0,
        .head = 0,
        .count = 0,
        .operator = .None,
    };

    switch (source.value) {
        .evaluate => |value| {
            node.kind = .Evaluate;
            node.first = try context.expression(value);
        },
        .state_update => |value| {
            node.kind = .StateUpdate;
            node.first = try context.expression(value.target);
            node.second = try context.expression(value.value);
            node.operator = if (value.operator) |op| operator.fromNative(model.Operator, op) else .None;
        },
        .constant => |value| {
            node.kind = .Constant;
            node.name = try context.span(value.name.span);
            node.annotation = if (value.annotation) |annotation| try context.typeReference(annotation) + 1 else 0;
            node.first = try context.expression(value.value);
            name = value.name.text;
        },
        .destructure => |value| {
            node.kind = .Destructure;
            node.first = try context.expression(value.value);
            node.count = value.names.len;

            for (value.names) |binding| {
                try context.names.append(context.allocator, try context.keep(model.Name, .{ .span = try context.span(binding.span), .previous = node.head }));
                try context.destructure_names.append(context.allocator, binding.text);

                node.head = context.names.items.len;
            }
        },
        .branch => |value| {
            node.kind = .Branch;
            node.first = try context.expression(value.condition);
            node.second = try context.block(value.yes);
            node.third = if (value.no) |alternative| try context.block(alternative) + 1 else 0;
        },
        .switch_stmt => |value| {
            node.kind = .Switch;
            node.first = try context.expression(value.subject);
            node.count = value.cases.len;

            for (value.cases) |item| {
                try context.cases.append(context.allocator, try context.keep(model.Case, .{
                    .span = try context.span(item.span),
                    .value = if (item.value) |expression| try context.expression(expression) + 1 else 0,
                    .body = try context.block(item.body),
                    .previous = node.head,
                }));

                node.head = context.cases.items.len;
            }
        },
        .store_set => |value| {
            node.kind = .StoreSet;
            node.first = try context.expression(value.target);
            node.second = try context.expression(value.value);
        },
        .result => |value| node.first = if (value) |expression| try context.expression(expression) + 1 else 0,
    }

    try context.statements.append(context.allocator, try context.keep(model.Statement, node));
    try context.statement_names.append(context.allocator, name);

    return index;
}
