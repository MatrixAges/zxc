const std = @import("std");
const program = @import("program");

const Case = struct {
    enabled: bool,
    values: []const u64,
    remaining: []const u64,
    popped: ?u64,
};

fn check(allocator: std.mem.Allocator, case: Case) !void {
    const values = try std.testing.allocator.dupe(u64, case.values);

    defer std.testing.allocator.free(values);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .enabled = case.enabled, .values = values };
    const output = program.execute(&arena, &input) catch |err| {
        try std.testing.expectEqualSlices(u64, case.values, values);

        return err;
    };

    try std.testing.expectEqualSlices(u64, case.remaining, output.@"0");
    try std.testing.expectEqual(case.popped, output.@"1");
    try std.testing.expectEqualSlices(u64, case.values, values);

    if (output.@"0".len != 0) try std.testing.expect(output.@"0".ptr != values.ptr);
}

test "RX Case owned empty result" {
    try check(std.testing.allocator, .{ .enabled = true, .values = &.{}, .remaining = &.{}, .popped = null });
}

test "RX Case owned single result" {
    try check(std.testing.allocator, .{ .enabled = true, .values = &.{7}, .remaining = &.{}, .popped = 8 });
}

test "RX Case owned multiple result" {
    try check(std.testing.allocator, .{ .enabled = true, .values = &.{ 1, 3, 8 }, .remaining = &.{ 2, 4 }, .popped = 9 });
}

test "RX Case owned boundary result" {
    try check(std.testing.allocator, .{ .enabled = true, .values = &.{ 0, std.math.maxInt(u64) - 1 }, .remaining = &.{1}, .popped = std.math.maxInt(u64) });
}

test "RX Case owned return allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .enabled = true, .values = &.{ 1, 3, 8 }, .remaining = &.{ 2, 4 }, .popped = 9 }});
}

test "RX Default owned empty result" {
    try check(std.testing.allocator, .{ .enabled = false, .values = &.{}, .remaining = &.{}, .popped = null });
}

test "RX Default owned single result" {
    try check(std.testing.allocator, .{ .enabled = false, .values = &.{7}, .remaining = &.{}, .popped = 9 });
}

test "RX Default owned multiple result" {
    try check(std.testing.allocator, .{ .enabled = false, .values = &.{ 1, 3, 8 }, .remaining = &.{ 3, 5 }, .popped = 10 });
}

test "RX Default owned boundary result" {
    try check(std.testing.allocator, .{ .enabled = false, .values = &.{ 0, std.math.maxInt(u64) - 2 }, .remaining = &.{2}, .popped = std.math.maxInt(u64) });
}

test "RX Default owned return allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .enabled = false, .values = &.{ 1, 3, 8 }, .remaining = &.{ 3, 5 }, .popped = 10 }});
}
