const std = @import("std");
const program = @import("program");
const host = @import("host");
const check = @import("capture_check");

test "capture returns the exact native success value" {
    try check.output(2, 2, 1);
}

test "capture handles NativeFailure as its declared member" {
    try check.output(0, 101, 1);
}

test "capture distinguishes MissingValue from NativeFailure" {
    try check.output(1, 102, 1);
}

test "direct scalar capture introduces no result wrapper allocation" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(failing.allocator());

    defer arena.deinit();
    host.reset();

    try std.testing.expectEqual(@as(u64, 2), try program.execute(&arena, 2));
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try std.testing.expect(!failing.has_induced_failure);
    try std.testing.expectEqual(@as(usize, 0), failing.allocated_bytes);
}
