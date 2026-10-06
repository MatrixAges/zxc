const zx = @import("zx");
const Context = @import("context.zig");

pub fn fill(context: anytype) !void {
    const tree = context.body.tree;

    for (tree.blocks, context.blocks) |node, *value| {
        const statements = try context.allocator.alloc(zx.ast.Statement, @intCast(node.count));
        var head = node.head;
        var remaining = statements.len;

        while (remaining != 0) {
            remaining -= 1;
            const edge = tree.items[@intCast(head - 1)];
            statements[remaining] = try statement(context, edge.value);
            head = edge.previous;
        }

        value.* = .{ .span = Context.span(node.span), .statements = statements };
    }
}

fn statement(context: anytype, index: u64) !zx.ast.Statement {
    const tree = context.body.tree;
    const node = tree.statements[@intCast(index)];

    return .{ .span = Context.span(node.span), .value = switch (node.kind) {
        .Constant => .{ .constant = .{ .name = context.name(node.name), .annotation = if (node.annotation == 0) null else context.typeValue(node.annotation - 1), .value = context.expression(node.first) } },
        .Destructure => blk: {
            const names = try context.allocator.alloc(zx.ast.Name, @intCast(node.count));
            var head = node.head;
            var remaining = names.len;

            while (remaining != 0) {
                remaining -= 1;
                const edge = tree.names[@intCast(head - 1)];
                names[remaining] = context.name(edge.span);
                head = edge.previous;
            }

            break :blk .{ .destructure = .{ .names = names, .value = context.expression(node.first) } };
        },
        .Result => .{ .result = if (node.first == 0) null else context.expression(node.first - 1) },
        .Branch => .{ .branch = .{ .condition = context.expression(node.first), .yes = context.block(node.second), .no = if (node.third == 0) null else context.block(node.third - 1) } },
        .Switch => blk: {
            const cases = try context.allocator.alloc(zx.ast.SwitchCase, @intCast(node.count));
            var head = node.head;
            var remaining = cases.len;

            while (remaining != 0) {
                remaining -= 1;
                const edge = tree.cases[@intCast(head - 1)];
                cases[remaining] = .{ .value = if (edge.value == 0) null else context.expression(edge.value - 1), .body = context.block(edge.body), .span = Context.span(edge.span) };
                head = edge.previous;
            }

            break :blk .{ .switch_stmt = .{ .subject = context.expression(node.first), .cases = cases } };
        },
        .StoreSet => .{ .store_set = .{ .target = context.expression(node.first), .value = context.expression(node.second) } },
        .Evaluate => .{ .evaluate = context.expression(node.first) },
        .StateUpdate => .{ .state_update = .{ .target = context.expression(node.first), .value = context.expression(node.second), .operator = if (node.operator == .None) null else Context.operator(node.operator) } },
    } };
}
