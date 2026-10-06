const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");
const Pattern = enum { mixed, even, odd };

fn run(allocator: std.mem.Allocator, count: usize, pattern: Pattern, empty: bool) !void {
    const nodes = [_]host.HostNode{
        .{ .value = 7, .payload = "left" },
        .{ .value = 7, .payload = "right" },
        .{ .value = 7, .payload = "seed" },
    };

    const seed = [_]host.Node{ host.fromNode(&nodes[2]), host.fromNode(&nodes[0]), host.fromNode(&nodes[2]) };
    const a = try std.testing.allocator.dupe(host.Node, if (empty) &.{} else seed[0..2]);

    defer std.testing.allocator.free(a);

    const b = try std.testing.allocator.dupe(host.Node, if (empty) &.{} else &seed);

    defer std.testing.allocator.free(b);

    const steps = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(steps);

    var expected_a: std.ArrayList(host.Node) = .empty;
    var expected_b: std.ArrayList(host.Node) = .empty;

    defer expected_a.deinit(std.testing.allocator);
    defer expected_b.deinit(std.testing.allocator);

    try expected_a.appendSlice(std.testing.allocator, a);
    try expected_b.appendSlice(std.testing.allocator, b);

    for (steps, 0..) |*index, position| {
        index.* = switch (pattern) { .mixed => @intCast(position % 7), .even => 2, .odd => 3 };

        if (index.* % 2 == 0) {
            try expected_a.append(std.testing.allocator, host.fromNode(&nodes[0]));
        } else {
            try expected_b.appendSlice(std.testing.allocator, &.{ host.fromNode(&nodes[1]), host.fromNode(&nodes[0]) });
        }
    }

    const input: @typeInfo(program.Input).pointer.child = .{ .a = a, .b = b, .left = host.fromNode(&nodes[0]), .right = host.fromNode(&nodes[1]), .steps = steps };
    var tracked = std.testing.FailingAllocator.init(allocator, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();
    host.reset(0);

    const executed = program.execute(&arena, &input);

    try std.testing.expectEqualSlices(host.Node, if (empty) &.{} else seed[0..2], a);
    try std.testing.expectEqualSlices(host.Node, if (empty) &.{} else &seed, b);
    try support.expectOwner(.{ .value = 7, .payload = "left" }, nodes[0]);
    try support.expectOwner(.{ .value = 7, .payload = "right" }, nodes[1]);
    try support.expectOwner(.{ .value = 7, .payload = "seed" }, nodes[2]);

    for (steps, 0..) |index, position| {
        const expected: u64 = switch (pattern) { .mixed => @intCast(position % 7), .even => 2, .odd => 3 };

        try std.testing.expectEqual(expected, index);
    }

    const result = try executed;

    try std.testing.expect(!@hasDecl(program, "consumes_input"));
    try std.testing.expectEqual(@as(u64, @intCast(count)), result.count);
    try std.testing.expectEqualSlices(host.Node, expected_a.items, result.a);
    try std.testing.expectEqualSlices(host.Node, expected_b.items, result.b);
    try std.testing.expectEqual(expected_a.items.len == a.len, result.a.ptr == a.ptr);
    try std.testing.expectEqual(expected_b.items.len == b.len, result.b.ptr == b.ptr);
    try support.expectNode(&nodes[0], result.left);
    try support.expectNode(&nodes[1], result.right);
    try std.testing.expectEqual(@as(usize, 0), host.calls);
    if (result.a.len != 0 and result.b.len != 0) try std.testing.expect(result.a.ptr != result.b.ptr);

    const limit = 8192 + (count + result.a.len + result.b.len) * 128;

    try std.testing.expect(arena.queryCapacity() <= limit);
    try std.testing.expect(tracked.allocated_bytes <= limit);
}

test "native reference helper append preserves separate seeds and conditional first writes" {
    for ([_]usize{ 0, 1, 2, 3, 37 }) |count| {
        for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try run(std.testing.allocator, count, pattern, false);
    }
}

test "native reference helper append handles empty seeds and repeated leaf aliases" {
    for ([_]usize{ 0, 1, 2, 37 }) |count| {
        for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try run(std.testing.allocator, count, pattern, true);
    }
}

test "native reference helper append grows linearly without allocator resize" {
    for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try run(std.testing.allocator, 8192, pattern, false);
}

test "native reference helper append releases every failure and preserves both input lists" {
    for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ @as(usize, 37), pattern, false });
}
