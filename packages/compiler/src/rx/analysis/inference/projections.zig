const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const Access = @import("fields/access.zig");
const enabled = @import("rx_options").generated_graph;
const scan = if (enabled) @import("generated_rx_projection_scan") else void;
const Mode = if (enabled) @FieldType(std.meta.Child(scan.Input), "mode") else enum { Length, PendingLength, Index, DefaultIndex };
const Match = struct { row: usize, root: Graph.Id };

pub const Length = struct { target: Graph.Id, value: Graph.Id, span: zx.Span };

pub fn applyLengths(graph: *Graph) zx.Error!void {
    const lengths = graph.lengths.slice();
    const targets = lengths.items(.target);

    if (!enabled) {
        for (targets, 0..) |target, index| {
            const root = graph.root(target);

            if (graph.nodes.items(.kind)[@backingInt(root)] != .Unknown) try applyLength(graph, lengths.get(index), root);
        }

        return;
    }

    var start: usize = 0;

    while (next(graph, targets, &.{}, .Length, start)) |result| {
        try applyLength(graph, lengths.get(result.row), result.root);

        start = result.row + 1;
    }
}

pub fn validateLengths(graph: *Graph) zx.Error!void {
    const lengths = graph.lengths.slice();
    const targets = lengths.items(.target);

    const pending = if (enabled)
        if (next(graph, targets, &.{}, .PendingLength, 0)) |result| result.row else null

    else
        seedPending(graph, targets);

    const index = pending orelse return;

    return graph.reporter.fail(.type_mismatch, lengths.items(.span)[index], "length alone cannot determine whether the input is a list, string or object");
}

pub fn next(graph: *const Graph, targets: []const Graph.Id, resolved: []const bool, mode: Mode, start: usize) ?Match {
    if (start == targets.len) return null;

    const parents: []u32 = @constCast(graph.forest.state.items);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = scan.executeValue(empty.allocator(), .{
        .targets = @ptrCast(targets),
        .resolved = resolved,
        .kinds = graph.nodes.items(.kind),
        .parents = @ptrCast(&parents),
        .mode = mode,
        .start = start,
    }) catch unreachable;

    return if (result.found) .{ .row = @intCast(result.row), .root = @fromBackingInt(@intCast(result.root)) } else null;
}

fn applyLength(graph: *Graph, projection: Length, root: Graph.Id) zx.Error!void {
    const value = try Access.at(graph, projection.target, root, Access.length_name, projection.span);

    try graph.unify(value, projection.value, projection.span);
}

fn seedPending(graph: *const Graph, targets: []const Graph.Id) ?usize {
    for (targets, 0..) |target, index| {
        if (graph.shape(target) == .unknown) return index;
    }

    return null;
}
