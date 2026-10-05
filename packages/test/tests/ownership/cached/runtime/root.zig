const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "cached spread empty first field retains nonempty sibling" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "cached spread single elements" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "cached spread unequal lists remain independent" {
    try h.run(std.testing.allocator, .{ .count = 31 });
}

test "cached spread alternative branch preserves lists" {
    try h.run(std.testing.allocator, .{ .count = 31, .choice = false });
}

test "cached spread long lists preserve borrowed input" {
    try h.run(std.testing.allocator, .{ .count = 2048 });
}

test "cached spread equal contents do not imply shared ownership" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true });
}

test "cached spread runtime allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31 }});
}

test "cached spread alternative branch runtime allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31, .choice = false }});
}

comptime {
    _ = @import("isolation.zig");
}
