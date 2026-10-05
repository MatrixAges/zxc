const std = @import("std");
const h = @import("check.zig");

fn run(gpa: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const first = try h.program.execute(&arena, &.{ .first = &.{ 7, 11 }, .second = &.{13}, .choice = true });
    const second = try h.program.execute(&arena, &.{ .first = &.{17}, .second = &.{ 19, 23, 29 }, .choice = false });

    try std.testing.expectEqualSlices(u64, &.{ 7, 11 }, first.first);
    try std.testing.expectEqualSlices(u64, &.{13}, first.second);
    try std.testing.expectEqualSlices(u64, &.{17}, second.first);
    try std.testing.expectEqualSlices(u64, &.{ 19, 23, 29 }, second.second);
    try std.testing.expect(first != second);
}

test "cached spread separate invocations retain earlier result" {
    try run(std.testing.allocator);
}

test "cached spread repeated invocations allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{});
}
