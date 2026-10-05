const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "loop aggregate calls preserve the initial value at zero steps" {
    _ = try h.run(std.testing.allocator, .{ .count = 0 });
}

test "loop aggregate calls retain a returned old alias after one update" {
    _ = try h.run(std.testing.allocator, .{ .count = 1 });
}

test "loop aggregate calls retain distinct aliases after two updates" {
    _ = try h.run(std.testing.allocator, .{ .count = 2 });
}

test "loop aggregate calls survive repeated temporary views" {
    _ = try h.run(std.testing.allocator, .{ .count = 17 });
}

test "loop aggregate calls preserve long sequences" {
    _ = try h.run(std.testing.allocator, .{ .count = 257 });
}

test "loop aggregate calls preserve negative initial values" {
    _ = try h.run(std.testing.allocator, .{ .count = 3, .start = -100000 });
}

test "loop aggregate calls clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{h.Case{ .count = 17 }});
}

test "loop aggregate calls clean zero step allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{h.Case{ .count = 0 }});
}

comptime {
    if (@import("options").bounded) _ = @import("capacity.zig");
    if (h.isMode("list_alias")) _ = @import("failure.zig");
}
