const std = @import("std");
const allocation_testing = @import("allocation_testing");
const check = @import("check.zig");

test "mixed products retain empty inputs and both conditional branches" {
    for ([_]bool{ false, true }) |choice| _ = try check.run(std.testing.allocator, .{ .length = 0, .choice = choice });
}

test "mixed products preserve first and later field versions" {
    for ([_]usize{ 1, 3, 17 }) |length| {
        for ([_]u64{ 0, 1, 2, 3, 4 }) |count| {
            for ([_]bool{ false, true }) |choice| _ = try check.run(std.testing.allocator, .{ .length = length, .count = count, .choice = choice });
        }
    }
}

test "mixed products preserve borrowed pointers and independent fresh values" {
    for ([_]bool{ false, true }) |choice| _ = try check.run(std.testing.allocator, .{ .length = 17, .count = 3, .choice = choice });
}

test "earlier mixed outputs survive later calls in the same arena" {
    for ([_]u64{ 2, 3, 17 }) |count| _ = try check.run(std.testing.allocator, .{ .length = 17, .count = count });
}

test "mixed products scale while retaining long caller inputs" {
    for ([_]usize{ 257, 4096 }) |length| _ = try check.run(std.testing.allocator, .{ .length = length, .count = 64, .choice = true });
}

test "mixed product source and retained outputs clean every allocation failure" {
    for ([_]bool{ false, true }) |choice| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{check.Case{ .length = 17, .count = 3, .choice = choice }});
}

test "mixed product fixed peak allocations do not grow with loop count" {
    const short = try check.run(std.testing.allocator, .{ .length = 17, .count = 3 });
    const long = try check.run(std.testing.allocator, .{ .length = 17, .count = 4096 });

    try std.testing.expectEqual(short, long);
}
