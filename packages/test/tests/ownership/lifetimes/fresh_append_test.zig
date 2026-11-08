const std = @import("std");
const program = @import("fresh_append");

fn run(allocator: std.mem.Allocator, count: usize, remove: bool, concatenate: bool) !void {
    const input = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(input);

    for (input, 0..) |*item, index| item.* = @intCast(index);

    const original = try std.testing.allocator.dupe(u64, input);

    defer std.testing.allocator.free(original);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const prefix = std.math.maxInt(u64);
    const appended = prefix - 1;
    const output = try program.execute(&arena, &.{ .values = input, .remove = remove, .concatenate = concatenate, .prefix = prefix, .appended = appended });
    const expected = try std.testing.allocator.alloc(u64, count + @as(usize, if (remove) 1 else 2));

    defer std.testing.allocator.free(expected);
    @memcpy(expected[0..count], original);

    if (!remove) expected[count] = prefix;

    expected[expected.len - 1] = appended;
    expected[0] = appended;

    std.mem.reverse(u64, expected);

    try std.testing.expectEqualSlices(u64, original, input);
    try std.testing.expectEqual(count + 1, output.retained.len);
    try std.testing.expectEqualSlices(u64, original, output.retained[0..count]);
    try std.testing.expectEqual(prefix, output.retained[count]);
    try std.testing.expectEqualSlices(u64, expected, output.values);
}

test "copied and reused append buffers preserve retained shared prefixes" {
    for ([_]usize{ 0, 1, 7, 8, 9, 15, 16, 31, 65 }) |count| {
        for ([_]bool{ false, true }) |remove| {
            for ([_]bool{ false, true }) |concatenate| try run(std.testing.allocator, count, remove, concatenate);
        }
    }
}

test "append buffer qualification preserves allocation failure cleanup" {
    for ([_]bool{ false, true }) |remove| {
        for ([_]bool{ false, true }) |concatenate| try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{ @as(usize, 17), remove, concatenate });
    }
}
