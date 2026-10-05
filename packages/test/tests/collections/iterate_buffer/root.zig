const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const mode = @import("options").mode;

fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

fn run(allocator: std.mem.Allocator, count: usize, length: usize, enabled: bool) !usize {
    const values = try std.testing.allocator.alloc(i64, length);

    defer std.testing.allocator.free(values);

    for (values, 0..) |*value, index| value.* = @as(i64, @intCast(index % 13)) - 5;

    const initial: i64 = if (isMode("direct")) @as(i64, @intCast(64 - count)) else -5;

    values[0] = initial;
    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const actual = try program.execute(&arena, &.{ .values = values, .count = @intCast(count), .enabled = enabled });
    var increments: i64 = @intCast(count);
    var observed: i64 = 0;

    if (comptime isMode("branch")) increments = if (enabled and count > 3) @intCast(count - 3) else 0;

    if (comptime isMode("switch")) {
        increments = 0;

        for (0..count) |index| increments += switch (index % 3) {
            0 => @as(i64, 1),
            1 => 2,
            else => 0,
        };
    }

    if (comptime isMode("stale_branch") or isMode("stale_switch")) {
        increments = 0;

        for (0..count) |index| {
            observed += initial + increments;
            increments += if (comptime isMode("stale_branch")) @as(i64, @intCast(index % 2 + 1)) else @as(i64, @intCast(index % 3 + 1));
        }
    }

    try std.testing.expectEqual(length, actual.values.len);
    try std.testing.expectEqualSlices(i64, values, actual.original);
    try std.testing.expectEqual(values.ptr, actual.original.ptr);
    try std.testing.expectEqual(initial, values[0]);
    try std.testing.expectEqual(initial + increments, actual.values[0]);

    for (1..length) |index| {
        const expected = @as(i64, @intCast(index % 13)) - 5;

        try std.testing.expectEqual(expected, values[index]);
        try std.testing.expectEqual(expected, actual.values[index]);
    }

    const rounds: i64 = @intCast(count);

    const seen: i64 = blk: {
        if (comptime isMode("stale_local")) break :blk rounds * initial + @divTrunc(rounds * (rounds - 1), 2);
        if (comptime isMode("stale_branch") or isMode("stale_switch")) break :blk observed;
        if (comptime isMode("stale_state")) break :blk initial + if (count == 0) @as(i64, 0) else rounds - 1;
        if (comptime isMode("two_fields")) break :blk values[1] + 2 * rounds;

        break :blk 0;
    };

    try std.testing.expectEqual(seen, actual.seen);

    if (increments == 0) {
        try std.testing.expectEqual(values.ptr, actual.values.ptr);
    } else {
        try std.testing.expect(values.ptr != actual.values.ptr);
    }

    return tracked.allocated_bytes;
}

fn failures(allocator: std.mem.Allocator) !void {
    _ = try run(allocator, 4, 17, true);
}

test "iterate buffer preserves the zero step input without copying its list" {
    _ = try run(std.testing.allocator, 0, 17, true);
}

test "iterate buffer handles first and second writes" {
    for ([_]usize{ 1, 2 }) |count| _ = try run(std.testing.allocator, count, 17, true);
}

test "iterate buffer keeps inputs and stale versions intact across long execution" {
    for ([_]usize{ 17, 64 }) |count| _ = try run(std.testing.allocator, count, 257, true);
}

test "iterate buffer handles delayed writes and three step execution" {
    if (comptime isMode("branch")) {
        const bytes = try run(std.testing.allocator, 64, 65537, false);

        try std.testing.expect(bytes < 65537 * @sizeOf(i64));
    } else {
        _ = try run(std.testing.allocator, 3, 17, true);
    }
}

test "iterate buffer releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{});
}

test "safe static list paths avoid iteration proportional list copies" {
    if (comptime isMode("nested") or isMode("tuple")) {
        const bytes = try run(std.testing.allocator, 64, 65537, true);

        try std.testing.expect(bytes < 8 * 65537 * @sizeOf(i64));
    } else if (comptime isMode("stale_local") or isMode("stale_branch") or isMode("stale_switch") or isMode("stale_state")) {
        _ = try run(std.testing.allocator, 9, 257, true);
    } else {
        const short = try run(std.testing.allocator, 4, 257, true);
        const long = try run(std.testing.allocator, 64, 257, true);

        try std.testing.expectEqual(short, long);
    }
}
