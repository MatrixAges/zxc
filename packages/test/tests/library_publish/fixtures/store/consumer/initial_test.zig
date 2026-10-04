const std = @import("std");
const counter = @import("counter_initial");
const settings = @import("settings_initial");
const types = @import("bindings.zig");

fn values(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const state = try counter.execute(&arena, {});
    const preferences = try settings.execute(&arena, {});

    try std.testing.expect(counter.Output == *const types.Counter);
    try std.testing.expect(settings.Output == *const types.Settings);
    try std.testing.expectEqual(@as(u64, 3), state.value);
    try std.testing.expectEqualSlices(u64, &.{8}, state.history);
    try std.testing.expectEqualStrings("fresh", preferences.label);
    try std.testing.expect(preferences.enabled);
    try std.testing.expectEqual(@as(?u64, null), preferences.missing);
    try std.testing.expectEqual(@as(?u64, 17), preferences.maybe);
    try std.testing.expectEqual(@as(?i64, -17), preferences.signed);
    try std.testing.expectEqual(@as(?f64, 1.75), preferences.ratio);
    try std.testing.expectEqual(@as(usize, 2), preferences.matrix.len);
    try std.testing.expectEqual(@as(usize, 0), preferences.matrix[0].len);
    try std.testing.expectEqualSlices(u64, &.{ 2, 3 }, preferences.matrix[1]);
}

test "generated initializers execute all scalar and owned aggregate values" {
    try values(std.testing.allocator);
}

test "separate initializer calls allocate independent owned nonempty graphs" {
    var left = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer left.deinit();

    var right = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer right.deinit();

    const a = try counter.execute(&left, {});
    const b = try counter.execute(&right, {});
    const x = try settings.execute(&left, {});
    const y = try settings.execute(&right, {});

    try std.testing.expect(a != b);
    try std.testing.expect(a.history.ptr != b.history.ptr);
    try std.testing.expect(x != y);
    try std.testing.expect(x.matrix.ptr != y.matrix.ptr);
    try std.testing.expect(x.matrix[1].ptr != y.matrix[1].ptr);

    left.deinit();

    left = std.heap.ArenaAllocator.init(std.testing.allocator);

    try std.testing.expectEqual(@as(u64, 3), b.value);
    try std.testing.expectEqualSlices(u64, &.{ 2, 3 }, y.matrix[1]);
}

test "generated initialization releases every failed partial allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, values, .{});
}
