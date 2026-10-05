const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");

fn check(allocator: std.mem.Allocator, input: []const u64) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const before = try std.testing.allocator.dupe(u64, input);

    defer std.testing.allocator.free(before);

    const output = program.execute(&arena, input) catch |err| {
        try std.testing.expectEqualSlices(u64, before, input);

        return err;
    };

    try std.testing.expectEqual(input.len, output.left.len);
    try std.testing.expectEqual(input.len, output.right.len);

    for (before, output.left, output.right) |original, left, right| {
        try std.testing.expectEqual(original + 1, left);
        try std.testing.expectEqual(original * 2, right);
    }

    const remaining = output.remaining.@"0";
    const popped = output.remaining.@"1";
    const length = if (input.len == 0) 0 else input.len - 1;

    try std.testing.expectEqual(length, remaining.len);
    try std.testing.expectEqual(if (input.len == 0) @as(?u64, null) else before[input.len - 1] + 1, popped);
    for (remaining, before[0..length]) |value, original| try std.testing.expectEqual(original + 1, value);
    try std.testing.expectEqualSlices(u64, before, input);

    if (input.len > 1) {
        try std.testing.expect(remaining.ptr != output.left.ptr);
        try std.testing.expect(remaining.ptr != output.right.ptr);
    }
}

test "RX Task unused owned capture remains consumable for empty input" {
    try check(std.testing.allocator, &.{});
}

test "RX Task unused owned capture remains consumable for singleton" {
    try check(std.testing.allocator, &.{11});
}

test "RX Task selective capture preserves list values and ownership" {
    try check(std.testing.allocator, &.{ 7, 0, 3, 7 });
}

test "RX Task selective capture preserves exact numeric boundary" {
    try check(std.testing.allocator, &.{ 0, std.math.maxInt(u64) / 2 });
}

test "RX Task selective capture frees each failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as([]const u64, &.{ 2, 7, 11 })});
}
