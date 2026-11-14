const zx = @import("zx");
const Context = @import("context.zig");

pub fn fill(context: anytype) !void {
    const tree = context.tables.types;

    for (tree.nodes, context.types) |node, *value| {
        value.* = switch (node.kind) {
            .Named => .{ .named = context.name(node.name) },
            .Optional => .{ .optional = context.typeValue(node.child) },
            .List => .{ .list = context.typeValue(node.child) },
            .Application => .{ .application = .{ .name = context.name(node.name), .argument = context.typeValue(node.child) } },
            .Intersection => .{ .intersection = .{ .left = context.typeValue(node.child), .right = context.typeValue(node.head), .span = .{ .start = @intCast(node.name.start), .end = @intCast(node.name.end) } } },
            .Selection => blk: {
                const keys = try context.allocator.alloc(zx.ast.Name, @intCast(node.count));
                var head = node.head;
                var remaining = keys.len;

                while (remaining != 0) {
                    remaining -= 1;
                    const edge = tree.items[@intCast(head - 1)];
                    keys[remaining] = context.name(tree.nodes[@intCast(edge.value)].name);
                    head = edge.previous;
                }

                break :blk .{ .selection = .{ .name = context.name(node.name), .base = context.typeValue(node.child), .keys = keys } };
            },
            .Group => unreachable,
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
