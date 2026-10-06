const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");

fn run(allocator: std.mem.Allocator, count: usize, length: usize) !void {
    const nodes = [_]host.HostNode{
        .{ .value = 7, .payload = "left" },
        .{ .value = 7, .payload = "right" },
        .{ .value = 7, .payload = "replacement" },
    };

    const values = try std.testing.allocator.alloc(host.Node, length);

    defer std.testing.allocator.free(values);

    for (values, 0..) |*value, index| value.* = host.fromNode(&nodes[index % 2]);

    const input: @typeInfo(program.Input).pointer.child = .{ .values = values, .node = host.fromNode(&nodes[2]), .count = @intCast(count) };
    var tracked = std.testing.FailingAllocator.init(allocator, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();
    host.reset(0);

    const executed = program.execute(&arena, &input);

    for (values, 0..) |value, index| try support.expectNode(&nodes[index % 2], value);
    try support.expectOwner(.{ .value = 7, .payload = "left" }, nodes[0]);
    try support.expectOwner(.{ .value = 7, .payload = "right" }, nodes[1]);
    try support.expectOwner(.{ .value = 7, .payload = "replacement" }, nodes[2]);

    const result = try executed;
    const expected_length = if (length == 0 and count > 0) @as(usize, 1) else length;

    try std.testing.expect(program.consumes_input);
    try std.testing.expectEqual(expected_length, result.len);

    for (result, 0..) |value, index| {
        const expected = if (count > 0 and index + 1 == expected_length) &nodes[2] else &nodes[index % 2];

        try support.expectNode(expected, value);
    }

    if (count == 0) {
        try std.testing.expectEqual(values.ptr, result.ptr);
    } else if (length > 0) {
        try std.testing.expect(values.ptr != result.ptr);
    }

    try std.testing.expectEqual(@as(usize, 0), host.calls);
}

fn failures(allocator: std.mem.Allocator) !void {
    try run(allocator, 4, 17);
}

test "native reference nested helpers preserve zero step and first replacement identities" {
    for ([_]usize{ 0, 1, 2, 3, 17 }) |count| try run(std.testing.allocator, count, 17);
}

test "native reference nested helpers handle empty and one slot seeds" {
    for ([_]usize{ 0, 1 }) |length| {
        for ([_]usize{ 0, 1, 2, 17 }) |count| try run(std.testing.allocator, count, length);
    }
}

test "native reference nested helpers preserve every prefix address across long execution" {
    try run(std.testing.allocator, 64, 257);
}

test "native reference nested helpers release all allocation failures and preserve external slots" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{});
}
