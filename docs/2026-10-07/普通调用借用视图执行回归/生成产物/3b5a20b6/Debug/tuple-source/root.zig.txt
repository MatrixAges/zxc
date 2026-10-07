const std = @import("std");
const model = @import("model.zig");
const execution = @import("execution.zig");
const allocation_testing = @import("allocation_testing");

test "zero reduce preserves all caller records strings and pointer slots" {
    for ([_]usize{ 0, 1, 17, 257 }) |seed| try execution.run(std.testing.allocator, .{ .count = 0, .seed = seed });
}

test "detached readers survive caller list growth and post-append old field use" {
    for ([_]usize{ 1, 17, 257 }) |seed| {
        for ([_]usize{ 1, 2, 3, 31, 257 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed = seed });
    }
}

test "repeated indexes and zero items keep exact order and optional branches" {
    for ([_]usize{ 1, 3, 17 }) |seed| {
        try execution.run(std.testing.allocator, .{ .count = 31, .seed = seed, .repeat = true });
        try execution.run(std.testing.allocator, .{ .count = 31, .seed = seed, .zeros = true });
    }
}

test "empty reader either preserves optional fallback or reports exact bounds" {
    for ([_]usize{ 1, 3, 17 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed = 0 });
}

test "eligible reader append storage stays bounded as inputs grow" {
    if (comptime model.isMode("reference") or model.isMode("reverse")) return;
    for ([_]usize{ 1024, 4096 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed = 17, .bounded = true });
}

test "nonempty caller repeated execution releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{model.Case{ .count = 17 }});
}

test "zero reduce then failing or optional later execution releases every allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{model.Case{ .count = 0, .seed = 0 }});
}

test "empty caller reader failure or optional growth releases every allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{model.Case{ .count = 9, .seed = 0 }});
}
