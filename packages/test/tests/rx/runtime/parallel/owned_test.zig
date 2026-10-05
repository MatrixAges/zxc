const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");

fn check(allocator: std.mem.Allocator, input: []const u64) !void {
    const before = try std.testing.allocator.dupe(u64, input);

    defer std.testing.allocator.free(before);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const result = program.execute(&arena, input);

    try std.testing.expectEqualSlices(u64, before, input);

    const output = try result;

    try std.testing.expect(!program.consumes_input);
    try std.testing.expectEqual(input.len, output.left.len);
    try std.testing.expectEqual(input.len, output.right.len);

    for (before, 0..) |value, index| {
        try std.testing.expectEqual(value, output.left[input.len - 1 - index]);
        try std.testing.expectEqual(value, output.right[input.len - 1 - index]);
    }

    if (input.len > 0) {
        try std.testing.expect(output.left.ptr != input.ptr);
        try std.testing.expect(output.right.ptr != input.ptr);
        try std.testing.expect(output.left.ptr != output.right.ptr);
    }
}

test "RX owned branches preserve empty input" {
    try check(std.testing.allocator, &.{});
}

test "RX owned branches preserve singleton" {
    try check(std.testing.allocator, &.{7});
}

test "RX owned branches independently reverse duplicates and zero" {
    try check(std.testing.allocator, &.{ 7, 0, 13, 7, 11 });
}

test "RX owned branches preserve maximum integer without coercion" {
    try check(std.testing.allocator, &.{ std.math.maxInt(u64), 0, 1 });
}

test "RX owned branches reverse long input independently" {
    var input: [257]u64 = undefined;

    for (&input, 0..) |*value, index| value.* = @intCast(index % 37);
    try check(std.testing.allocator, &input);
}

test "RX owned request results survive later requests" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, &.{ 1, 7, 3 });
    const second = try program.execute(&arena, &.{ 11, 0 });

    try std.testing.expectEqualSlices(u64, &.{ 3, 7, 1 }, first.left);
    try std.testing.expectEqualSlices(u64, &.{ 3, 7, 1 }, first.right);
    try std.testing.expectEqualSlices(u64, &.{ 0, 11 }, second.left);
    try std.testing.expectEqualSlices(u64, &.{ 0, 11 }, second.right);
}

test "RX owned parallel allocation failures release request and branch storage" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as([]const u64, &.{ 1, 0, 7 })});
}
