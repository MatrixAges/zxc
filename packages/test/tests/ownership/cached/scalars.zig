const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "cached scalars direct none" {
    try h.run(.{ .shape = .scalars, .mutation = .none, .nested = false });
}

test "cached scalars direct duplicate_id" {
    try h.run(.{ .shape = .scalars, .mutation = .duplicate_id, .nested = false });
}

test "cached scalars direct duplicate_path" {
    try h.run(.{ .shape = .scalars, .mutation = .duplicate_path, .nested = false });
}

test "cached scalars direct swap" {
    try h.run(.{ .shape = .scalars, .mutation = .swap, .nested = false });
}

test "cached scalars nested none" {
    try h.run(.{ .shape = .scalars, .mutation = .none, .nested = true });
}

test "cached scalars nested duplicate_id" {
    try h.run(.{ .shape = .scalars, .mutation = .duplicate_id, .nested = true });
}

test "cached scalars nested duplicate_path" {
    try h.run(.{ .shape = .scalars, .mutation = .duplicate_path, .nested = true });
}

test "cached scalars nested swap" {
    try h.run(.{ .shape = .scalars, .mutation = .swap, .nested = true });
}

test "cached scalars none allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .scalars, .mutation = .none, .nested = true }});
}

test "cached scalars duplicate_path allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .scalars, .mutation = .duplicate_path, .nested = true }});
}
