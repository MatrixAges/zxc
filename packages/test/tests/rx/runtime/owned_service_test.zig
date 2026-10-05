const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");

const Case = struct {
    input: []const u64,
    left: []const u64,
    left_popped: ?u64,
    right: []const u64,
};

fn check(allocator: std.mem.Allocator, case: Case) !void {
    const input = try std.testing.allocator.dupe(u64, case.input);

    defer std.testing.allocator.free(input);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = program.execute(&arena, input) catch |err| {
        try std.testing.expectEqualSlices(u64, case.input, input);

        return err;
    };

    try std.testing.expectEqualSlices(u64, case.left, output.left.@"0");
    try std.testing.expectEqual(case.left_popped, output.left.@"1");
    try std.testing.expectEqualSlices(u64, case.right, output.right.@"0");
    try std.testing.expectEqualSlices(u64, case.input, input);

    if (output.left.@"0".len != 0) {
        try std.testing.expect(output.left.@"0".ptr != output.right.@"0".ptr);
        try std.testing.expect(output.left.@"0".ptr != input.ptr);
        try std.testing.expect(output.right.@"0".ptr != input.ptr);
    }
}

test "RX service owned empty lists stay independent" {
    try check(std.testing.allocator, .{ .input = &.{}, .left = &.{}, .left_popped = null, .right = &.{} });
}

test "RX service owned single lists pop correctly" {
    try check(std.testing.allocator, .{ .input = &.{7}, .left = &.{}, .left_popped = 8, .right = &.{8} });
}

test "RX service owned reverse does not mutate other return" {
    try check(std.testing.allocator, .{ .input = &.{ 1, 3, 8 }, .left = &.{ 2, 4 }, .left_popped = 9, .right = &.{ 9, 4, 2 } });
}

test "RX service owned lists preserve boundary values" {
    const maximum = std.math.maxInt(u64);

    try check(std.testing.allocator, .{ .input = &.{ 0, maximum - 1 }, .left = &.{1}, .left_popped = maximum, .right = &.{ maximum, 1 } });
}

test "RX service owned lists allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .input = &.{ 1, 3, 8 }, .left = &.{ 2, 4 }, .left_popped = 9, .right = &.{ 9, 4, 2 } }});
}
