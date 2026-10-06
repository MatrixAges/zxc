const std = @import("std");
const Self = @This();

heads: []usize,
fields: []usize,
items: []usize,
pub fn create(allocator: std.mem.Allocator, tree: anytype) std.mem.Allocator.Error!Self {
    const heads = try allocator.alloc(usize, tree.nodes.len);

    errdefer allocator.free(heads);

    const fields = try allocator.alloc(usize, tree.fields.len);

    errdefer allocator.free(fields);

    const items = try allocator.alloc(usize, tree.items.len);

    @memset(heads, 0);
    @memset(fields, 0);
    @memset(items, 0);

    for (tree.nodes, 0..) |node, index| heads[index] = switch (node.kind) {
        .Object => forward(fields, tree.fields, node.head, node.count),
        .Tuple => forward(items, tree.items, node.head, node.count),
        else => 0,
    };

    return .{ .heads = heads, .fields = fields, .items = items };
}

fn forward(links: []usize, edges: anytype, head: u64, count: u64) usize {
    var current: usize = @intCast(head);
    var next: usize = 0;

    for (0..@as(usize, @intCast(count))) |_| {
        links[current - 1] = next;
        next = current;
        current = @intCast(edges[current - 1].previous);
    }

    return next;
}
