const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Self = @This();

parents: []usize,
representatives: []?Graph.Id,
pub fn init(graph: *Graph) zx.Error!Self {
    var index: usize = 0;

    while (index < graph.nodes.items.len) : (index += 1) _ = try payload(graph, @enumFromInt(index));

    const parents = try graph.allocator.alloc(usize, graph.nodes.items.len);

    errdefer graph.allocator.free(parents);

    const representatives = try graph.allocator.alloc(?Graph.Id, parents.len);
    var self = Self{ .parents = parents, .representatives = representatives };

    for (parents, 0..) |*parent, item| parent.* = item;

    @memset(representatives, null);

    for (graph.assignments.items) |edge| {
        const left = self.root(@intFromEnum(try payload(graph, edge.value)));
        const right = self.root(@intFromEnum(try payload(graph, edge.expected)));

        parents[right] = left;
    }

    for (graph.nodes.items, 0..) |_, item| {
        const id: Graph.Id = @enumFromInt(item);
        const base = try payload(graph, id);
        const node = graph.nodes.items[@intFromEnum(base)];

        if (node.shape == .unknown and node.allowed == null) continue;

        representatives[self.root(@intFromEnum(base))] = base;
    }

    return self;
}

pub fn deinit(self: Self, allocator: std.mem.Allocator) void {
    allocator.free(self.parents);
    allocator.free(self.representatives);
}

pub fn root(self: Self, index: usize) usize {
    var current = index;

    while (self.parents[current] != current) current = self.parents[current];

    return current;
}

pub fn representative(self: Self, graph: *Graph, id: Graph.Id) zx.Error!?Graph.Id {
    return self.representatives[self.root(@intFromEnum(try payload(graph, id)))];
}

pub fn propagate(self: Self, graph: *Graph) zx.Error!void {
    for (0..self.parents.len) |index| {
        const id: Graph.Id = @enumFromInt(index);

        if (graph.root(id) != id) continue;

        const node = graph.nodes.items[index];

        if (node.shape == .optional or (node.shape == .known and graph.types.get(node.shape.known) == .optional)) continue;
        if (node.shape == .unknown and node.allowed == null) continue;

        const other = self.representatives[self.root(index)] orelse continue;

        if (graph.root(other) == id) continue;
        try graph.unify(id, other, node.span);

        return;
    }
}

pub fn payload(graph: *Graph, id: Graph.Id) zx.Error!Graph.Id {
    var current = graph.root(id);

    for (0..256) |_| {
        const node = graph.nodes.items[@intFromEnum(current)];

        switch (node.shape) {
            .optional => |child| current = graph.root(child),
            .known => |known| {
                const value = graph.types.get(known);

                if (value != .optional) return current;

                current = graph.root(try graph.known(value.optional, node.span));
            },
            else => return current,
        }
    }

    return graph.reporter.fail(.unsupported, graph.nodes.items[@intFromEnum(current)].span, "type inference nesting exceeds 256 levels");
}
