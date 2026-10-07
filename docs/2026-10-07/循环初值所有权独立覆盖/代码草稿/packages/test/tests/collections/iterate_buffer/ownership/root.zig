const std = @import("std");
const h = @import("check.zig");
const allocation_testing = @import("allocation_testing");

test "empty owned initial values survive zero steps" {
    _ = try h.run(std.testing.allocator, .{ .count = 0, .length = 0 });
}

test "zero steps preserve fresh or borrowed initial values" {
    _ = try h.run(std.testing.allocator, .{ .count = 0, .length = 17 });
}

test "first and second writes preserve source and shared versions" {
    for ([_]usize{ 1, 2 }) |count| _ = try h.run(std.testing.allocator, .{ .count = count, .length = 17 });
}

test "long execution retains all nonselected values and original aliases" {
    for ([_]usize{ 17, 64 }) |count| _ = try h.run(std.testing.allocator, .{ .count = count, .length = 257 });
}

test "single execution region allocation does not grow with iteration count" {
    if (h.isMode("repeated")) {
        _ = try h.run(std.testing.allocator, .{ .count = 8, .length = 257 });
    } else {
        const short = try h.run(std.testing.allocator, .{ .count = 1, .length = 65537, .forbid_resize = true });
        const long = try h.run(std.testing.allocator, .{ .count = 64, .length = 65537, .forbid_resize = true });

        try std.testing.expectEqual(short.bytes, long.bytes);
        try std.testing.expectEqual(short.allocations, long.allocations);
    }
}

test "initial ownership works without in place resize" {
    _ = try h.run(std.testing.allocator, .{ .count = 8, .length = if (h.isMode("repeated")) 257 else 65537, .forbid_resize = true });
}

test "empty and filtered empty lists preserve checked update bounds" {
    _ = try h.run(std.testing.allocator, .{ .count = 1, .length = 0 });

    if (h.isMode("filter")) _ = try h.run(std.testing.allocator, .{ .count = 1, .length = 1 });
}

test "owned and shared loop initializers release every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{});
}
