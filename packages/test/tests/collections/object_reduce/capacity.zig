const std = @import("std");
const h = @import("check.zig");

test "object reduce allocation remains bounded as source grows" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bound = true });
}

test "object reduce bounded allocation does not require in place resize" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try h.run(std.testing.allocator, .{ .count = count, .bound = true, .forbid_resize = true });
}
