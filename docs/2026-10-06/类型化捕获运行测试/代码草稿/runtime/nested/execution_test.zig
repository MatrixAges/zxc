const std = @import("std");
const program = @import("program");
const host = @import("host");
const check = @import("capture_check");

test "nested capture preserves an inner success result" {
    try check.output(2, 2, 1);
}

test "nested capture keeps NativeFailure inside the inner tuple" {
    try check.output(0, 0, 1);
}

test "nested capture keeps MissingValue inside the inner tuple" {
    try check.output(1, 0, 1);
}

test "outer capture handles inner tuple allocation failure" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(failing.allocator());

    defer arena.deinit();
    host.reset();

    try std.testing.expectEqual(@as(u64, 999), try program.execute(&arena, 2));
    try std.testing.expect(failing.has_induced_failure);
}
