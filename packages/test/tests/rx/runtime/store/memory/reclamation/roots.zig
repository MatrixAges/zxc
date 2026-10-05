const std = @import("std");
const allocation_testing = @import("allocation_testing");
const Fixture = @import("fixture.zig");
const State = @import("zxc_state");

fn publish(request: *State.Request, left: bool, value: u64) !void {
    const values = try request.arena.allocator().alloc(u64, 256);

    @memset(values, value);

    if (left) {
        const candidate = try request.arena.allocator().create(std.meta.Child(@TypeOf(request.parent.value_0)));

        candidate.* = .{ .value = value, .history = values };

        try request.commit(.{ .store_0 = candidate, .store_1 = null });
    } else {
        const candidate = try request.arena.allocator().create(std.meta.Child(@TypeOf(request.parent.value_1)));

        candidate.* = .{ .value = value, .history = values };

        try request.commit(.{ .store_0 = null, .store_1 = candidate });
    }
}

fn run(allocator: std.mem.Allocator, together: bool) !void {
    var tracked = std.testing.FailingAllocator.init(allocator, .{});
    var fixture = try Fixture.init(tracked.allocator());

    defer fixture.deinit();

    const state = fixture.state;

    {
        var request = state.request();

        defer request.deinit();

        try publish(&request, true, 10);

        if (together) try publish(&request, false, 20);
    }

    if (!together) {
        var request = state.request();

        defer request.deinit();

        try publish(&request, false, 20);
    }

    const active_bytes = tracked.allocated_bytes - tracked.freed_bytes;

    state.releaseRetired();

    try std.testing.expectEqual(active_bytes, tracked.allocated_bytes - tracked.freed_bytes);
    try state.commit(.{ .store_0 = null, .store_1 = null });
    try std.testing.expectError(error.MultipleStoreObjects, state.commit(.{ .store_0 = state.value_0, .store_1 = state.value_1 }));

    {
        var request = state.request();

        defer request.deinit();

        try publish(&request, true, 30);
    }

    const before_left = tracked.freed_bytes;

    state.releaseRetired();

    if (together) {
        try std.testing.expectEqual(before_left, tracked.freed_bytes);
    } else try std.testing.expect(tracked.freed_bytes > before_left);

    for (state.value_0.history) |item| try std.testing.expectEqual(@as(u64, 30), item);
    for (state.value_1.history) |item| try std.testing.expectEqual(@as(u64, 20), item);

    {
        var request = state.request();

        defer request.deinit();

        try publish(&request, false, 40);
    }

    const before_right = tracked.freed_bytes;

    state.releaseRetired();

    try std.testing.expect(tracked.freed_bytes > before_right);
    for (state.value_0.history) |item| try std.testing.expectEqual(@as(u64, 30), item);
    for (state.value_1.history) |item| try std.testing.expectEqual(@as(u64, 40), item);
}

test "two Store roots retain two independent current request regions" {
    try run(std.testing.allocator, false);
}

test "one remaining Store root keeps its shared request region alive" {
    try run(std.testing.allocator, true);
}

test "independent region roots and empty or rejected direct commits allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{false});
}

test "shared request root lifetime allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{true});
}
