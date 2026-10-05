const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "flat value return empty reduce preserves seed identity" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "flat value return reads previous fields before replacement" {
    for ([_]usize{ 1, 2, 3, 31, 128 }) |count| try h.run(std.testing.allocator, .{ .count = count });
}

test "flat value return preserves present optional scalar" {
    for ([_]?u64{ 0, 29 }) |optional| try h.run(std.testing.allocator, .{ .count = 31, .optional = optional });
}

test "flat value return zero items retain correct branch behavior" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true });
}

test "flat value return allocation is bounded for long inputs" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bounded = true });
}

test "flat value return bound does not require allocator resize" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bounded = true, .forbid_resize = true });
}

test "flat value return frees every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31 }});
}

test "flat value return zero branch frees every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 32, .zeros = true }});
}
