const std = @import("std");
const allocation_testing = @import("allocation_testing");
const Fixture = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, committed: bool) !void {
    var fixture = try Fixture.init(allocator);

    defer fixture.deinit();

    const state = fixture.state;

    {
        var request = state.request();

        defer request.deinit();

        try Fixture.left(&request, 7, try Fixture.values(&request, 5, 300));
    }

    const published = state.value_0;
    const original_right = state.value_1;

    {
        var request = state.request();

        defer request.deinit();

        if (committed) try Fixture.right(&request, 9, published.history[1..]);

        const right = state.value_1;

        try std.testing.expectError(error.MultipleStoreObjects, request.commit(.{ .store_0 = published, .store_1 = right }));
        try request.commit(.{ .store_0 = null, .store_1 = null });
        try std.testing.expectEqual(published, state.value_0);
        try std.testing.expectEqual(right, state.value_1);
    }

    try std.testing.expectEqualSlices(u64, &.{ 300, 301, 302, 303, 304 }, published.history);

    if (committed) {
        try std.testing.expectEqualSlices(u64, &.{ 301, 302, 303, 304 }, state.value_1.history);
    } else try std.testing.expectEqual(original_right, state.value_1);

    {
        var request = state.request();

        defer request.deinit();

        try Fixture.right(&request, 11, published.history[2..]);
    }

    try std.testing.expectEqualSlices(u64, &.{ 302, 303, 304 }, state.value_1.history);
}

test "rejected alias commit preserves earlier request state" {
    try run(std.testing.allocator, false);
}

test "rejected alias commit preserves earlier successful commit in same request" {
    try run(std.testing.allocator, true);
}

test "rejected alias commit then recovery allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "committed alias then rejection allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}
