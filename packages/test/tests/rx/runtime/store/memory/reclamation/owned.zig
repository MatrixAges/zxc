const std = @import("std");
const State = @import("zxc_state");
const Fixture = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, count: usize) !void {
    try std.testing.expect(State.can_release_retired);

    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var fixture = try Fixture.init(tracked.allocator());

    defer fixture.deinit();

    const state = fixture.state;
    var peak: usize = 0;

    for (0..count) |index| {
        {
            var request = state.request();

            defer request.deinit();

            const result = try request.execute(1);

            try std.testing.expectEqual(@as(u64, @intCast(index + 4)), result.after_left.value);
            try std.testing.expectEqual(@as(u64, @intCast(index + 101)), result.after_right.value);
            try std.testing.expectEqualSlices(u64, &.{@as(u64, @intCast(index + 9))}, result.after_left.history);
        }

        state.releaseRetired();

        const alive = tracked.allocated_bytes - tracked.freed_bytes;
        peak = @max(peak, alive);

        errdefer std.debug.print("iteration={d} alive={d}\n", .{ index, alive });

        try std.testing.expect(alive <= 65536);
        try std.testing.expectEqual(@as(u64, @intCast(index + 4)), state.value_0.value);
        try std.testing.expectEqual(@as(u64, @intCast(index + 101)), state.value_1.value);

        state.releaseRetired();

        try std.testing.expectEqual(alive, tracked.allocated_bytes - tracked.freed_bytes);
    }

    if (count == 4096) std.debug.print("reclaimed requests={d} peak_live_bytes={d} bound=65536\n", .{ count, peak });
}

test "independent Store release before first request is harmless" {
    var fixture = try Fixture.init(std.testing.allocator);

    defer fixture.deinit();
    fixture.state.releaseRetired();
    fixture.state.releaseRetired();

    try std.testing.expectEqual(@as(u64, 3), fixture.state.value_0.value);
}

test "independent Store single request preserves current roots" {
    try run(std.testing.allocator, 1);
}

test "independent Store many requests have bounded live allocation" {
    try run(std.testing.allocator, 4096);
}

test "independent Store release and update allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as(usize, 8)});
}

test "independent Store deinitialization releases current roots" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try run(debug.allocator(), 128);
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}

comptime {
    _ = @import("manual.zig");
    _ = @import("roots.zig");
}
