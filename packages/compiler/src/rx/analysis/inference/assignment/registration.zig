const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const enabled = @import("rx_options").generated_graph;
const insert = if (enabled) @import("generated_rx_assignment_insert") else void;
const Inserted = if (enabled) @typeInfo(@typeInfo(@TypeOf(insert.executeState)).@"fn".return_type.?).error_union.payload else void;
const State = if (enabled) @FieldType(Inserted, "index") else std.AutoHashMapUnmanaged([2]Graph.Id, void);
const Self = @This();

index: State = if (enabled) .{
    .count = 0,
    .keys = .{ .items = &.{}, .storage = .plain },
    .buckets = .{ .items = &.{}, .storage = .plain },
} else .empty,
pub fn expect(graph: *Graph, value: Graph.Id, expected: Graph.Id, span: zx.Span) zx.Error!void {
    if (!enabled) return seed(graph, value, expected, span);

    const prepare = @import("generated_rx_assignment_prepare");
    const parents = graph.forest.state.items;
    var scratch = std.heap.FixedBufferAllocator.init(&.{});

    const plan = prepare.executeValue(scratch.allocator(), &.{
        .endpoints = &.{ .parents = @ptrCast(&parents), .left = @backingInt(value), .right = @backingInt(expected) },
        .index = &.{
            .count = graph.assignment_keys.index.count,
            .keys = graph.assignment_keys.index.keys.items,
            .buckets = graph.assignment_keys.index.buckets.items,
        },
        .needs_reserve = graph.assignments.len == graph.assignments.capacity,
    }) catch unreachable;

    if (plan.skip) return;

    try graph.assignments.ensureUnusedCapacity(graph.allocator, 1);

    const Parameter = @typeInfo(@TypeOf(insert.executeState)).@"fn".param_types[1].?;
    const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
    const input: Input = .{ .index = graph.assignment_keys.index, .key = plan.pair.key };

    const result = insert.executeState(graph.registration, if (@typeInfo(Parameter) == .pointer) &input else input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    graph.assignment_keys.index = result.index;

    if (!result.found) append(graph, @fromBackingInt(plan.pair.left), @fromBackingInt(plan.pair.right), span);
}

fn append(graph: *Graph, left: Graph.Id, right: Graph.Id, span: zx.Span) void {
    graph.assignments.appendAssumeCapacity(.{ .value = left, .expected = right, .span = span });

    graph.revision += 1;
}

fn seed(graph: *Graph, value: Graph.Id, expected: Graph.Id, span: zx.Span) zx.Error!void {
    const key = [2]Graph.Id{ graph.root(value), graph.root(expected) };

    if (key[0] == key[1] or graph.assignment_keys.index.contains(key)) return;
    try graph.assignments.ensureUnusedCapacity(graph.allocator, 1);
    try graph.assignment_keys.index.put(graph.registration, key, {});

    append(graph, key[0], key[1], span);
}
