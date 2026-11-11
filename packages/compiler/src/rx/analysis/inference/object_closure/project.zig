const std = @import("std");
const Graph = @import("../types.zig");
const Positions = std.AutoHashMapUnmanaged(Graph.Id, usize);

pub const Snapshot = struct {
    positions: Positions,
    known: []const bool,
    sizes: []const u64,
    results: []const u64,
    offsets: []const u64,
    dependents: []const u64,
};

pub fn build(graph: *const Graph, allocator: std.mem.Allocator) std.mem.Allocator.Error!Snapshot {
    var registry = Registry{};
    const count = graph.constructions.items.len + graph.selections.items.len;
    const sizes = try allocator.alloc(u64, count);
    const results = try allocator.alloc(u64, count);
    var dependencies: std.ArrayList(usize) = .empty;
    var rule: usize = 0;

    for (graph.constructions.items) |object| {
        results[rule] = try registry.register(graph, allocator, object.result);

        const start = dependencies.items.len;

        for (object.parts) |part| {
            if (part.name != null) continue;
            try dependencies.append(allocator, try registry.register(graph, allocator, part.value));
        }

        sizes[rule] = dependencies.items.len - start;
        rule += 1;
    }

    for (graph.selections.items) |selection| {
        results[rule] = try registry.register(graph, allocator, selection.result);

        try dependencies.append(allocator, try registry.register(graph, allocator, selection.source));

        sizes[rule] = 1;
        rule += 1;
    }

    const offsets = try allocator.alloc(u64, registry.known.items.len + 1);

    @memset(offsets, 0);

    for (dependencies.items) |node| offsets[node + 1] += 1;
    for (offsets[1..], offsets[0 .. offsets.len - 1]) |*end, start| end.* += start;

    const next = try allocator.dupe(u64, offsets[0 .. offsets.len - 1]);
    const dependents = try allocator.alloc(u64, dependencies.items.len);
    var edge: usize = 0;

    for (sizes, 0..) |size, owner| {
        const end = edge + @as(usize, @intCast(size));

        for (dependencies.items[edge..end]) |node| {
            dependents[@intCast(next[node])] = owner;

            next[node] += 1;
        }

        edge = end;
    }

    return .{
        .positions = registry.positions,
        .known = registry.known.items,
        .sizes = sizes,
        .results = results,
        .offsets = offsets,
        .dependents = dependents,
    };
}

const Registry = struct {
    positions: Positions = .empty,
    known: std.ArrayList(bool) = .empty,
    fn register(self: *Registry, graph: *const Graph, allocator: std.mem.Allocator, id: Graph.Id) std.mem.Allocator.Error!usize {
        const root = graph.root(id);
        const item = try self.positions.getOrPut(allocator, root);

        if (!item.found_existing) {
            item.value_ptr.* = self.known.items.len;

            try self.known.append(allocator, graph.nodes.items[@backingInt(root)].shape == .known);
        }

        return item.value_ptr.*;
    }
};
