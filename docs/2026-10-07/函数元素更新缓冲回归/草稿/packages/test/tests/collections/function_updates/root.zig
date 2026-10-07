const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "function updates: zero outer calls" {
    _ = try h.run(std.testing.allocator, .{ .outer = 0, .inner = 0 });
}

test "function updates: zero inner rounds" {
    _ = try h.run(std.testing.allocator, .{ .inner = 0 });
}

test "function updates: first write" {
    _ = try h.run(std.testing.allocator, .{ .outer = 1, .inner = 1 });
}

test "function updates: captures across second rounds" {
    _ = try h.run(std.testing.allocator, .{ .outer = 2, .inner = 2 });
}

test "function updates: distinct versions across many calls" {
    _ = try h.run(std.testing.allocator, .{ .outer = 17, .inner = 3 });
}

test "function updates: long inner loops" {
    _ = try h.run(std.testing.allocator, .{ .outer = 3, .inner = 257 });
}

test "function updates: negative increments and middle indices" {
    _ = try h.run(std.testing.allocator, .{ .selected = 8, .delta = -7 });
}

test "function updates: last valid element" {
    _ = try h.run(std.testing.allocator, .{ .selected = 16 });
}

test "function updates: disabled conditional writes" {
    _ = try h.run(std.testing.allocator, .{ .enabled = false });
}

test "function updates: empty lists without writes" {
    _ = try h.run(std.testing.allocator, .{ .length = 0, .inner = 0 });
}

test "function updates: empty list indexing errors" {
    _ = try h.run(std.testing.allocator, .{ .length = 0 });
}

test "function updates: indices past the last element" {
    _ = try h.run(std.testing.allocator, .{ .selected = 17 });
}

test "function updates: disabled out of bounds writes" {
    _ = try h.run(std.testing.allocator, .{ .selected = 17, .enabled = false });
}

test "function updates: rejected arena resizing" {
    _ = try h.run(std.testing.allocator, .{ .forbid_resize = true });
}

test "function updates clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{h.Case{ .outer = 4, .inner = 3 }});
}

test "function updates clean allocation failures without writes" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.failures, .{h.Case{ .inner = 0 }});
}

test "function updates preserve values with zero increments" {
    _ = try h.run(std.testing.allocator, .{ .delta = 0 });
}

test "function updates skip indexing with zero caller iterations" {
    _ = try h.run(std.testing.allocator, .{ .outer = 0, .inner = if (h.isMode("fallback")) 0 else 3, .length = 0 });
}

comptime {
    _ = @import("retained.zig");

    if (h.isMode("flat") or h.isMode("branch") or h.isMode("chain") or h.isMode("fallback") or h.isMode("mixed")) _ = @import("capacity.zig");
}
