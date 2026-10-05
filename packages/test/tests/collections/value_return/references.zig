const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const State = std.meta.Child(@FieldType(std.meta.Child(program.Input), "seed"));
const Cell = std.meta.Child(@FieldType(State, "cell"));

fn check(gpa: std.mem.Allocator, count: usize, present: bool) !void {
    const steps = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(steps);

    var expected: u64 = 7;

    for (steps, 0..) |*item, index| {
        item.* = @intCast(index % 11);
        expected += item.*;
    }

    var items = [_]u64{ 2, 19, 37 };
    var cell: Cell = .{ .value = 123 };
    var seed: State = .{ .count = 7, .items = &items, .cell = &cell, .saved = if (present) &cell else null };
    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const result = try program.execute(&arena, &.{ .seed = &seed, .steps = steps });

    try std.testing.expectEqual(expected, result.count);
    try std.testing.expectEqualSlices(u64, &.{ 2, 19, 37 }, result.items);
    try std.testing.expect(result.items.ptr == &items);
    try std.testing.expect(result.cell == &cell);
    try std.testing.expect(result.saved == seed.saved);
    try std.testing.expectEqual(@as(u64, 123), result.cell.value);
    try std.testing.expectEqual(@as(u64, 7), seed.count);
    for (steps, 0..) |item, index| try std.testing.expectEqual(@as(u64, @intCast(index % 11)), item);
    if (count == 0) try std.testing.expect(result == &seed);
    try std.testing.expect(arena.queryCapacity() <= 4096);
    try std.testing.expect(tracked.allocated_bytes <= 4096);
    try std.testing.expect(tracked.allocations <= 4);
}

test "reference state preserves list and child identity across internal returns" {
    for ([_]usize{ 0, 1, 2, 31, 128 }) |count| {
        for ([_]bool{ false, true }) |present| try check(std.testing.allocator, count, present);
    }
}

test "reference state allocation stays bounded without resize" {
    for ([_]usize{ 2048, 16384 }) |count| try check(std.testing.allocator, count, true);
}

test "reference state cleans up every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ @as(usize, 31), true });
}
