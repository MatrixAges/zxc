const std = @import("std");
const allocation_testing = @import("allocation_testing");
const State = @import("zxc_state");
const Fixture = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, fail_first: bool) !void {
    try std.testing.expect(State.can_release_retired);

    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var fixture = try Fixture.init(tracked.allocator());

    defer fixture.deinit();

    const state = fixture.state;

    for (0..64) |index| {
        {
            var request = state.request();

            defer request.deinit();

            const result = request.execute(&.{ .increment = 1, .left_index = if (fail_first) 1 else 0, .right_index = if (fail_first) 0 else 1 });

            if (result) |_| return error.ExpectedFailure else |err| {
                if (err == error.OutOfMemory) return err;

                try std.testing.expectEqual(error.IndexOutOfBounds, err);
            }
        }

        state.releaseRetired();

        try std.testing.expectEqual(if (fail_first) @as(u64, 3) else @as(u64, @intCast(index + 4)), state.value_0.value);
        try std.testing.expectEqual(@as(u64, 100), state.value_1.value);
        try std.testing.expect(tracked.allocated_bytes - tracked.freed_bytes <= 65536);
    }

    {
        var request = state.request();

        defer request.deinit();

        _ = try request.execute(&.{ .increment = 2, .left_index = 0, .right_index = 0 });
    }

    state.releaseRetired();

    try std.testing.expectEqual(@as(u64, if (fail_first) 5 else 69), state.value_0.value);
    try std.testing.expectEqual(@as(u64, 102), state.value_1.value);
}

test "failed first setter releases temporary regions before recovery" {
    try run(std.testing.allocator, true);
}

test "failed later setter retains prior success and releases historical regions" {
    try run(std.testing.allocator, false);
}

test "first setter failure reclamation allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}

test "later setter failure reclamation allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}
