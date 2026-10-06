const Kind = @import("model.zig").Kind;

pub fn read(reference: anytype) @TypeOf(reference).Value {
    const context = reference.context;
    const node = context.storage.expressions.nodes[reference.index];

    return switch (node.kind) {
        .Number => .{ .number = context.text(node.name) },
        .String => .{ .string = context.text(node.name) },
        .Boolean => .{ .boolean = node.flag },
        .Null => .null_value,
        .Identifier => .{ .identifier = context.name(node.name) },
        .Field => .{ .field = .{ .target = context.expression(node.first), .name = context.name(node.name) } },
        .Index => .{ .index = .{ .target = context.expression(node.first), .index = context.expression(node.second) } },
        .List => .{ .list = sequence(.arguments, reference, node.count) },
        .Call => .{ .call = .{ .callee = context.expression(node.first), .arguments = sequence(.arguments, reference, node.count), .type_argument = if (node.type_argument == 0) null else context.typeValue(node.type_argument - 1) } },
        .Lambda => .{ .lambda = .{ .parameters = sequence(.parameters, reference, node.count), .body = context.expression(node.first) } },
        .Capture => .{ .capture = context.expression(node.first) },
        .Async => .{ .task = context.expression(node.first) },
        .Await => .{ .await_task = context.expression(node.first) },
        .Cancel => .{ .cancel_task = context.expression(node.first) },
        .StateBlock => .{ .state_block = context.block(node.first) },
        .Template => .{ .template = sequence(.parts, reference, node.count) },
        .Unary => .{ .unary = .{ .operator = if (node.flag) .negate else .not, .operand = context.expression(node.first) } },
        .Binary => .{ .binary = .{ .operator = @import("../operator.zig").get(node.operator), .left = context.expression(node.first), .right = context.expression(node.second) } },
        .Conditional => .{ .conditional = .{ .condition = context.expression(node.first), .yes = context.expression(node.second), .no = context.expression(node.third) } },
        .Match => .{ .match_expr = .{ .subject = if (node.first == 0) null else context.expression(node.first - 1), .arms = sequence(.arms, reference, node.count), .fallback = context.expression(node.second) } },
        .Object => .{ .object = sequence(.fields, reference, node.count) },
    };
}

fn sequence(comptime kind: Kind, reference: anytype, count: u64) @TypeOf(reference.context.*).Model.Sequence(kind) {
    return .{ .context = reference.context, .first = reference.context.order.expressions[reference.index], .len = @intCast(count) };
}
