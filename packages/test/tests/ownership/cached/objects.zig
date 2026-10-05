const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "cached objects direct none" {
    try h.run(.{ .shape = .objects, .mutation = .none, .nested = false });
}

test "cached objects direct duplicate_id" {
    try h.run(.{ .shape = .objects, .mutation = .duplicate_id, .nested = false });
}

test "cached objects direct duplicate_path" {
    try h.run(.{ .shape = .objects, .mutation = .duplicate_path, .nested = false });
}

test "cached objects direct swap" {
    try h.run(.{ .shape = .objects, .mutation = .swap, .nested = false });
}

test "cached objects nested none" {
    try h.run(.{ .shape = .objects, .mutation = .none, .nested = true });
}

test "cached objects nested duplicate_id" {
    try h.run(.{ .shape = .objects, .mutation = .duplicate_id, .nested = true });
}

test "cached objects nested duplicate_path" {
    try h.run(.{ .shape = .objects, .mutation = .duplicate_path, .nested = true });
}

test "cached objects nested swap" {
    try h.run(.{ .shape = .objects, .mutation = .swap, .nested = true });
}

test "cached objects none allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .objects, .mutation = .none, .nested = true }});
}

test "cached objects duplicate_path allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{ .shape = .objects, .mutation = .duplicate_path, .nested = true }});
}
