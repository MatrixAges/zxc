const std = @import("std");
const h = @import("check.zig");

test "reduce empty source and seed" {
    try h.run(std.testing.allocator, .{ .count = 0, .seed = false });
}

test "reduce empty source populated seed" {
    try h.run(std.testing.allocator, .{ .count = 0 });
}

test "reduce single step empty seed" {
    try h.run(std.testing.allocator, .{ .count = 1, .seed = false });
}

test "reduce single step populated seed" {
    try h.run(std.testing.allocator, .{ .count = 1 });
}

test "reduce two ordered steps" {
    try h.run(std.testing.allocator, .{ .count = 2 });
}

test "reduce seven branch transitions" {
    try h.run(std.testing.allocator, .{ .count = 7 });
}

test "reduce duplicates and zero" {
    try h.run(std.testing.allocator, .{ .count = 31 });
}

test "reduce long sequence" {
    try h.run(std.testing.allocator, .{ .count = 128 });
}

test "reduce all disabled branches" {
    try h.run(std.testing.allocator, .{ .count = 32, .disabled = true });
}

test "reduce empty append rows" {
    try h.run(std.testing.allocator, .{ .count = 32, .empty_rows = true });
}

test "reduce allocation failures release every arena" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 128 }});
}

test "reduce disabled steps and empty rows clean allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 32, .disabled = true, .empty_rows = true }});
}

test "reduce allocation failure with relocation releases every arena" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 128, .forbid_resize = true }});
}

comptime {
    if (!h.isMode("condition") and !h.isMode("argument") and !h.isMode("first_value") and !h.isMode("stack")) {
        _ = @import("capacity.zig");
    }
}
