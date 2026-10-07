const std = @import("std");
const h = @import("check.zig");
const allocation_testing = @import("allocation_testing");

test "return origins preserve empty and nonempty values at zero rounds" {
    for ([_]bool{ false, true }) |enabled| {
        for ([_]usize{ 0, 17 }) |length| _ = try h.run(std.testing.allocator, .{ .count = 0, .length = length, .enabled = enabled });
    }
}

test "first and second writes preserve borrowed inputs and shared aliases" {
    for ([_]bool{ false, true }) |enabled| {
        for ([_]usize{ 1, 2 }) |count| _ = try h.run(std.testing.allocator, .{ .count = count, .length = 17, .enabled = enabled });
    }
}

test "all return branches preserve every value and native scalar call order" {
    for ([_]bool{ false, true }) |enabled| {
        for ([_]usize{ 8, 64 }) |count| _ = try h.run(std.testing.allocator, .{ .count = count, .length = 257, .enabled = enabled });
    }
}

test "empty returned lists retain checked write bounds" {
    for ([_]bool{ false, true }) |enabled| _ = try h.run(std.testing.allocator, .{ .count = 1, .length = 0, .enabled = enabled });
}

test "return origin loops work when backing resize is unavailable" {
    for ([_]bool{ false, true }) |enabled| _ = try h.run(std.testing.allocator, .{ .count = 64, .length = 2048, .enabled = enabled, .forbid_resize = true });
}

test "both return branches clean every allocation failure" {
    for ([_]bool{ false, true }) |enabled| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{enabled});
}
