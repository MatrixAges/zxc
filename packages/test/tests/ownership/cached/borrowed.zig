const std = @import("std");
const h = @import("check.zig");

test "cached borrowed direct none" {
    try h.run(.{ .shape = .borrowed, .mutation = .none, .nested = false });
}

test "cached borrowed direct duplicate_id" {
    try h.run(.{ .shape = .borrowed, .mutation = .duplicate_id, .nested = false });
}

test "cached borrowed direct duplicate_path" {
    try h.run(.{ .shape = .borrowed, .mutation = .duplicate_path, .nested = false });
}

test "cached borrowed direct swap" {
    try h.run(.{ .shape = .borrowed, .mutation = .swap, .nested = false });
}

test "cached borrowed nested none" {
    try h.run(.{ .shape = .borrowed, .mutation = .none, .nested = true });
}

test "cached borrowed nested duplicate_id" {
    try h.run(.{ .shape = .borrowed, .mutation = .duplicate_id, .nested = true });
}

test "cached borrowed nested duplicate_path" {
    try h.run(.{ .shape = .borrowed, .mutation = .duplicate_path, .nested = true });
}

test "cached borrowed nested swap" {
    try h.run(.{ .shape = .borrowed, .mutation = .swap, .nested = true });
}

test "cached borrowed none allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .borrowed, .mutation = .none, .nested = true }});
}

test "cached borrowed duplicate_path allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .borrowed, .mutation = .duplicate_path, .nested = true }});
}
