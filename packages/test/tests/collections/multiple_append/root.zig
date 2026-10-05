const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "multiple append empty reduction preserves copied seed" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "multiple append single step observes initial list" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "multiple append two steps observe old lengths" {
    try h.run(std.testing.allocator, .{ .count = 2 });
}

test "multiple append mixed skipped and active steps preserve order" {
    try h.run(std.testing.allocator, .{ .count = 37 });
}

test "multiple append all zero branch sequence" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true });
}

test "multiple append longer sequence preserves host inputs" {
    try h.run(std.testing.allocator, .{ .count = 257 });
}

test "multiple append every allocation failure releases arena" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 37 }});
}

test "multiple append skipped sequence allocation failures release arena" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 32, .zeros = true }});
}

comptime {
    _ = @import("capacity.zig");
}
