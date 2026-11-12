const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Plan = @import("plan.zig");
const seed = @import("fields/seed.zig");
const merge = @import("../unify.zig").merge;
const scratch_bytes = std.heap.page_size_min / 16;
const minimum_indexed_fields = 16;
const minimum_indexed_queries = 8;
const bucket_ratio = 2;

pub fn combine(graph: *Graph, left: Graph.Fields, right: Graph.Fields, span: zx.Span, depth: usize) zx.Error!Graph.Fields {
    if (left.len == 0) return right;
    if (right.len == 0) return left;
    if (!Plan.enabled) return seed.combine(graph, left, right, span, depth);

    var arena = std.heap.ArenaAllocator.init(graph.scratch);
    var buffer: [scratch_bytes]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const allocator = scratch.allocator();
    const positions = try allocator.alloc(u64, right.len);
    const length = try planPositions(allocator, left.names(), right.names(), positions, false);
    const values = left.values();

    for (right.values(), positions) |value, position| {
        if (position < left.len) try merge(graph, values[@intCast(position)], value, span, depth);
    }

    if (length == left.len) return left;

    const result = try Graph.Fields.init(graph.allocator, length);

    left.copyTo(result);

    for (right.names(), right.values(), positions) |name, value, position| {
        if (position >= left.len) result.set(@intCast(position), name, value);
    }

    return result;
}

pub fn applyKnown(graph: *Graph, inferred: Graph.Fields, known: zx.ir.TypeFields, span: zx.Span, depth: usize) zx.Error!void {
    if (inferred.len == 0) return;
    if (!Plan.enabled) return seed.applyKnown(graph, inferred, known, span, depth);

    var arena = std.heap.ArenaAllocator.init(graph.scratch);
    var buffer: [scratch_bytes]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const allocator = scratch.allocator();
    const positions = try allocator.alloc(u64, inferred.len);
    const matched = try planPositions(allocator, known.names[0..known.len], inferred.names(), positions, true);

    for (inferred.values()[0..matched], positions[0..matched]) |field, position| {
        const value = try graph.known(known.at(@intCast(position)).type_id, span);

        try merge(graph, field, value, span, depth);
    }

    if (matched != inferred.len) return graph.reporter.fail(.type_mismatch, span, "the complete input type does not contain a required field");
}

fn planPositions(allocator: std.mem.Allocator, existing: []const []const u8, incoming: []const []const u8, positions: []u64, closed: bool) std.mem.Allocator.Error!usize {
    const generated = @import("generated_rx_unification_fields");

    const capacity = if (existing.len >= minimum_indexed_fields and incoming.len >= minimum_indexed_queries)
        std.math.ceilPowerOfTwo(usize, std.math.mul(usize, existing.len, bucket_ratio) catch return error.OutOfMemory) catch return error.OutOfMemory

    else
        0;

    const buckets = try allocator.alloc(u64, capacity);

    defer allocator.free(buckets);
    @memset(buckets, 0);

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = generated.executeValue(empty.allocator(), .{
        .existing = .{ .names = existing, .keys = existing, .buckets = @ptrCast(&buckets), .capacity = capacity },
        .incoming = incoming,
        .positions = @ptrCast(&positions),
        .closed = closed,
    }) catch unreachable;

    return @intCast(if (closed) result.scanned else result.length);
}
