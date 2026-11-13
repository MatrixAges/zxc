const std = @import("std");
const Graph = @import("../types.zig");
const enabled = @import("rx_options").generated_graph;
const status_rule = if (enabled) @import("generated_rx_binding_status") else void;
const pair_rule = if (enabled) @import("generated_rx_binding_pair") else void;
const uses_rule = if (enabled) @import("generated_rx_binding_uses") else void;
pub const Status = if (enabled) status_rule.Output else enum { Void, Pending, Value };
pub const Collision = if (enabled) pair_rule.Output else enum { Ignore, Defer, Conflict };
pub const Selection = struct { value: ?Graph.Id = null, multiple: bool = false };

pub fn view(comptime Entry: type, graph: *const Graph) std.meta.Child(@FieldType(std.meta.Child(@FieldType(std.meta.Child(Entry.Input), "topology")), "graph")) {
    const rows = graph.nodes.slice();

    return .{ .kinds = rows.items(.kind), .arguments = rows.items(.argument) };
}

pub fn status(graph: *const Graph, id: Graph.Id) Status {
    if (!enabled) {
        const index = @backingInt(graph.root(id));
        const kind = graph.nodes.items(.kind)[index];
        const argument = graph.nodes.items(.argument)[index];

        if (kind == .Unknown) return .Pending;
        if (kind == .Known and argument == @backingInt(@import("frontend").types.scalarId(.void))) return .Void;

        return .Value;
    }

    const parents: []u32 = @constCast(graph.forest.state.items);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return status_rule.executeIn(empty.allocator(), &.{
        .topology = &.{ .graph = &view(status_rule, graph), .parents = @ptrCast(&parents) },
        .value = @backingInt(id),
    }) catch unreachable;
}

pub fn pair(graph: *const Graph, left: Graph.Id, right: Graph.Id, final: bool) Collision {
    if (!enabled) {
        const first = status(graph, left);

        if (first == .Void) return .Ignore;

        const second = status(graph, right);

        if (second == .Void) return .Ignore;

        return if (final or (first == .Value and second == .Value)) .Conflict else .Defer;
    }

    const parents: []u32 = @constCast(graph.forest.state.items);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return pair_rule.executeIn(empty.allocator(), &.{
        .topology = &.{ .graph = &view(pair_rule, graph), .parents = @ptrCast(&parents) },
        .left = @backingInt(left),
        .right = @backingInt(right),
        .final = final,
    }) catch unreachable;
}

pub fn missing(graph: *const Graph, values: []const Graph.Id) ?usize {
    if (values.len == 0) return null;

    if (!enabled) {
        for (values, 0..) |value, index| {
            if (status(graph, value) == .Void) return index;
        }

        return null;
    }

    const parents: []u32 = @constCast(graph.forest.state.items);
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = uses_rule.executeIn(empty.allocator(), &.{
        .topology = &.{ .graph = &view(uses_rule, graph), .parents = @ptrCast(&parents) },
        .values = @ptrCast(values),
    }) catch unreachable;

    return @intCast(result orelse return null);
}

pub fn selectSeed(graph: *const Graph, candidates: []const Graph.Id) Selection {
    var result: Selection = .{};

    for (candidates) |candidate| {
        if (status(graph, candidate) == .Void) continue;
        if (result.value != null) result.multiple = true;

        result.value = candidate;
    }

    return result;
}
