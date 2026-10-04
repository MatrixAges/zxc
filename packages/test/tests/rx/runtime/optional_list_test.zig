const std = @import("std");
const program = @import("program");

fn check(items: ?[]const u64, groups: []const []const u64, index: u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .items = items, .groups = groups, .index = index };
    const before = try arena.allocator().alloc([]const u64, groups.len);

    for (groups, before) |group, *copy| copy.* = try arena.allocator().dupe(u64, group);

    const items_before = if (items) |value| try arena.allocator().dupe(u64, value) else null;

    if (expected) |value| {
        try std.testing.expectEqual(value, try program.execute(&arena, &input));
    } else try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &input));

    for (groups, before) |group, copy| try std.testing.expectEqualSlices(u64, copy, group);

    if (items_before) |copy| try std.testing.expectEqualSlices(u64, copy, items.?);
}

test "RX empty optional list skips missing fallback group" {
    try check(&.{}, &.{}, 0, 0);
}

test "RX present optional list skips maximum fallback index" {
    try check(&.{ 4, 5 }, &.{}, std.math.maxInt(u64), 2);
}

test "RX null list selects nonempty fallback" {
    try check(null, &.{&.{ 3, 4, 5 }}, 0, 3);
}

test "RX null list selects empty fallback" {
    try check(null, &.{&.{}}, 0, 0);
}

test "RX null list propagates missing fallback group" {
    try check(null, &.{}, 0, null);
}

test "RX null list uses dynamic second fallback group" {
    try check(null, &.{ &.{1}, &.{ 2, 3 } }, 1, 2);
}

test "RX null list propagates past end fallback index" {
    try check(null, &.{&.{1}}, 1, null);
}
