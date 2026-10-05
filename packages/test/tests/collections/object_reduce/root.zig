const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "object reduce empty source preserves initial value" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "object reduce one step preserves borrowed fields" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "object reduce every new field observes old accumulator" {
    try h.run(std.testing.allocator, .{ .count = 2 });
}

test "object reduce mixed branch transitions retain values" {
    try h.run(std.testing.allocator, .{ .count = 31 });
}

test "object reduce long sequence keeps immutable seed" {
    try h.run(std.testing.allocator, .{ .count = 128 });
}

test "object reduce all zero steps preserve conditional initial alias" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true });
}

test "object reduce all failed allocations release the arena" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31 }});
}

test "object reduce zero branch allocation failures release the arena" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 32, .zeros = true }});
}

comptime {
    if (@import("options").bounded) _ = @import("capacity.zig");
    if (h.isMode("checked")) _ = @import("failure.zig");
}
