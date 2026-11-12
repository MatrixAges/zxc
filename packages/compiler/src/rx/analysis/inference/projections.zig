const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const enabled = @import("rx_options").generated_graph;
const scan = if (enabled) @import("generated_rx_projection_scan") else void;
const Mode = if (enabled) @FieldType(std.meta.Child(scan.Input), "mode") else enum { Length, PendingLength, Index };

pub const Length = struct { target: Graph.Id, value: Graph.Id, span: zx.Span };

pub fn applyLengths(graph: *Graph) zx.Error!void {
    const lengths = graph.lengths.slice();
    const targets = lengths.items(.target);

    if (!enabled) {
        for (targets, 0..) |target, index| {
            if (graph.shape(target) != .unknown) try applyLength(graph, lengths.get(index));
        }

        return;
    }

    var start: usize = 0;

    while (next(graph, targets, &.{}, .Length, start)) |index| {
        try applyLength(graph, lengths.get(index));

        start = index + 1;
    }
}

pub fn validateLengths(graph: *Graph) zx.Error!void {
    const lengths = graph.lengths.slice();
    const targets = lengths.items(.target);
    const pending = if (enabled) next(graph, targets, &.{}, .PendingLength, 0) else seedPending(graph, targets);
    const index = pending orelse return;

    return graph.reporter.fail(.type_mismatch, lengths.items(.span)[index], "length alone cannot determine whether the input is a list, string or object");
}

pub fn next(graph: *const Graph, targets: []const Graph.Id, resolved: []const bool, mode: Mode, start: usize) ?usize {
    if (start == targets.len) return null;

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = scan.executeState(empty.allocator(), .{
        .targets = .{ .items = @ptrCast(targets), .storage = .plain },
        .resolved = .{ .items = resolved, .storage = .plain },
        .kinds = .{ .items = graph.nodes.items(.kind), .storage = .plain },
        .parents = graph.forest.state,
        .mode = mode,
        .next = start,
        .found = false,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return if (result.found) @intCast(result.next - 1) else null;
}

fn applyLength(graph: *Graph, projection: Length) zx.Error!void {
    const value = try graph.field(projection.target, "length", projection.span);

    try graph.unify(value, projection.value, projection.span);
}

fn seedPending(graph: *const Graph, targets: []const Graph.Id) ?usize {
    for (targets, 0..) |target, index| {
        if (graph.shape(target) == .unknown) return index;
    }

    return null;
}
