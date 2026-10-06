const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Pattern = enum { mixed, even, odd };

fn check(gpa: std.mem.Allocator, count: usize, pattern: Pattern) !void {
    const a = try std.testing.allocator.dupe(u64, &.{ 71, 83 });

    defer std.testing.allocator.free(a);

    const b = try std.testing.allocator.dupe(u64, &.{ 97, 101, 103 });

    defer std.testing.allocator.free(b);

    const steps = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(steps);

    var expected_a: std.ArrayList(u64) = .empty;
    var expected_b: std.ArrayList(u64) = .empty;

    defer expected_a.deinit(std.testing.allocator);
    defer expected_b.deinit(std.testing.allocator);

    try expected_a.appendSlice(std.testing.allocator, a);
    try expected_b.appendSlice(std.testing.allocator, b);

    for (steps, 0..) |*item, index| {
        item.* = switch (pattern) {
            .mixed => @intCast(index % 7),
            .even => 2,
            .odd => 3,
        };

        if (item.* % 2 == 0) {
            try expected_a.append(std.testing.allocator, item.*);
        } else {
            try expected_b.appendSlice(std.testing.allocator, &.{ item.*, item.* + 10 });
        }
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .a = a, .b = b, .steps = steps });

    try std.testing.expectEqualSlices(u64, &.{ 71, 83 }, a);
    try std.testing.expectEqualSlices(u64, &.{ 97, 101, 103 }, b);

    for (steps, 0..) |item, index| {
        const expected: u64 = switch (pattern) { .mixed => @intCast(index % 7), .even => 2, .odd => 3 };

        try std.testing.expectEqual(expected, item);
    }

    const result = try executed;

    try std.testing.expect(!@hasDecl(program, "consumes_input"));
    try std.testing.expectEqual(@as(u64, @intCast(count + 3)), result.count);
    try std.testing.expectEqualSlices(u64, expected_a.items, result.a);
    try std.testing.expectEqualSlices(u64, expected_b.items, result.b);
    try std.testing.expectEqual(expected_a.items.len == a.len, result.a.ptr == a.ptr);
    try std.testing.expectEqual(expected_b.items.len == b.len, result.b.ptr == b.ptr);
    try std.testing.expect(result.a.ptr != result.b.ptr);

    const limit = 8192 + (count + result.a.len + result.b.len) * 128;

    try std.testing.expect(arena.queryCapacity() <= limit);
    try std.testing.expect(tracked.allocated_bytes <= limit);
}

test "two list lanes preserve separate seeds and conditional first append" {
    for ([_]usize{ 0, 1, 2, 3, 37 }) |count| {
        for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try check(std.testing.allocator, count, pattern);
    }
}

test "two list lanes grow linearly without allocator resize" {
    for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try check(std.testing.allocator, 8192, pattern);
}

test "two list lanes clean every failure without altering foreign inputs" {
    for ([_]Pattern{ .mixed, .even, .odd }) |pattern| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as(usize, 37), pattern });
}
