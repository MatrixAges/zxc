const std = @import("std");
const model = @import("model.zig");
const execution = @import("execution.zig");
const allocation_testing = @import("allocation_testing");

test "zero reduce preserves caller records strings and pointer slots for view readers" {
    for ([_]usize{ 0, 1, 17, 257 }) |seed| try execution.run(std.testing.allocator, .{ .count = 0, .seed = seed });
}

test "borrowed call views preserve old elements and logical bounds after append" {
    for ([_]usize{ 1, 17, 257 }) |seed| {
        for ([_]usize{ 1, 2, 3, 31, 257 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed = seed });
    }
}

test "borrowed call views preserve repeated selections and zero input steps" {
    for ([_]usize{ 1, 3, 17 }) |seed| {
        try execution.run(std.testing.allocator, .{ .count = 31, .seed = seed, .repeat = true });
        try execution.run(std.testing.allocator, .{ .count = 31, .seed = seed, .zeros = true });
    }
}

test "empty call views report exact bounds and preserve caller storage" {
    for ([_]usize{ 1, 3, 17 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed = 0 });
}

test "borrowed call views and retained results survive large repeated growth" {
    for ([_]usize{ 1024, 4096 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed = 17 });
}

test "borrowed call views release every allocation failure during retained calls" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{model.Case{ .count = 17 }});
}

test "empty call views release every allocation in zero and failing execution" {
    for ([_]usize{ 0, 9 }) |count| {
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{model.Case{ .count = count, .seed = 0 }});
    }
}
