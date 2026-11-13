const std = @import("std");
const Graph = @import("../types.zig");

pub const Snapshot = struct {
    keys: []const u32,
    buckets: []const u32,
    known: []const bool,
    sizes: []const u64,
    results: []const u64,
    offsets: []const u64,
    dependents: []const u64,
    pub fn position(self: *const Snapshot, id: Graph.Id) ?usize {
        const index = @import("generated_object_closure_index");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const result = index.executeIn(empty.allocator(), &.{
            .index = &.{ .count = self.keys.len, .keys = self.keys, .buckets = self.buckets },
            .key = @backingInt(id),
        }) catch unreachable;

        return if (result) |value| @intCast(value) else null;
    }
};

pub fn build(graph: *const Graph, allocator: std.mem.Allocator) std.mem.Allocator.Error!Snapshot {
    const roots = @import("generated_object_closure_roots");
    const layout = @import("generated_object_closure_layout");
    const rows = graph.nodes.slice();
    const constructions = graph.pending.constructions.slice();
    const parts = graph.pending.construction_parts.slice();
    const selections = graph.pending.selections.slice();

    const normalized = roots.executeState(allocator, .{
        .columns = &.{
            .construction_results = @ptrCast(constructions.items(.result)),
            .part_first = constructions.items(.first),
            .part_count = constructions.items(.count),
            .part_names = parts.items(.name),
            .part_values = @ptrCast(parts.items(.value)),
            .selection_results = @ptrCast(selections.items(.result)),
            .selection_sources = @ptrCast(selections.items(.source)),
        },
        .parents = graph.forest.state,
        .keys = .{ .items = &.{}, .storage = .plain },
        .buckets = .{ .items = &.{}, .storage = .plain },
        .sizes = .{ .items = &.{}, .storage = .plain },
        .results = .{ .items = &.{}, .storage = .plain },
        .sources = .{ .items = &.{}, .storage = .plain },
        .rule = 0,
        .part = 0,
        .end = 0,
        .first = 0,
        .open = false,
    }) catch |err| return failure(err);

    std.debug.assert(normalized.parents.items.ptr == graph.forest.state.items.ptr);

    const result = layout.executeValue(allocator, &.{
        .kinds = rows.items(.kind),
        .keys = normalized.keys.items,
        .sizes = normalized.sizes.items,
        .sources = normalized.sources.items,
    }) catch |err| return failure(err);

    return .{
        .keys = normalized.keys.items,
        .buckets = normalized.buckets.items,
        .known = result.known,
        .sizes = normalized.sizes.items,
        .results = normalized.results.items,
        .offsets = result.offsets,
        .dependents = result.dependents,
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
