const std = @import("std");
const h = @import("check.zig");

test "cached tuples direct none" {
    try h.run(.{ .shape = .tuples, .mutation = .none, .nested = false });
}

test "cached tuples direct duplicate_id" {
    try h.run(.{ .shape = .tuples, .mutation = .duplicate_id, .nested = false });
}

test "cached tuples direct duplicate_path" {
    try h.run(.{ .shape = .tuples, .mutation = .duplicate_path, .nested = false });
}

test "cached tuples direct swap" {
    try h.run(.{ .shape = .tuples, .mutation = .swap, .nested = false });
}

test "cached tuples nested none" {
    try h.run(.{ .shape = .tuples, .mutation = .none, .nested = true });
}

test "cached tuples nested duplicate_id" {
    try h.run(.{ .shape = .tuples, .mutation = .duplicate_id, .nested = true });
}

test "cached tuples nested duplicate_path" {
    try h.run(.{ .shape = .tuples, .mutation = .duplicate_path, .nested = true });
}

test "cached tuples nested swap" {
    try h.run(.{ .shape = .tuples, .mutation = .swap, .nested = true });
}

test "cached tuples none allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .tuples, .mutation = .none, .nested = true }});
}

test "cached tuples duplicate_path allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .tuples, .mutation = .duplicate_path, .nested = true }});
}
