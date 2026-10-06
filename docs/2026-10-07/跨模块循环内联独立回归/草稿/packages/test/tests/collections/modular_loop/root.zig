const std = @import("std");
const run = @import("execution.zig").run;
const Case = @import("model.zig").Case;
const allocation_testing = @import("allocation_testing");

test "modular helpers preserve every zero step borrowed prefix" {
    for ([_]usize{ 0, 1, 17, 257 }) |frames| {
        for ([_]usize{ 0, 1, 17, 257 }) |columns| try run(std.testing.allocator, .{ .count = 0, .frames = frames, .columns = columns });
    }
}

test "modular helpers follow independent recurrences and retain earlier outputs" {
    for ([_]u64{ 1, 2, 3, 7, 16 }) |count| {
        for ([_]usize{ 0, 1, 17, 257 }) |frames| try run(std.testing.allocator, .{ .count = count, .frames = frames, .columns = 17 });
    }
}

test "reachable branches switch arms and repeated tuple calls preserve symbols" {
    for ([_]u64{ 0, 1, 2, std.math.maxInt(u64) }) |choice| {
        for ([_]usize{ 1, 3, 17 }) |frames| try run(std.testing.allocator, .{ .count = 8, .frames = frames, .columns = 1, .choice = choice });
    }
}

test "modular retained calls release every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 3, .frames = 17, .columns = 17, .choice = 1 }});
}

test "modular zero step owners release all initial allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 0, .frames = 257, .columns = 257 }});
}

test "modular empty frame paths release all growth and error allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 8, .frames = 0 }});
}
