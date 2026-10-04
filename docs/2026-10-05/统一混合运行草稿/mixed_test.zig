const std = @import("std");
const alpha = @import("alpha");
const beta = @import("beta");
const repeat = @import("repeat");

fn check(choose: bool, left: []const u64, right: []const u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const input: std.meta.Child(alpha.Input) = .{ .choose = choose, .left = left, .right = right };
    const before_left = try std.testing.allocator.dupe(u64, left);
    defer std.testing.allocator.free(before_left);
    const before_right = try std.testing.allocator.dupe(u64, right);
    defer std.testing.allocator.free(before_right);

    if (expected) |value| {
        try std.testing.expectEqual(value, try alpha.execute(&arena, &input));
        try std.testing.expectEqual(value, try repeat.execute(&arena, &input));
    } else {
        try std.testing.expectError(error.IndexOutOfBounds, alpha.execute(&arena, &input));
        try std.testing.expectError(error.IndexOutOfBounds, repeat.execute(&arena, &input));
    }

    try std.testing.expectEqualSlices(u64, before_left, left);
    try std.testing.expectEqualSlices(u64, before_right, right);
}

test "mixed RX skips unselected empty right array" {
    try check(true, &.{11}, &.{}, 13);
}

test "mixed RX skips unselected empty left array" {
    try check(false, &.{}, &.{41}, 43);
}

test "mixed RX selected empty left propagates index error" {
    try check(true, &.{}, &.{41}, null);
}

test "mixed RX selected empty right propagates index error" {
    try check(false, &.{11}, &.{}, null);
}

test "mixed RX selection depends on runtime inputs" {
    try check(true, &.{ 23, 29 }, &.{ 59, 61 }, 25);
    try check(false, &.{ 23, 29 }, &.{ 59, 61 }, 61);
}

test "mixed public ZX entry remains independent from RX input shape" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]u64{ 0, 1, 7, 65535 }) |value| try std.testing.expectEqual(value + 2, try beta.execute(&arena, value));
}

test "mixed failed RX call does not corrupt subsequent calls in same arena" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var input: std.meta.Child(alpha.Input) = .{ .choose = true, .left = &.{}, .right = &.{17} };
    try std.testing.expectError(error.IndexOutOfBounds, alpha.execute(&arena, &input));
    try std.testing.expectEqual(@as(u64, 19), try beta.execute(&arena, 17));
    input.choose = false;
    try std.testing.expectEqual(@as(u64, 19), try repeat.execute(&arena, &input));
    try std.testing.expectEqual(@as(u64, 19), try alpha.execute(&arena, &input));
}
