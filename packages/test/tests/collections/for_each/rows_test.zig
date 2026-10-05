const std = @import("std");
const h = @import("check.zig");

test "forEach evaluates the first callback even though its result is discarded" {
    try h.run(std.testing.allocator, .{ .count = 3, .empty_row = 0, .forbid_allocations = true });
}

test "forEach propagates later callback failures" {
    for ([_]usize{ 1, 8, 16 }) |index| try h.run(std.testing.allocator, .{ .count = 17, .empty_row = index, .forbid_allocations = true });
}
