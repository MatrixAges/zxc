const std = @import("std");
const program = @import("program");
const left = @import("left");
const right = @import("right");
const Host = @import("refresh_host.zig");

const Case = struct {
    fail_at: ?usize = null,
    begins: usize = 7,
    commits: usize = 2,
    left_value: u64 = 304,
    right_value: u64 = 501,
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

        try std.testing.expectEqual(@as(u64, 103), output.before_left.value);
        try std.testing.expectEqual(@as(u64, 200), output.before_right.value);
        try std.testing.expectEqual(@as(u64, 300), output.untouched.value);
        try std.testing.expectEqual(@as(u64, 204), output.first);
        try std.testing.expectEqual(@as(u64, 401), output.second);
        try std.testing.expectEqual(@as(u64, 304), output.after_left.value);
        try std.testing.expectEqual(@as(u64, 501), output.after_right.value);
    }

    try std.testing.expectEqual(case.begins, host.begins);
    try std.testing.expectEqual(case.commits, host.commits);
    try std.testing.expectEqual(case.left_value, left_state.value);
    try std.testing.expectEqual(case.right_value, right_state.value);
    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, original_right.history);
    try std.testing.expectEqualSlices(u64, &.{if (case.commits >= 1) 9 else 8}, left_state.history);
    try std.testing.expectEqualSlices(u64, &.{if (case.commits == 2) 51 else 50}, right_state.history);
}

test "RX dual Store refresh maps local zero to the selected physical Object" {
    try check(std.testing.allocator, .{});
}

test "RX dual Store refresh success allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{}});
}

test "RX dual Store mapped refresh failure allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .fail_at = 5, .begins = 5, .commits = 1, .left_value = 204, .right_value = 300 }});
}

test "RX dual Store refresh failure at Call 1 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 1, .begins = 1, .commits = 0, .left_value = 3, .right_value = 100 });
}

test "RX dual Store refresh failure at Call 2 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 2, .begins = 2, .commits = 0, .left_value = 103, .right_value = 100 });
}

test "RX dual Store refresh failure at Call 3 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 3, .begins = 3, .commits = 0, .left_value = 103, .right_value = 200 });
}

test "RX dual Store refresh failure at Call 4 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 4, .begins = 4, .commits = 1, .left_value = 204, .right_value = 200 });
}

test "RX dual Store refresh failure at Call 5 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 5, .begins = 5, .commits = 1, .left_value = 204, .right_value = 300 });
}

test "RX dual Store refresh failure at Call 6 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 6, .begins = 6, .commits = 2, .left_value = 204, .right_value = 401 });
}

test "RX dual Store refresh failure at Call 7 preserves prior effects" {
    try check(std.testing.allocator, .{ .fail_at = 7, .begins = 7, .commits = 2, .left_value = 304, .right_value = 401 });
}
