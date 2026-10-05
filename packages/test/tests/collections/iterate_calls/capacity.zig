const std = @import("std");
const h = @import("check.zig");

test "borrowed aggregate call views do not allocate per iteration" {
    const short = try h.run(std.testing.allocator, .{ .count = 1 });
    const long = try h.run(std.testing.allocator, .{ .count = 4096 });

    try std.testing.expectEqual(short, long);
}

test "borrowed aggregate call views do not depend on allocator resize" {
    const short = try h.run(std.testing.allocator, .{ .count = 1, .forbid_resize = true });
    const long = try h.run(std.testing.allocator, .{ .count = 4096, .forbid_resize = true });

    try std.testing.expectEqual(short, long);
}
