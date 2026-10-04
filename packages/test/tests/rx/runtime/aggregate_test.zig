const std = @import("std");
const program = @import("program");

const Case = struct { input: []const u64, items: []const u64, total: u64 };

fn check(allocator: std.mem.Allocator, case: Case) !void {
    const input = try std.testing.allocator.dupe(u64, case.input);

    defer std.testing.allocator.free(input);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = program.execute(&arena, input) catch |err| {
        try std.testing.expectEqualSlices(u64, case.input, input);

        return err;
    };

    try std.testing.expectEqualSlices(u64, case.items, output.items);
    try std.testing.expectEqual(case.total, output.total);
    try std.testing.expectEqualSlices(u64, case.input, input);

    if (input.len != 0) try std.testing.expect(output.items.ptr != input.ptr);
}

test "RX owned list empty pipeline" {
    try check(std.testing.allocator, .{ .input = &.{}, .items = &.{}, .total = 0 });
}

test "RX owned list single value pipeline" {
    try check(std.testing.allocator, .{ .input = &.{7}, .items = &.{8}, .total = 8 });
}

test "RX owned list multi value pipeline" {
    try check(std.testing.allocator, .{ .input = &.{ 1, 3, 8 }, .items = &.{ 2, 4, 9 }, .total = 15 });
}

test "RX owned list zero values pipeline" {
    try check(std.testing.allocator, .{ .input = &.{ 0, 9, 0 }, .items = &.{ 1, 10, 1 }, .total = 12 });
}

test "RX owned list runtime allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .input = &.{ 1, 3, 8 }, .items = &.{ 2, 4, 9 }, .total = 15 }});
}
