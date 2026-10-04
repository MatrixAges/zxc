const std = @import("std");
const program = @import("program");

fn check(value: ?u64, fallback: []const u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .value = value, .fallback = fallback };
    const before = try std.testing.allocator.dupe(u64, fallback);

    defer std.testing.allocator.free(before);

    if (expected) |result| {
        try std.testing.expectEqual(result, try program.execute(&arena, &input));
    } else try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &input));

    try std.testing.expectEqualSlices(u64, before, fallback);
}

test "RX coalesce preserves zero and skips empty fallback" {
    try check(0, &.{}, 0);
}

test "RX coalesce preserves value and skips empty fallback" {
    try check(41, &.{}, 41);
}

test "RX coalesce null evaluates fallback" {
    try check(null, &.{ 7, 9 }, 7);
}

test "RX coalesce null propagates empty fallback failure" {
    try check(null, &.{}, null);
}

test "RX coalesce accepts zero fallback value" {
    try check(null, &.{ 0, 3 }, 0);
}

test "RX coalesce preserves maximum over a different fallback" {
    try check(std.math.maxInt(u64), &.{7}, std.math.maxInt(u64));
}
