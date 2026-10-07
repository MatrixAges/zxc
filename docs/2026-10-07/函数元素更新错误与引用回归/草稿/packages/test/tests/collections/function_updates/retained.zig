const std = @import("std");
const program = @import("program");

test "function updates retain earlier outputs across calls in one arena" {
    var first_values = [_]i64{ -5, 3, 9 };
    var second_values = [_]i64{ 20, 21, 22 };
    const first_input: std.meta.Child(program.Input) = .{ .values = &first_values, .outer = 3, .inner = 2, .selected = 0, .delta = 1, .enabled = true };
    const second_input: std.meta.Child(program.Input) = .{ .values = &second_values, .outer = 4, .inner = 3, .selected = 1, .delta = -2, .enabled = true };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, &first_input);
    const saved_values = try std.testing.allocator.dupe(i64, first.values);

    defer std.testing.allocator.free(saved_values);

    const saved_mirror = try std.testing.allocator.dupe(i64, first.mirror);

    defer std.testing.allocator.free(saved_mirror);

    const saved_seen = first.seen;
    const saved_steps = first.steps;

    _ = try program.execute(&arena, &second_input);

    try std.testing.expectEqualSlices(i64, saved_values, first.values);
    try std.testing.expectEqualSlices(i64, saved_mirror, first.mirror);
    try std.testing.expectEqual(saved_seen, first.seen);
    try std.testing.expectEqual(saved_steps, first.steps);
    try std.testing.expectEqualSlices(i64, &.{ -5, 3, 9 }, &first_values);
    try std.testing.expectEqualSlices(i64, &.{ 20, 21, 22 }, &second_values);
}
