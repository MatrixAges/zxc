const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");

fn accepted(allocator: std.mem.Allocator) !void {
    try f.accepted(allocator, .{ .output = "{ nodes: Node?[] }", .body = "return { nodes: [in, null] }" });
}

fn rejected(allocator: std.mem.Allocator) !void {
    try f.rejected(allocator, .{ .declaration = "export type Node = opaque\n\nexport declare function identity(value: u64): Node\n" }, .{ .code = .ownership, .message = "native reference results require a host reference input", .native = true });
}

test "native reference declaration and nested accepted types release every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, accepted, .{});
}

test "native reference declaration diagnostics release every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, rejected, .{});
}
