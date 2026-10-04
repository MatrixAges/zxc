const std = @import("std");
const program = @import("program");

fn check(choose: bool, left: []const u64, right: []const u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .choose = choose, .left = left, .right = right };
    const left_before = try std.testing.allocator.dupe(u64, left);

    defer std.testing.allocator.free(left_before);

    const right_before = try std.testing.allocator.dupe(u64, right);

    defer std.testing.allocator.free(right_before);

    if (expected) |value| {
        try std.testing.expectEqual(value, try program.execute(&arena, &input));
    } else try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &input));

    try std.testing.expectEqualSlices(u64, left_before, left);
    try std.testing.expectEqualSlices(u64, right_before, right);
}

test "RX conditional argument skips empty right branch" {
    try check(true, &.{11}, &.{}, 12);
}

test "RX conditional argument skips empty left branch" {
    try check(false, &.{}, &.{41}, 42);
}

test "RX conditional argument evaluates empty left branch" {
    try check(true, &.{}, &.{41}, null);
}

test "RX conditional argument evaluates empty right branch" {
    try check(false, &.{11}, &.{}, null);
}

test "RX conditional argument chooses left runtime value" {
    try check(true, &.{ 23, 29 }, &.{ 59, 61 }, 24);
}

test "RX conditional argument chooses right runtime value" {
    try check(false, &.{ 23, 29 }, &.{ 59, 61 }, 60);
}
