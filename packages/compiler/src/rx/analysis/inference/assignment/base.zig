const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Self = @This();

parents: []const u64,
representatives: []const ?u64,
pub fn init(graph: *Graph, allocator: std.mem.Allocator) zx.Error!Self {
    return if (@import("rx_options").generated_graph)
        build(graph, allocator)
    else
        seed(graph, allocator);
}

fn build(graph: *Graph, allocator: std.mem.Allocator) zx.Error!Self {
    const generated = @import("generated_assignment_classes");
    var payloads = try std.ArrayList(u64).initCapacity(allocator, graph.nodes.items.len);
    var index: usize = 0;

    while (index < graph.nodes.items.len) : (index += 1) {
        try payloads.append(allocator, @backingInt(try payload(graph, @fromBackingInt(@intCast(index)))));
    }

    const candidates = try allocator.alloc(bool, payloads.items.len);

    for (payloads.items, candidates) |id, *candidate| {
        const node = graph.nodes.items[@intCast(id)];

        candidate.* = node.shape != .unknown or node.allowed != null;
    }

    const left = try allocator.alloc(u64, graph.assignments.items.len);
    const right = try allocator.alloc(u64, left.len);

    for (graph.assignments.items, left, right) |edge, *value, *expected| {
        value.* = @backingInt(edge.value);
        expected.* = @backingInt(edge.expected);
    }

    const classes = generated.executeValue(allocator, &.{
        .payloads = payloads.items,
        .candidates = candidates,
        .edges = &.{ .left = left, .right = right },
    }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    return .{ .parents = classes.parents, .representatives = classes.representatives };
}

fn seed(graph: *Graph, allocator: std.mem.Allocator) zx.Error!Self {
    var index: usize = 0;

    while (index < graph.nodes.items.len) : (index += 1) _ = try payload(graph, @fromBackingInt(@intCast(index)));

    const parents = try allocator.alloc(u64, graph.nodes.items.len);
    const representatives = try allocator.alloc(?u64, parents.len);

    for (parents, 0..) |*parent, item| parent.* = item;

    @memset(representatives, null);

    for (graph.assignments.items) |edge| {
        const left = root(parents, @backingInt(try payload(graph, edge.value)));
        const right = root(parents, @backingInt(try payload(graph, edge.expected)));

        parents[right] = left;
    }

    for (graph.nodes.items, 0..) |_, item| {
        const id: Graph.Id = @fromBackingInt(@intCast(item));
        const base = try payload(graph, id);
        const node = graph.nodes.items[@backingInt(base)];

        if (node.shape == .unknown and node.allowed == null) continue;

        representatives[root(parents, @backingInt(base))] = @backingInt(base);
    }

    for (parents, 0..) |*parent, item| parent.* = root(parents, item);

    return .{ .parents = parents, .representatives = representatives };
}

fn root(parents: []u64, index: usize) usize {
    var current = index;

    while (parents[current] != current) {
        const grandparent = parents[@intCast(parents[current])];

        parents[current] = grandparent;
        current = @intCast(grandparent);
    }

    return current;
}

pub fn representative(self: Self, graph: *Graph, id: Graph.Id) zx.Error!?Graph.Id {
    return self.lookup(@backingInt(try payload(graph, id)));
}

fn lookup(self: Self, index: usize) ?Graph.Id {
    const value = self.representatives[@intCast(self.parents[index])] orelse return null;

    return @fromBackingInt(@intCast(value));
}

/// Unifies every root with its class representative in one pass instead of one pair per rebuilt base. A
/// representative whose payload changed during the pass waits for the next round's fresh base.
pub fn propagate(self: Self, graph: *Graph) zx.Error!void {
    for (0..self.parents.len) |index| {
        const id: Graph.Id = @fromBackingInt(@intCast(index));

        if (graph.root(id) != id) continue;

        const node = graph.nodes.items[index];

        if (node.shape == .optional or (node.shape == .known and graph.types.get(node.shape.known) == .optional)) continue;
        if (node.shape == .unknown and node.allowed == null) continue;

        const other = self.lookup(index) orelse continue;

        if (graph.root(other) == id) continue;
        if (try payload(graph, other) != graph.root(other)) continue;
        try graph.unify(id, other, node.span);
    }
}

pub fn payload(graph: *Graph, id: Graph.Id) zx.Error!Graph.Id {
    var current = graph.root(id);

    for (0..256) |_| {
        const node = graph.nodes.items[@backingInt(current)];

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

    return graph.reporter.fail(.unsupported, graph.nodes.items[@backingInt(current)].span, "type inference nesting exceeds 256 levels");
}
