const zx = @import("zx");
const Context = @import("context.zig");
const collections = @import("expression_collections.zig");

pub fn fill(context: Context) !void {
    const tree = context.program.body.expression.tree;

    for (tree.nodes, context.expressions) |node, *value| {
        value.* = .{ .span = Context.span(node.span), .depth = @intCast(node.depth), .value = switch (node.kind) {
            .Number => .{ .number = context.text(node.name) },
            .String => .{ .string = context.text(node.name) },
            .Boolean => .{ .boolean = node.flag },
            .Null => .null_value,
            .Identifier => .{ .identifier = context.name(node.name) },
            .Field => .{ .field = .{ .target = context.expression(node.first), .name = context.name(node.name) } },
            .Index => .{ .index = .{ .target = context.expression(node.first), .index = context.expression(node.second) } },
            .List => .{ .list = try collections.arguments(context, node) },
            .Call => .{ .call = .{ .callee = context.expression(node.first), .arguments = try collections.arguments(context, node), .type_argument = if (node.type_argument == 0) null else context.typeValue(node.type_argument - 1) } },
            .Lambda => .{ .lambda = .{ .parameters = try collections.parameters(context, node), .body = context.expression(node.first) } },
            .Capture => .{ .capture = context.expression(node.first) },
            .Async => .{ .task = context.expression(node.first) },
            .Await => .{ .await_task = context.expression(node.first) },
            .Cancel => .{ .cancel_task = context.expression(node.first) },
            .StateBlock => .{ .state_block = context.block(node.first) },
            .Template => .{ .template = try collections.parts(context, node) },
            .Unary => .{ .unary = .{ .operator = if (node.flag) .negate else .not, .operand = context.expression(node.first) } },
            .Binary => .{ .binary = .{ .operator = Context.operator(node.operator), .left = context.expression(node.first), .right = context.expression(node.second) } },
            .Conditional => .{ .conditional = .{ .condition = context.expression(node.first), .yes = context.expression(node.second), .no = context.expression(node.third) } },
            .Match => .{ .match_expr = .{ .subject = if (node.first == 0) null else context.expression(node.first - 1), .arms = try collections.arms(context, node), .fallback = context.expression(node.second) } },
            .Object => .{ .object = try collections.fields(context, node) },
        } };
    }
}
