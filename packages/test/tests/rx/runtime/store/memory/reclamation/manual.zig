const std = @import("std");
const allocation_testing = @import("allocation_testing");
const Fixture = @import("fixture.zig");
const application = @import("application");

fn run(allocator: std.mem.Allocator, direct: bool) !void {
    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var fixture = try Fixture.init(tracked.allocator());

    defer fixture.deinit();

    const state = fixture.state;
    var saved: application.Output = undefined;

    for (0..32) |index| {
        {
            var request = state.request();

            defer request.deinit();

            const result = try request.execute(1);

            if (index == 0) saved = result;
        }

        if (direct and index == 0) try state.commit(.{ .store_0 = state.value_0, .store_1 = null });

        if (direct) {
            const alive = tracked.allocated_bytes - tracked.freed_bytes;

            state.releaseRetired();

            try std.testing.expectEqual(alive, tracked.allocated_bytes - tracked.freed_bytes);
        }
    }

    try std.testing.expectEqual(@as(u64, 4), saved.after_left.value);
    try std.testing.expectEqualSlices(u64, &.{9}, saved.after_left.history);
    try std.testing.expectEqual(@as(u64, 101), saved.after_right.value);
    try std.testing.expectEqual(@as(u64, 35), state.value_0.value);
}

test "legacy host retains output until explicitly ending borrow" {
    try run(std.testing.allocator, false);
}

test "direct State commit disables unproven region reclamation" {
    try run(std.testing.allocator, true);
}

test "legacy retained output allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "direct State commit fallback allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}
