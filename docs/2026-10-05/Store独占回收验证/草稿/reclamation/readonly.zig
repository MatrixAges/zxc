const std = @import("std");
const State = @import("zxc_state");
const Fixture = @import("fixture.zig");

fn run(allocator: std.mem.Allocator) !void {
    try std.testing.expect(!State.can_release_retired);

    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var fixture = try Fixture.init(tracked.allocator());

    defer fixture.deinit();

    const initial = tracked.allocated_bytes - tracked.freed_bytes;

    for (0..64) |_| {
        {
            var request = fixture.state.request();

            defer request.deinit();

            const result = try request.execute({});

            try std.testing.expectEqual(@as(u64, 3), result.first);
            try std.testing.expectEqual(@as(u64, 100), result.second);
        }

        fixture.state.releaseRetired();

        try std.testing.expectEqual(initial, tracked.allocated_bytes - tracked.freed_bytes);
    }
}

test "readonly State release is safe and request storage is freed" {
    try run(std.testing.allocator);
}

test "readonly State release lifecycle allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{});
}
