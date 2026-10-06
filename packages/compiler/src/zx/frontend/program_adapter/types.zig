const zx = @import("zx");
const Context = @import("context.zig");

pub fn fill(context: anytype) !void {
    const tree = context.body.expression.types.tree;

    for (tree.nodes, context.types) |node, *value| {
        value.* = switch (node.kind) {
            .Named => .{ .named = context.name(node.name) },
            .Optional => .{ .optional = context.typeValue(node.child) },
            .List => .{ .list = context.typeValue(node.child) },
            .Application => .{ .application = .{ .name = context.name(node.name), .argument = context.typeValue(node.child) } },
            .Object => blk: {
                const fields = try context.allocator.alloc(zx.ast.TypeField, @intCast(node.count));
                var head = node.head;
                var remaining = fields.len;

                while (remaining != 0) {
                    remaining -= 1;
                    const edge = tree.fields[@intCast(head - 1)];
                    fields[remaining] = .{ .name = context.name(edge.name), .value = context.typeValue(edge.value) };
                    head = edge.previous;
                }

                break :blk .{ .object = fields };
            },
            .Tuple => blk: {
                const items = try context.allocator.alloc(*const zx.ast.Type, @intCast(node.count));
                var head = node.head;
                var remaining = items.len;

                while (remaining != 0) {
                    remaining -= 1;
                    const edge = tree.items[@intCast(head - 1)];
                    items[remaining] = context.typeValue(edge.value);
                    head = edge.previous;
                }

                break :blk .{ .tuple = items };
            },
        };
    }
}
