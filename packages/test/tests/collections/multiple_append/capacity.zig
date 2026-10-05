const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "multiple append linear allocation across growing input" {
    for ([_]usize{ 128, 2048, 8192 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bounded = true });
}

test "multiple append linear allocation without in place resize" {
    for ([_]usize{ 128, 2048, 8192 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bounded = true, .forbid_resize = true });
}

test "multiple append empty seed grows correctly" {
    try h.run(std.testing.allocator, .{ .count = 37, .empty_seed = true });
}

test "multiple append empty seed and empty reduction" {
    try h.run(std.testing.allocator, .{ .count = 0, .empty_seed = true });
}

test "multiple append empty seed allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 37, .empty_seed = true }});
}

test "multiple append zero sequence capacity respects skipped branches" {
    try h.run(std.testing.allocator, .{ .count = 8192, .zeros = true, .bounded = true });
}
