const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");

fn run(allocator: std.mem.Allocator, count: usize, length: usize) !usize {
    const original = host.HostNode{ .value = 7, .payload = "original" };
    const left = host.HostNode{ .value = 7, .payload = "left" };
    const right = host.HostNode{ .value = 7, .payload = "right" };
    const values = try std.testing.allocator.alloc(host.Node, length);

    defer std.testing.allocator.free(values);

    @memset(values, host.fromNode(&original));

    const owner = host.HostNode{ .value = 11, .payload = "owner", .references = values };
    const input: @typeInfo(program.Input).pointer.child = .{ .values = values, .left = host.fromNode(&left), .right = host.fromNode(&right), .count = @intCast(count) };
    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();
    host.reset(0);

    const result = program.execute(&arena, &input) catch |err| {
        try preserved(values, &original, owner, left, right);

        return err;
    };

    try std.testing.expectEqual(length, result.original.len);
    try std.testing.expectEqual(values.ptr, result.original.ptr);
    try std.testing.expectEqual(length, result.values.len);

    const updated = if (count == 0) &original else &left;

    try support.expectNode(updated, result.values[0]);

    if (count == 0) {
        try std.testing.expectEqual(values.ptr, result.values.ptr);
    } else {
        try std.testing.expect(values.ptr != result.values.ptr);
    }

    for (1..length) |index| try support.expectNode(&original, result.values[index]);
    try std.testing.expectEqual(length, result.other.len);
    try support.expectNode(if (count == 0) &original else &right, result.other[1]);
    try support.expectNode(&original, result.other[0]);
    if (count > 0) try std.testing.expect(result.values.ptr != result.other.ptr);
    for (2..length) |index| try support.expectNode(&original, result.other[index]);
    try std.testing.expectEqual(@as(usize, 0), host.calls);
    try preserved(values, &original, owner, left, right);

    return tracked.allocated_bytes;
}

fn preserved(values: []const host.Node, original: *const host.HostNode, owner: host.HostNode, left: host.HostNode, right: host.HostNode) !void {
    for (values) |value| try support.expectNode(original, value);
    try support.expectOwner(.{ .value = 7, .payload = "original" }, original.*);
    try support.expectOwner(.{ .value = 7, .payload = "left" }, left);
    try support.expectOwner(.{ .value = 7, .payload = "right" }, right);
    try support.expectOwner(.{ .value = 11, .payload = "owner", .references = values }, owner);
}

fn failures(allocator: std.mem.Allocator) !void {
    _ = try run(allocator, 4, 17);
}

test "native reference loop preserves the zero step borrowed slots and first write isolation" {
    for ([_]usize{ 0, 1 }) |count| _ = try run(std.testing.allocator, count, 17);
}

test "native reference loop preserves every input slot across long execution" {
    _ = try run(std.testing.allocator, 64, 257);
}

test "safe native reference loop updates have equal allocation cost for short and long execution" {
    const short = try run(std.testing.allocator, 4, 257);
    const long = try run(std.testing.allocator, 64, 257);

    try std.testing.expectEqual(short, long);
}

test "native reference loop releases all allocation failures without changing any owner or input slot" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{});
}
