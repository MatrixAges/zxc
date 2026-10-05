const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "cached lists direct none" {
    try h.run(.{ .shape = .lists, .mutation = .none, .nested = false });
}

test "cached lists direct duplicate_id" {
    try h.run(.{ .shape = .lists, .mutation = .duplicate_id, .nested = false });
}

test "cached lists direct duplicate_path" {
    try h.run(.{ .shape = .lists, .mutation = .duplicate_path, .nested = false });
}

test "cached lists direct swap" {
    try h.run(.{ .shape = .lists, .mutation = .swap, .nested = false });
}

test "cached lists nested none" {
    try h.run(.{ .shape = .lists, .mutation = .none, .nested = true });
}

test "cached lists nested duplicate_id" {
    try h.run(.{ .shape = .lists, .mutation = .duplicate_id, .nested = true });
}

test "cached lists nested duplicate_path" {
    try h.run(.{ .shape = .lists, .mutation = .duplicate_path, .nested = true });
}

test "cached lists nested swap" {
    try h.run(.{ .shape = .lists, .mutation = .swap, .nested = true });
}

test "cached lists none allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .lists, .mutation = .none, .nested = true }});
}

test "cached lists duplicate_path allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .lists, .mutation = .duplicate_path, .nested = true }});
}
