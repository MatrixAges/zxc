const std = @import("std");
const program = @import("program");

fn run(gpa: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const failed = program.execute(&arena, &.{ .seed = &.{}, .steps = &.{4} });

    if (failed) |_| return error.ExpectedIndexFailure else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.IndexOutOfBounds, err);
    }

    const result = try program.execute(&arena, &.{ .seed = &.{71}, .steps = &.{ 4, 8 } });

    try std.testing.expectEqual(@as(u64, 5), result.count);
    try std.testing.expectEqual(@as(u64, 71), result.previous);
    try std.testing.expectEqualSlices(u64, &.{ 71, 4, 8 }, result.values);
}

test "append fallback index failure permits subsequent execution" {
    try run(std.testing.allocator);
}

test "append fallback error recovery allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{});
}
