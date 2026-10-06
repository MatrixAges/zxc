const std = @import("std");
const program = @import("program");
const flat = @import("flat_input.zig");
const allocation_testing = @import("allocation_testing");

fn run(memory: std.mem.Allocator, count: u64, length: usize) !void {
    var seed: flat.Seed = .{};

    seed.init();

    var arena = std.heap.ArenaAllocator.init(memory);

    defer arena.deinit();

    const input: flat.Input = .{ .frames = seed.frames[0..length], .count = count };
    const result = program.execute(&arena, &input);

    try seed.unchanged();
    try std.testing.expectEqual(count, input.count);
    try std.testing.expectEqual(seed.frames[0..length].ptr, input.frames.ptr);
    try std.testing.expectEqual(length, input.frames.len);

    if (length == 0 and count > 0) {
        if (result) |_| return error.ExpectedBounds else |err| {
            if (err == error.OutOfMemory) return err;

            try std.testing.expectEqual(error.IndexOutOfBounds, err);
        }

        return;
    }

    const first = try result;
    const later = program.execute(&arena, &.{ .frames = seed.frames[0..length], .count = count + if (length == 0) @as(u64, 0) else 3 });

    try seed.unchanged();

    const second = try later;

    try std.testing.expectEqual(length, first.len);
    try std.testing.expectEqual(length, second.len);

    for (first, second, 0..) |before, after, index| {
        const old: u64 = @intCast(index * 7 + 5);
        const position: u64 = @intCast(index * 3 + 11);

        try std.testing.expectEqual(position, before.position);
        try std.testing.expectEqual(position, after.position);
        try std.testing.expectEqual(old + if (index == 0) count else 0, before.count);
        try std.testing.expectEqual(old + if (index == 0) count + 3 else 0, after.count);
    }
}

test "public aggregate lists retain zero step empty and nonempty results" {
    for ([_]usize{ 0, 1, 17 }) |length| try run(std.testing.allocator, 0, length);
}

test "public aggregate list contents remain valid across later calls in the same arena" {
    for ([_]u64{ 1, 2, 17 }) |count| try run(std.testing.allocator, count, 17);
}

test "public aggregate list bounds preserve the borrowed input" {
    try run(std.testing.allocator, 1, 0);
}

test "public aggregate lists release allocation failures in both retained calls" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ @as(u64, 3), @as(usize, 17) });
}

test "public zero step and failing results release all allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ @as(u64, 0), @as(usize, 17) });
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ @as(u64, 1), @as(usize, 0) });
}
