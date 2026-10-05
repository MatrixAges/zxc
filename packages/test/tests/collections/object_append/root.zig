const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "append empty reduction preserves copied seed" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "append single step observes initial list" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "append two steps observe old lengths" {
    try h.run(std.testing.allocator, .{ .count = 2 });
}

test "append mixed skipped and active steps preserve order" {
    try h.run(std.testing.allocator, .{ .count = 37 });
}

test "append all zero branch sequence" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true });
}

test "append longer sequence preserves host inputs" {
    try h.run(std.testing.allocator, .{ .count = 257 });
}

test "append every allocation failure releases arena" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 37 }});
}

test "append skipped sequence allocation failures release arena" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 32, .zeros = true }});
}

comptime {
    if (std.mem.eql(u8, @import("options").mode, "index_read")) _ = @import("failure.zig");
    if (@import("options").bounded) _ = @import("capacity.zig");
}
