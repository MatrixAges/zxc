const std = @import("std");
const program = @import("program");

fn check(enabled: bool, values: []const u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .enabled = enabled, .values = values };

    if (expected) |value| {
        try std.testing.expectEqual(value, try program.execute(&arena, &input));
    } else try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &input));
}

test "RX unselected Case skips empty service argument" {
    try check(false, &.{}, 9);
}

test "RX unselected Case skips nonempty service argument" {
    try check(false, &.{7}, 9);
}

test "RX selected Case propagates service index error" {
    try check(true, &.{}, null);
}

test "RX selected Case preserves service zero result" {
    try check(true, &.{0}, 0);
}

test "RX selected Case preserves service maximum result" {
    try check(true, &.{std.math.maxInt(u64)}, std.math.maxInt(u64));
}
