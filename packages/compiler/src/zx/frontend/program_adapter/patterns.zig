const zx = @import("zx");
const Context = @import("context.zig");

pub fn fill(context: anytype) !void {
    const nodes = context.tables.blocks.names;

    for (nodes, context.patterns) |node, *target| {
        target.* = .{ .span = Context.span(node.span), .value = switch (node.kind) {
            .Name => .{ .name = context.name(node.span) },
            .Hole => .{ .name = .{ .text = "_", .span = Context.span(node.span) } },
            .Object => value: {
                const fields = try context.allocator.alloc(zx.ast.BindingField, @intCast(node.count));
                var remaining = fields.len;
                var head = node.head;

                while (remaining != 0) {
                    remaining -= 1;
                    const index: usize = @intCast(head - 1);
                    const child = nodes[index];
                    fields[remaining] = .{ .key = context.name(child.key), .pattern = &context.patterns[index] };
                    head = child.previous;
                }

                break :value .{ .object = fields };
            },
            .Sequence => value: {
                const items = try context.allocator.alloc(?*const zx.ast.BindingPattern, @intCast(node.count));
                var remaining = items.len;
                var head = node.head;

                while (remaining != 0) {
                    remaining -= 1;
                    const index: usize = @intCast(head - 1);
                    const child = nodes[index];
                    items[remaining] = if (child.kind == .Hole) null else &context.patterns[index];
                    head = child.previous;
                }

                break :value .{ .sequence = items };
            },
        } };
    }
}
