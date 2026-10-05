const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "loop returned list alias permits an empty untouched initial list" {
    _ = try h.run(std.testing.allocator, .{ .count = 0, .empty = true });
}

test "loop returned list alias stops before an invalid first write" {
    _ = try h.run(std.testing.allocator, .{ .count = 1, .empty = true });
}

test "loop returned list alias failure cleans every allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{h.Case{ .count = 1, .empty = true }});
}
