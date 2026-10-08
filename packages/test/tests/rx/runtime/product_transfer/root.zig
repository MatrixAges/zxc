const std = @import("std");
const h = @import("check.zig");
const allocation_testing = @import("allocation_testing");

test "product stages preserve full values and caller inputs across fixed writes" {
    for ([_]u64{ 0, 1, 3, 17, 65 }) |count| {
        for ([_]usize{ 1, 3, 17 }) |length| {
            for ([_]bool{ false, true }) |enabled| {
                for ([_]i64{ -2, 1 }) |delta| _ = try h.run(std.testing.allocator, .{ .count = count, .left_length = length, .right_length = length, .enabled = enabled, .delta = delta });
            }
        }
    }
}

test "asymmetric and empty products preserve explicit index boundaries" {
    for ([_][2]usize{ .{ 0, 0 }, .{ 0, 3 }, .{ 3, 0 }, .{ 1, 17 }, .{ 17, 1 } }) |lengths| {
        for ([_]u64{ 0, 1 }) |count| {
            for ([_]bool{ false, true }) |enabled| _ = try h.run(std.testing.allocator, .{ .count = count, .left_length = lengths[0], .right_length = lengths[1], .enabled = enabled });
        }
    }
}

test "selection checks follow the operations actually executed" {
    for ([_][2]u64{ .{ 3, 0 }, .{ 0, 3 }, .{ 3, 3 }, .{ 0, 2 } }) |indices| {
        for ([_]bool{ false, true }) |enabled| _ = try h.run(std.testing.allocator, .{ .count = 2, .left_length = 3, .right_length = 3, .left_index = indices[0], .right_index = indices[1], .enabled = enabled });
    }
}

test "earlier product outputs remain immutable across calls in one arena" {
    for ([_]bool{ false, true }) |enabled| _ = try h.run(std.testing.allocator, .{ .count = 3, .left_length = 17, .right_length = 17, .retain = true, .enabled = enabled });
}

test "product stages clean every allocation failure without changing caller inputs" {
    for ([_]bool{ false, true }) |enabled| {
        for ([_]bool{ false, true }) |forbid_resize| {
            try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failure, .{h.Case{ .count = 3, .left_length = 17, .right_length = 17, .enabled = enabled, .forbid_resize = forbid_resize }});
        }
    }
}

fn failure(memory: std.mem.Allocator, args: h.Case) !void {
    _ = try h.run(memory, args);
}
