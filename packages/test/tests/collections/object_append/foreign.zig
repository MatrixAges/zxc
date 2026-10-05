const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");

fn check(gpa: std.mem.Allocator, count: usize, empty_seed: bool) !void {
    const seed = try std.testing.allocator.alloc(u64, if (empty_seed) 0 else 3);

    defer std.testing.allocator.free(seed);

    for (seed, 0..) |*item, index| item.* = 71 + @as(u64, @intCast(index)) * 12;

    const steps = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = @intCast(index % 7);

    var input: std.meta.Child(program.Input) = .{ .seed = seed, .steps = steps };
    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &input);

    for (seed, 0..) |item, index| try std.testing.expectEqual(71 + @as(u64, @intCast(index)) * 12, item);
    for (steps, 0..) |item, index| try std.testing.expectEqual(@as(u64, @intCast(index % 7)), item);

    const result = try executed;

    try std.testing.expect(program.consumes_input);
    try std.testing.expectEqual(@as(u64, @intCast(count + 3)), result.count);
    try std.testing.expectEqual(@as(u64, @intCast(if (count == 0) 99 else seed.len + count - 1)), result.previous);
    try std.testing.expectEqual(seed.len + count, result.values.len);

    for (0..seed.len) |index| {
        const expected = 71 + @as(u64, @intCast(index)) * 12;

        try std.testing.expectEqual(expected, result.values[index]);
    }

    for (0..steps.len) |index| {
        const expected: u64 = @intCast(index % 7);

        try std.testing.expectEqual(expected, result.values[seed.len + index]);
    }

    if (seed.len > 0) {
        try std.testing.expectEqual(count == 0, result.values.ptr == seed.ptr);
    }

    const limit = 8192 + (count + result.values.len + seed.len) * 128;

    try std.testing.expect(arena.queryCapacity() <= limit);
    try std.testing.expect(tracked.allocated_bytes <= limit);
}

test "foreign seed remains intact and moves to output storage only on append" {
    for ([_]usize{ 0, 1, 2, 37, 257, 8192 }) |count| {
        for ([_]bool{ false, true }) |empty| try check(std.testing.allocator, count, empty);
    }
}

test "foreign seed remains valid with independent fixed output pool" {
    var storage: [512 * 1024]u8 = undefined;

    for ([_]usize{ 0, 1, 2048 }) |count| {
        var pool = std.heap.FixedBufferAllocator.init(&storage);

        try check(pool.allocator(), count, false);
    }
}

test "foreign seed survives every output allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as(usize, 37), false });
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as(usize, 37), true });
}
