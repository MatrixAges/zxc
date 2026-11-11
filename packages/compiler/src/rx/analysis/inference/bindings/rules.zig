const std = @import("std");
const Graph = @import("../types.zig");
const enabled = @import("rx_options").generated_graph;
const status_rule = if (enabled) @import("generated_rx_binding_status") else void;
const pair_rule = if (enabled) @import("generated_rx_binding_pair") else void;
const uses_rule = if (enabled) @import("generated_rx_binding_uses") else void;
const View = if (enabled) std.meta.Child(@FieldType(std.meta.Child(uses_rule.Input), "graph")) else void;
pub const Status = if (enabled) status_rule.Output else enum { Void, Pending, Value };
pub const Collision = if (enabled) @FieldType(std.meta.Child(pair_rule.Output), "route") else enum { Ignore, Defer, Conflict };
pub const Selection = struct { value: ?Graph.Id = null, multiple: bool = false };

pub fn status(graph: *const Graph, id: Graph.Id) Status {
    const index = @backingInt(graph.root(id));
    const rows = graph.nodes.slice();
    const kind = rows.items(.kind)[index];
    const argument = rows.items(.argument)[index];

    if (!enabled) {
        if (kind == .Unknown) return .Pending;
        if (kind == .Known and argument == @backingInt(@import("frontend").types.scalarId(.void))) return .Void;

        return .Value;
    }

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return status_rule.executeIn(empty.allocator(), &.{ .kind = kind, .argument = argument }) catch unreachable;
}

pub fn pair(graph: *const Graph, left: Graph.Id, right: Graph.Id, final: bool) Collision {
    if (!enabled) {
        const first = status(graph, left);

        if (first == .Void) return .Ignore;

        const second = status(graph, right);

        if (second == .Void) return .Ignore;

        return if (final or (first == .Value and second == .Value)) .Conflict else .Defer;
    }

    const view = topology(graph);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = pair_rule.executeState(empty.allocator(), .{
        .graph = &view,
        .parents = graph.forest.state,
        .left = @backingInt(left),
        .right = @backingInt(right),
        .final = final,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return result.route;
}

pub fn missing(graph: *const Graph, values: []const Graph.Id) ?usize {
    if (values.len == 0) return null;

    if (!enabled) {
        for (values, 0..) |value, index| {
            if (status(graph, value) == .Void) return index;
        }

        return null;
    }

    const view = topology(graph);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = uses_rule.executeState(empty.allocator(), .{
        .graph = &view,
        .parents = graph.forest.state,
        .values = .{ .items = @ptrCast(values), .storage = .plain },
        .index = 0,
        .position = null,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return if (result.position) |position| @intCast(position) else null;
}

pub fn conflict(graph: *const Graph, left: []const Graph.Id, right: []const Graph.Id, final: bool) ?usize {
    if (left.len == 0) return null;

    if (!enabled) {
        for (left, right, 0..) |first, second, index| {
            if (pair(graph, first, second, final) == .Conflict) return index;
        }

        return null;
    }

    const view = topology(graph);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = @import("generated_rx_binding_collisions").executeState(empty.allocator(), .{
        .graph = &view,
        .parents = graph.forest.state,
        .left = .{ .items = @ptrCast(left), .storage = .plain },
        .right = .{ .items = @ptrCast(right), .storage = .plain },
        .final = final,
        .index = 0,
        .position = null,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return if (result.position) |position| @intCast(position) else null;
}

pub fn select(graph: *const Graph, candidates: []const Graph.Id) Selection {
    if (!enabled) {
        var result: Selection = .{};

        for (candidates) |candidate| {
            if (status(graph, candidate) == .Void) continue;
            if (result.value != null) result.multiple = true;

            result.value = candidate;
        }

        return result;
    }

    const view = topology(graph);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = @import("generated_rx_binding_lookup").executeState(empty.allocator(), .{
        .graph = &view,
        .parents = graph.forest.state,
        .candidates = .{ .items = @ptrCast(candidates), .storage = .plain },
        .index = 0,
        .selected = null,
        .multiple = false,
    }) catch unreachable;

    std.debug.assert(result.parents.items.ptr == graph.forest.state.items.ptr);

    return .{ .value = if (result.selected) |selected| @fromBackingInt(selected) else null, .multiple = result.multiple };
}

fn topology(graph: *const Graph) View {
    const rows = graph.nodes.slice();

    return .{ .kinds = rows.items(.kind), .arguments = rows.items(.argument) };
}
