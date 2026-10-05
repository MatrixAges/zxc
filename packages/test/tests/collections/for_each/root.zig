const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "forEach empty input" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "forEach single element" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "forEach two elements" {
    try h.run(std.testing.allocator, .{ .count = 2 });
}

test "forEach repeated elements and zero" {
    try h.run(std.testing.allocator, .{ .count = 17 });
}

test "forEach long input preserves all values" {
    try h.run(std.testing.allocator, .{ .count = 257 });
}

test "forEach resource policy matches callback allocations" {
    if (comptime h.isMode("scalar") or h.isMode("rows")) try h.run(std.testing.allocator, .{ .count = 257, .forbid_allocations = true }) else {
        try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 17 }});
    }
}

comptime {
    if (h.isMode("rows")) _ = @import("rows_test.zig");
}
