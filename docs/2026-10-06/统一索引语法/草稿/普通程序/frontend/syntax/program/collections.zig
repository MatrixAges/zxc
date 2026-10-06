const zx = @import("zx");
const Kind = @import("model.zig").Kind;
const span = zx.syntax.header.span;

pub fn item(comptime kind: Kind, sequence: anytype, index: usize) @TypeOf(sequence).Item {
    const context = sequence.context;

    if (kind == .contracts) {
        const edge = context.storage.contracts[sequence.first + index];

        return .{ .kind = if (edge.ensures) .ensures else .requires, .predicate = context.expression(edge.predicate), .span = span(edge.span) };
    }

    const id = context.order.edges[sequence.first + index];

    return switch (kind) {
        .arguments => context.expression(context.storage.expressions.items[id].value),
        .parameters => context.name(context.storage.expressions.parameters[id].name),
        .names => context.name(context.storage.blocks.names[id].span),
        .fields => block: {
            const edge = context.storage.expressions.fields[id];

            break :block .{ .name = if (edge.spread) .{ .text = "", .span = span(edge.name) } else context.name(edge.name), .value = context.expression(edge.value), .spread = edge.spread };
        },
        .parts => block: {
            const edge = context.storage.expressions.parts[id];

            break :block if (edge.expression) .{ .expression = context.expression(edge.value) } else .{ .text = context.text(edge.span) };
        },
        .arms => block: {
            const edge = context.storage.expressions.arms[id];

            break :block .{ .condition = context.expression(edge.condition), .result = context.expression(edge.result) };
        },
        .statements => @import("statements.zig").read(context, @intCast(context.storage.blocks.items[id].value)),
        .cases => block: {
            const edge = context.storage.blocks.cases[id];

            break :block .{ .value = if (edge.value == 0) null else context.expression(edge.value - 1), .body = context.block(edge.body), .span = span(edge.span) };
        },
        .contracts => unreachable,
    };
}
