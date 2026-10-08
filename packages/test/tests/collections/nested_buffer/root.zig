const std = @import("std");
const check = @import("check.zig");
const allocation_testing = @import("allocation_testing");

test "nested buffer zero rounds preserve borrowed columns and marker identity" {
    for ([_]usize{ 0, 1, 3 }) |length| {
        for ([_]bool{ false, true }) |enabled| try check.run(std.testing.allocator, .{ .count = 0, .length = length, .enabled = enabled });
    }
}

test "nested buffer path reconstruction retains every value across growth" {
    for ([_]u64{ 1, 2, 3, 17, 65 }) |count| {
        for ([_]usize{ 0, 1, 3 }) |length| try check.run(std.testing.allocator, .{ .count = count, .length = length });
    }
}

test "inactive nested columns keep borrowed prefixes while other columns grow" {
    for ([_]u64{ 1, 3, 17 }) |count| try check.run(std.testing.allocator, .{ .count = count, .length = 3, .enabled = false });
}

test "nested buffer active paths clean every allocation failure" {
    for ([_]usize{ 0, 3 }) |length| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.run, .{check.Case{ .count = 3, .length = length }});
}

test "nested buffer inactive paths clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.run, .{check.Case{ .count = 3, .length = 3, .enabled = false }});
}
