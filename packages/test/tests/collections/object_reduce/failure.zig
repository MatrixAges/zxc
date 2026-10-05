const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

fn check(gpa: std.mem.Allocator) !void {
    var child: h.Child = .{ .value = 11 };
    var initial = h.seed(&child, &.{});
    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const result = h.program.execute(&arena, &.{ .seed = &initial, .steps = &.{1} }) catch |err| blk: {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.IndexOutOfBounds, err);

        break :blk null;
    };

    try std.testing.expect(result == null);
    try std.testing.expectEqual(@as(u64, 3), initial.count);
    try std.testing.expectEqual(@as(u64, 10), initial.total);

    initial.labels = &h.labels;

    const recovered = try h.program.execute(&arena, &.{ .seed = &initial, .steps = &.{1} });

    try std.testing.expectEqual(@as(u64, 4), recovered.count);
    try std.testing.expectEqual(@as(u64, 19), recovered.total);
}

test "object reduce index failure preserves seed and permits recovery" {
    try check(std.testing.allocator);
}

test "object reduce error and recovery release all failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{});
}
