const std = @import("std");
const allocation_testing = @import("allocation_testing");
const Fixture = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, reverse_end: bool) !void {
    var fixture = try Fixture.init(allocator);

    defer fixture.deinit();

    const state = fixture.state;
    var first = state.request();
    var first_alive = true;

    defer if (first_alive) first.deinit();

    try Fixture.left(&first, 10, try Fixture.values(&first, 9, 100));

    const intermediate = state.value_0;

    try Fixture.right(&first, 20, intermediate.history[2..7]);
    try Fixture.left(&first, 30, intermediate.history[4..]);

    var second = state.request();
    var second_alive = true;

    defer if (second_alive) second.deinit();

    try Fixture.right(&second, 40, state.value_0.history[1..]);

    if (reverse_end) {
        second.deinit();

        second_alive = false;

        first.deinit();

        first_alive = false;
    } else {
        first.deinit();

        first_alive = false;

        second.deinit();

        second_alive = false;
    }

    try std.testing.expectEqual(@as(u64, 10), intermediate.value);
    try std.testing.expectEqualSlices(u64, &.{ 100, 101, 102, 103, 104, 105, 106, 107, 108 }, intermediate.history);
    try std.testing.expectEqualSlices(u64, &.{ 104, 105, 106, 107, 108 }, state.value_0.history);
    try std.testing.expectEqualSlices(u64, &.{ 105, 106, 107, 108 }, state.value_1.history);
    try std.testing.expectEqual(@as(u64, 30), state.value_0.value);
    try std.testing.expectEqual(@as(u64, 40), state.value_1.value);
}

test "overlapping requests retain intermediate commit with producer ending first" {
    try run(std.testing.allocator, false);
}

test "overlapping requests retain intermediate commit with consumer ending first" {
    try run(std.testing.allocator, true);
}

test "overlapping producer first lifecycle allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "overlapping consumer first lifecycle allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

test "overlapping requests release all regions on State destruction" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try run(debug.allocator(), true);
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}
