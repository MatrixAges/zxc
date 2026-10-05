const std = @import("std");
const h = @import("check.zig");

test "append reduce bounds retained and total allocated bytes at increasing sizes" {
    for ([_]usize{ 256, 1024, 4096 }) |count| {
        try h.run(std.testing.allocator, .{ .count = count, .bound_capacity = true });
    }
}

test "append reduce keeps bounded capacity when allocator cannot grow in place" {
    for ([_]usize{ 256, 1024, 4096 }) |count| {
        try h.run(std.testing.allocator, .{ .count = count, .bound_capacity = true, .forbid_resize = true });
    }
}
