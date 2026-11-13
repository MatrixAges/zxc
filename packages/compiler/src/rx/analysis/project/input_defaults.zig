const std = @import("std");
const zx = @import("zx");
const Graph = @import("../inference/types.zig");
const Edges = std.MultiArrayList(@import("../inference/assignment.zig").Edge).Slice;

pub fn apply(graph: *Graph, inputs: []const Graph.Id, fixed: []const bool, unused: usize) zx.Error!void {
    if (unused == 0) return;

    const edges = graph.pending.assignments.slice();

    if (!@import("rx_options").generated_graph) return seed(graph, inputs, fixed, edges);

    var scratch = std.heap.ArenaAllocator.init(graph.scratch);

    defer scratch.deinit();

    const indexed = unused > 1 and edges.len > graph.nodes.len / (unused - 1);
    const references = if (indexed) try mark(graph, edges, scratch.allocator()) else References{};
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    var start: usize = 0;
    const next = @import("generated_rx_next_input_default");

    while (start < inputs.len) {
        const result = next.executeState(empty.allocator(), .{
            .inputs = .{ .items = @ptrCast(inputs), .storage = .plain },
            .fixed = .{ .items = fixed, .storage = .plain },
            .edges = .{ .left = .{ .items = @ptrCast(edges.items(.value)), .storage = .plain }, .right = .{ .items = @ptrCast(edges.items(.expected)), .storage = .plain } },
            .parents = graph.forest.state,
            .marked = .{ .items = references.marked, .storage = .plain },
            .protected = references.protected,
            .next = start,
            .found = false,
        }) catch unreachable;

        std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

        if (!result.found) break;

        start = @intCast(result.next);

        try default(graph, inputs[start - 1]);
    }
}

const References = struct { marked: []const bool = &.{}, protected: ?u32 = null };

fn mark(graph: *const Graph, edges: Edges, scratch: std.mem.Allocator) zx.Error!References {
    const void_type = @import("frontend").types.scalarId(.void);

    const result = @import("generated_rx_input_default_marks").executeState(scratch, .{
        .edges = .{ .left = .{ .items = @ptrCast(edges.items(.value)), .storage = .plain }, .right = .{ .items = @ptrCast(edges.items(.expected)), .storage = .plain } },
        .parents = graph.forest.state,
        .kinds = .{ .items = graph.nodes.items(.kind), .storage = .plain },
        .marked = .{ .items = &.{}, .storage = .plain },
        .index = 0,
        .left = true,
    }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    const marked = result.marked.items;

    const protected: ?u32 = if (graph.pending.known_types.get(void_type)) |node| anchor: {
        if (marked[@backingInt(graph.root(node))]) break :anchor @backingInt(node);

        break :anchor null;
    } else null;

    return .{ .marked = marked, .protected = protected };
}

fn default(graph: *Graph, input: Graph.Id) zx.Error!void {
    const span = graph.nodes.items(.span)[@backingInt(input)];

    try graph.unify(input, try graph.scalar(.void, span), span);
}

fn seed(graph: *Graph, inputs: []const Graph.Id, fixed: []const bool, edges: Edges) zx.Error!void {
    for (inputs, fixed) |input, skip| {
        if (skip) continue;

        const root = graph.root(input);

        const referenced = for (edges.items(.value), edges.items(.expected)) |value, expected| {
            if (graph.root(value) == root or graph.root(expected) == root) break true;
        } else false;

        if (!referenced) try default(graph, input);
    }
}
