const std = @import("std");
const State = @import("zxc_state");
const Fixture = @import("fixture.zig");

fn run(allocator: std.mem.Allocator) !void {
    try std.testing.expect(!State.can_release_retired);

    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var fixture = try Fixture.init(tracked.allocator());

    defer fixture.deinit();

    const state = fixture.state;
    const initial = state.value_0;

    for (0..32) |index| {
        {
            var request = state.request();

            defer request.deinit();

            const result = try request.execute(1);

            try std.testing.expectEqualSlices(u64, &.{8}, result.after_left.history);
            try std.testing.expectEqual(@as(u64, @intCast(index + 4)), result.after_left.value);
        }

        const alive = tracked.allocated_bytes - tracked.freed_bytes;

        state.releaseRetired();

        try std.testing.expectEqual(alive, tracked.allocated_bytes - tracked.freed_bytes);
    }

    try std.testing.expectEqualSlices(u64, &.{8}, initial.history);
}

test "borrowed setter disables automatic reclamation eligibility" {
    try run(std.testing.allocator);
}

test "borrowed setter fallback allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{});
}

test "borrowed setter retained regions are freed on State destruction" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try run(debug.allocator());
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}
