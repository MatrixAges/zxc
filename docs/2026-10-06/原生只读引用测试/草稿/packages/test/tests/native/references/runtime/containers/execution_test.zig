const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");

fn preserved(owner: host.HostNode, children: []const host.HostNode) !void {
    try support.expectOwner(.{ .value = 42, .payload = "owner", .children = children }, owner);
    try std.testing.expectEqual(@as(u64, 9), children[0].value);
    try std.testing.expectEqualStrings("child", children[0].payload);
}

fn execute(allocator: std.mem.Allocator) !void {
    const children = [_]host.HostNode{.{ .value = 9, .payload = "child" }};
    const owner = host.HostNode{ .value = 42, .payload = "owner", .children = &children };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();
    host.reset(0);

    const result = program.execute(&arena, host.fromNode(&owner)) catch |err| {
        try preserved(owner, &children);

        return err;
    };

    try support.expectNode(&owner, result.node);
    try std.testing.expectEqual(@as(usize, 3), result.nodes.len);
    try support.expectNode(&owner, result.nodes[0]);
    try support.expectNode(&children[0], result.nodes[1]);
    try support.expectNode(&owner, result.nodes[2]);
    try support.expectNode(&owner, result.pair[0]);
    try std.testing.expectEqual(@as(u64, 42), result.pair[1]);
    try preserved(owner, &children);
}

test "native reference aggregate and list slots preserve child addresses and repeated aliases" {
    try execute(std.testing.allocator);
}

test "native owner survives releasing all ZX aggregate and list buffers" {
    const children = [_]host.HostNode{.{ .value = 9, .payload = "child" }};
    const owner = host.HostNode{ .value = 42, .payload = "owner", .children = &children };

    const leaf = block: {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();
        host.reset(0);

        const result = try program.execute(&arena, host.fromNode(&owner));

        break :block result.node;
    };

    try support.expectNode(&owner, leaf);
    try preserved(owner, &children);
}

test "native reference container allocation failures release buffers and preserve every host node" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execute, .{});
}
