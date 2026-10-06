const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");

fn run(allocator: std.mem.Allocator, length: usize) !void {
    const nodes = try std.testing.allocator.alloc(host.HostNode, length);

    defer std.testing.allocator.free(nodes);

    const values = try std.testing.allocator.alloc(host.Node, length);

    defer std.testing.allocator.free(values);

    for (nodes, values, 0..) |*node, *value, index| {
        node.* = .{ .value = @intCast(index % 7 + 1), .payload = "node" };
        value.* = host.fromNode(node);
    }

    const owner = host.HostNode{ .value = 31, .payload = "owner", .references = values };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();
    host.reset(0);

    const result = program.execute(&arena, host.fromNode(&owner)) catch |err| {
        try preserved(nodes, values, owner);

        return err;
    };

    try std.testing.expectEqual(length, result.len);
    try std.testing.expectEqual(length + 1, host.calls);
    try support.expectNode(&owner, host.events[0].node);
    try std.testing.expectEqual(@as(u64, 5), host.events[0].marker);

    for (result, nodes, 0..) |value, *node, index| {
        try std.testing.expectEqual(@as(u64, @intCast(index % 7 + 1)), value);
        try support.expectNode(node, host.events[index + 1].node);
        try std.testing.expectEqual(@as(u64, 2), host.events[index + 1].marker);
    }

    try preserved(nodes, values, owner);
}

fn preserved(nodes: []const host.HostNode, values: []const host.Node, owner: host.HostNode) !void {
    for (nodes, values, 0..) |*node, value, index| {
        try support.expectNode(node, value);
        try support.expectOwner(.{ .value = @intCast(index % 7 + 1), .payload = "node" }, node.*);
    }

    try support.expectOwner(.{ .value = 31, .payload = "owner", .references = values }, owner);
}

fn failures(allocator: std.mem.Allocator) !void {
    try run(allocator, 17);
}

test "empty native reference traversal reads only the root accessor" {
    try run(std.testing.allocator, 0);
}

test "native reference traversal reads real leaf addresses in source order" {
    try run(std.testing.allocator, 257);
}

test "native reference traversal releases all allocation failures and preserves all host leaves" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{});
}
