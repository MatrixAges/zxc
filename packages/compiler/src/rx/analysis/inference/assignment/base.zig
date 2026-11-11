const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Self = @This();

parents: []const u32,
representatives: []const ?u32,

payloads: []const u32 = &.{},
pub fn init(graph: *Graph, allocator: std.mem.Allocator) zx.Error!Self {
    return if (@import("rx_options").generated_graph)
        build(graph, allocator)
    else
        seed(graph, allocator);
}

fn build(graph: *Graph, allocator: std.mem.Allocator) zx.Error!Self {
    const generated = @import("generated_assignment_classes");
    var payloads = try std.ArrayList(u32).initCapacity(allocator, graph.nodes.len);
    var index: usize = 0;

    while (index < graph.nodes.len) : (index += 1) {
        try payloads.append(allocator, @backingInt(try payload(graph, @fromBackingInt(@intCast(index)))));
    }

    const candidates = try allocator.alloc(bool, payloads.items.len);
    const rows = graph.nodes.slice();
    const kinds = rows.items(.kind);
    const facts = rows.items(.facts);

    for (payloads.items, candidates) |id, *candidate| {
        candidate.* = kinds[id] != .Unknown or facts[id].allowed != null;
    }

    const edges = graph.assignments.slice();

    const classes = generated.executeValue(allocator, &.{
        .payloads = payloads.items,
        .candidates = candidates,
        .edges = &.{ .left = @ptrCast(edges.items(.value)), .right = @ptrCast(edges.items(.expected)) },
    }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    return .{ .parents = classes.parents, .representatives = classes.representatives, .payloads = payloads.items };
}

fn seed(graph: *Graph, allocator: std.mem.Allocator) zx.Error!Self {
    var index: usize = 0;

    while (index < graph.nodes.len) : (index += 1) _ = try payload(graph, @fromBackingInt(@intCast(index)));

    const parents = try allocator.alloc(u32, graph.nodes.len);
    const representatives = try allocator.alloc(?u32, parents.len);

    for (parents, 0..) |*parent, item| parent.* = @intCast(item);

    @memset(representatives, null);

    const edges = graph.assignments.slice();

    for (edges.items(.value), edges.items(.expected)) |value, expected| {
        const left = root(parents, @backingInt(try payload(graph, value)));
        const right = root(parents, @backingInt(try payload(graph, expected)));

        parents[right] = left;
    }

    for (0..graph.nodes.len) |item| {
        const id: Graph.Id = @fromBackingInt(@intCast(item));
        const base = try payload(graph, id);
        const index_of_base = @backingInt(base);
        const rows = graph.nodes.slice();

        if (rows.items(.kind)[index_of_base] == .Unknown and rows.items(.facts)[index_of_base].allowed == null) continue;

        representatives[root(parents, @backingInt(base))] = @backingInt(base);
    }

    for (parents, 0..) |*parent, item| parent.* = root(parents, @intCast(item));

    return .{ .parents = parents, .representatives = representatives };
}

fn root(parents: []u32, index: u32) u32 {
    var current = index;

    while (parents[current] != current) {
        const grandparent = parents[parents[current]];

        parents[current] = grandparent;
        current = grandparent;
    }

    return current;
}

pub fn representative(self: Self, graph: *Graph, id: Graph.Id) zx.Error!?Graph.Id {
    return self.lookup(@backingInt(try payload(graph, id)));
}

/// Available to the Source solver while the graph revision still matches this assignment base.
pub fn stableRoot(self: Self, graph: *const Graph, id: Graph.Id) Graph.Id {
    return self.lookup(self.payloads[@backingInt(id)]) orelse graph.root(id);
}

fn lookup(self: Self, index: usize) ?Graph.Id {
    const value = self.representatives[self.parents[index]] orelse return null;

    return @fromBackingInt(value);
}

/// Unifies every root with its class representative in one pass instead of one pair per rebuilt base. A
/// representative whose payload changed during the pass waits for the next round's fresh base.
pub fn propagate(self: Self, graph: *Graph) zx.Error!void {
    for (0..self.parents.len) |index| {
        const id: Graph.Id = @fromBackingInt(@intCast(index));

        if (graph.root(id) != id) continue;

        const node = graph.nodeAt(index);

        if (node.shape == .optional or (node.shape == .known and graph.types.get(node.shape.known) == .optional)) continue;
        if (node.shape == .unknown and node.allowed == null) continue;

        const other = self.lookup(index) orelse continue;

        if (graph.root(other) == id) continue;
        if (try payload(graph, other) != graph.root(other)) continue;
        try graph.unify(id, other, node.span);
    }
}

pub const payload = @import("../optional.zig").payload;
