const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn napi(allocator: std.mem.Allocator) !void {
    try f.rejectNapi(allocator, "{ nodes: Node?[] }", false);
}

fn gateway(allocator: std.mem.Allocator) !void {
    try f.gateway(allocator, "{ nodes: [u64, Node?[]] }", true);
}

test "NAPI reference conversion rejection releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, napi, .{});
}

test "Gateway reference conversion rejection releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, gateway, .{});
}
