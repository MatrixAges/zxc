const std = @import("std");
const program = @import("program");
const Tracking = @import("tracking.zig");

test "RX Task input error still joins allocating sibling" {
    var values: [8192]u64 = @splat(7);
    const input: std.meta.Child(program.Input) = .{ .values = &values, .missing = &.{} };
    var tracking = Tracking{ .child = std.testing.allocator };
    var arena = std.heap.ArenaAllocator.init(tracking.allocator());

    defer arena.deinit();

    try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &input));
    try std.testing.expectEqual(@as(usize, 1), tracking.workers());
    for (values) |value| try std.testing.expectEqual(@as(u64, 7), value);
}

test "RX Task evaluated input temporary remains alive through join" {
    const input: std.meta.Child(program.Input) = .{ .values = &.{ 2, 5 }, .missing = &.{11} };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const output = try program.execute(&arena, &input);

    try std.testing.expectEqualSlices(u64, &.{ 3, 6 }, output.left);
    try std.testing.expectEqualSlices(u64, &.{12}, output.right);
}
