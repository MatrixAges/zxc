const std = @import("std");
const h = @import("check.zig");
const allocation_testing = @import("allocation_testing");

test "empty reduce never calls subject" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "zero arm calls subject once and keeps original alias" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "first update observes old accumulator" {
    try h.run(std.testing.allocator, .{ .count = 2 });
}

test "fallback and spread updates have distinct results" {
    try h.run(std.testing.allocator, .{ .count = 7 });
}

test "mixed subjects preserve exact call order and values" {
    try h.run(std.testing.allocator, .{ .count = 31 });
}

test "all zero subjects suppress patterns and values" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true });
}

test "effectful match allocation remains bounded as source grows" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bound = true });
}

test "bounded effectful match does not require in place resize" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bound = true, .forbid_resize = true });
}

test "mixed effectful branches release all failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31 }});
}

test "unchanged effectful branches release all failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 32, .zeros = true }});
}

comptime {
    _ = @import("failure.zig");
}
