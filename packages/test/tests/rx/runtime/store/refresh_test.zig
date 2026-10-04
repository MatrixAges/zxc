const std = @import("std");
const program = @import("program");
const initial = @import("initial");
const Host = @import("refresh_host.zig");

const Case = struct {
    snapshots: [3]u64 = .{ 10, 20, 30 },
    fail_at: ?usize = null,
    begins: usize = 3,
    commits: usize = 2,
    state: u64 = 30,
};

fn check(allocator: std.mem.Allocator, case: Case) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = try initial.execute(&arena, {});
    const original = state;
    var host = Host{ .store_0 = &state, .arena = &arena, .snapshots = case.snapshots, .fail_at = case.fail_at };
    const actual = program.execute(&arena, 1, &host);

    if (actual) |_| {} else |err| {
        if (err == error.OutOfMemory) return err;
    }

    if (case.fail_at != null) {
        try std.testing.expectError(error.RefreshFailed, actual);
    } else {
        const output = try actual;

        try std.testing.expectEqual(case.snapshots[0] + 1, output.first);
        try std.testing.expectEqual(case.snapshots[1] + 1, output.second);
        try std.testing.expectEqual(case.snapshots[2], output.current);
    }

    try std.testing.expectEqual(case.begins, host.begins);
    try std.testing.expectEqual(case.commits, host.commits);
    try std.testing.expectEqual(case.state, state.value);
    try std.testing.expectEqual(@as(u64, 3), original.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
    try std.testing.expectEqualSlices(u64, &.{8 + @as(u64, @intCast(case.commits))}, state.history);
}

test "RX Store refresh precedes each getter and observes external snapshots" {
    try check(std.testing.allocator, .{});
}

test "RX Store refresh preserves maximum u64 snapshot values" {
    const maximum = std.math.maxInt(u64);

    try check(std.testing.allocator, .{ .snapshots = .{ maximum - 1, maximum - 1, maximum }, .state = maximum });
}

test "RX Store first refresh failure prevents all calls" {
    try check(std.testing.allocator, .{ .fail_at = 1, .begins = 1, .commits = 0, .state = 3 });
}

test "RX Store second refresh failure preserves the first commit" {
    try check(std.testing.allocator, .{ .fail_at = 2, .begins = 2, .commits = 1, .state = 11 });
}

test "RX Store read refresh failure preserves both earlier commits" {
    try check(std.testing.allocator, .{ .fail_at = 3, .commits = 2, .state = 21 });
}

test "RX Store refresh successful execution allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{}});
}

test "RX Store later refresh failure allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .fail_at = 2, .begins = 2, .commits = 1, .state = 11 }});
}
