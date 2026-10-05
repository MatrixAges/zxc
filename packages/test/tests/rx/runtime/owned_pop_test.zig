const std = @import("std");
const allocation_testing = @import("allocation_testing");
const program = @import("program");
const Case = struct { input: []const u64, remaining: []const u64, popped: ?u64 };

fn check(allocator: std.mem.Allocator, case: Case) !void {
    const input = try std.testing.allocator.dupe(u64, case.input);

    defer std.testing.allocator.free(input);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = program.execute(&arena, input) catch |err| {
        try std.testing.expectEqualSlices(u64, case.input, input);

        return err;
    };

    try std.testing.expectEqualSlices(u64, case.remaining, output.@"0");
    try std.testing.expectEqual(case.popped, output.@"1");
    try std.testing.expectEqualSlices(u64, case.input, input);
}

test "RX consumes owned empty call result" {
    try check(std.testing.allocator, .{ .input = &.{}, .remaining = &.{}, .popped = null });
}

test "RX consumes owned single call result" {
    try check(std.testing.allocator, .{ .input = &.{7}, .remaining = &.{}, .popped = 8 });
}

test "RX consumes owned multivalue call result" {
    try check(std.testing.allocator, .{ .input = &.{ 1, 3, 8 }, .remaining = &.{ 2, 4 }, .popped = 9 });
}

test "RX owned call result consumption allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .input = &.{ 1, 3, 8 }, .remaining = &.{ 2, 4 }, .popped = 9 }});
}
