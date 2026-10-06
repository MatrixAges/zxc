const zx = @import("zx");
const operator = @import("../operator.zig");

pub fn read(context: anytype, index: usize) @TypeOf(context.*).Model.Statement {
    const node = context.storage.blocks.statements[index];
    const first = context.order.statements[index];

    return .{ .span = zx.syntax.header.span(node.span), .value = switch (node.kind) {
        .Constant => .{ .constant = .{ .name = context.name(node.name), .annotation = if (node.annotation == 0) null else context.typeValue(node.annotation - 1), .value = context.expression(node.first) } },
        .Destructure => .{ .destructure = .{ .names = .{ .context = context, .first = first, .len = @intCast(node.count) }, .value = context.expression(node.first) } },
        .Result => .{ .result = if (node.first == 0) null else context.expression(node.first - 1) },
        .Branch => .{ .branch = .{ .condition = context.expression(node.first), .yes = context.block(node.second), .no = if (node.third == 0) null else context.block(node.third - 1) } },
        .Switch => .{ .switch_stmt = .{ .subject = context.expression(node.first), .cases = .{ .context = context, .first = first, .len = @intCast(node.count) } } },
        .StoreSet => .{ .store_set = .{ .target = context.expression(node.first), .value = context.expression(node.second) } },
        .Evaluate => .{ .evaluate = context.expression(node.first) },
        .StateUpdate => .{ .state_update = .{ .target = context.expression(node.first), .value = context.expression(node.second), .operator = if (node.operator == .None) null else operator.get(node.operator) } },
    } };
}
