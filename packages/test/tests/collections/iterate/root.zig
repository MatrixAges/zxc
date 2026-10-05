const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const mode = @import("options").mode;

fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

fn run(allocator: std.mem.Allocator, count: usize) !usize {
    var tracked = std.testing.FailingAllocator.init(allocator, .{ .fail_index = if (isMode("next") or isMode("do")) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    if (comptime isMode("next") or isMode("do")) {
        const input: u64 = @intCast(count);
        const expected: u64 = if (comptime isMode("next")) @max(input, 4096) else @max(input + 1, 4096);

        try std.testing.expectEqual(expected, try program.execute(&arena, input));
        try std.testing.expectEqual(@as(usize, 0), arena.queryCapacity());
        try std.testing.expect(!tracked.has_induced_failure);
    } else if (comptime isMode("snapshot")) {
        const input: std.meta.Child(program.Input) = .{ .count = @intCast(count), .start = 7 };
        const actual = try program.execute(&arena, &input);
        var total: u64 = 7;
        var previous: u64 = 7;

        for (1..count + 1) |index| {
            previous = total;
            total += @intCast(index);
            total += if (index % 2 == 0) @as(u64, 2) else 1;

            total += switch (index % 3) {
                0 => @as(u64, 3),
                1 => 4,
                else => 5,
            };
        }

        try std.testing.expectEqual(@as(u64, 7), input.start);
        try std.testing.expectEqual(@as(u64, 0), actual.initial.index);
        try std.testing.expectEqual(@as(u64, 7), actual.initial.total);
        try std.testing.expectEqual(@as(u64, 7), actual.initial.previous);
        try std.testing.expectEqual(@as(u64, @intCast(count)), actual.result.index);
        try std.testing.expectEqual(total, actual.result.total);
        try std.testing.expectEqual(previous, actual.result.previous);
    } else {
        const values = try std.testing.allocator.alloc(i64, count);

        defer std.testing.allocator.free(values);

        for (values, 0..) |*value, index| value.* = @as(i64, @intCast(index % 9)) - 4;

        const actual = try program.execute(&arena, &.{ .values = values, .delta = -3, .count = @intCast(count) });
        var total: i64 = 0;

        try std.testing.expectEqualSlices(i64, values, actual.original);
        try std.testing.expectEqual(count, actual.values.len);

        for (values, actual.values, 0..) |original, updated, index| {
            try std.testing.expectEqual(@as(i64, @intCast(index % 9)) - 4, original);
            try std.testing.expectEqual(original - 3, updated);

            total += original - 3;
        }

        try std.testing.expectEqual(total, actual.total);
        try std.testing.expectEqual(if (count == 0) @as(i64, 0) else values[count - 1], actual.previous);
    }

    return tracked.allocated_bytes;
}

fn failures(allocator: std.mem.Allocator) !void {
    _ = try run(allocator, 17);
}

test "loop zero initial count" {
    _ = try run(std.testing.allocator, 0);
}

test "loop one and two state transitions" {
    for ([_]usize{ 1, 2 }) |count| _ = try run(std.testing.allocator, count);
}

test "loop ordered state snapshots across branches" {
    _ = try run(std.testing.allocator, 17);
}

test "loop long execution and boundary inputs" {
    if (comptime isMode("next") or isMode("do")) {
        for ([_]usize{ 4095, 4096, 4097, 8192 }) |count| _ = try run(std.testing.allocator, count);
    } else _ = try run(std.testing.allocator, 257);
}

test "loop cleans every allocation failure or needs no allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{});
}

test "pure flat state has allocation cost independent of iteration count" {
    if (comptime isMode("snapshot")) {
        const short = try run(std.testing.allocator, 1);
        const long = try run(std.testing.allocator, 4096);

        try std.testing.expectEqual(short, long);
    } else {
        _ = try run(std.testing.allocator, 0);
    }
}
