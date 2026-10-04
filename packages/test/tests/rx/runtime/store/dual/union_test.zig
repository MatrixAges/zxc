const std = @import("std");
const program = @import("program");
const left = @import("left");
const right = @import("right");
const Host = @import("union_host.zig");

const Case = struct {
    fail_at: ?usize = null,
    begins: usize = 5,
    commits: usize = 3,
    left_value: u64 = 203,
    right_value: u64 = 2,
};

fn check(allocator: std.mem.Allocator, case: Case) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var left_state = try left.execute(&arena, {});
    var right_state = try right.execute(&arena, {});
    const original_left = left_state;
    const original_right = right_state;
    var host = Host{ .store_0 = &left_state, .store_1 = &right_state, .arena = &arena, .fail_at = case.fail_at };
    const actual = program.execute(&arena, 1, &host);

    if (actual) |_| {} else |err| {
        if (err == error.OutOfMemory) return err;
    }

    if (case.fail_at != null) {
        try std.testing.expectError(error.RefreshFailed, actual);
    } else {
        const output = try actual;

        try std.testing.expectEqual(@as(u64, 103), output.before.first);
        try std.testing.expectEqual(@as(u64, 103), output.before.second);
        try std.testing.expectEqual(@as(u64, 204), output.written);
        try std.testing.expectEqual(@as(u64, 304), output.after.first);
        try std.testing.expectEqual(@as(u64, 304), output.after.second);
        try std.testing.expectEqual(@as(u64, 405), output.overlap);
        try std.testing.expectEqual(@as(u64, 2), output.only);
    }

    try std.testing.expectEqual(case.begins, host.begins);
    try std.testing.expectEqual(case.commits, host.commits);
    try std.testing.expectEqual(case.left_value, left_state.value);
    try std.testing.expectEqual(case.right_value, right_state.value);
    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, original_right.history);
    try std.testing.expectEqualSlices(u64, &.{8}, left_state.history);

    const history: u64 = switch (case.commits) {
        0 => 50,
        1 => 203,
        2 => 404,
        3 => 1,
        else => return error.UnexpectedCommitCount,
    };

    try std.testing.expectEqualSlices(u64, &.{history}, right_state.history);
}

test "RX Store refresh merges duplicate getters and setter requirements per Call" {
    try check(std.testing.allocator, .{});
}

test "RX Store refresh merged slots success allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{}});
}

test "RX Store refresh setter only failure allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .fail_at = 5, .commits = 2, .right_value = 405 }});
}

test "RX merged Store refresh failure at Call 1 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 1, .begins = 1, .commits = 0, .left_value = 3, .right_value = 100 });
}

test "RX merged Store refresh failure at Call 2 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 2, .begins = 2, .commits = 0, .left_value = 103, .right_value = 100 });
}

test "RX merged Store refresh failure at Call 3 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 3, .begins = 3, .commits = 1, .left_value = 203, .right_value = 204 });
}

test "RX merged Store refresh failure at Call 4 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 4, .begins = 4, .commits = 1, .left_value = 203, .right_value = 304 });
}

test "RX merged Store refresh failure at Call 5 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 5, .begins = 5, .commits = 2, .left_value = 203, .right_value = 405 });
}
