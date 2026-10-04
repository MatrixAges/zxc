const std = @import("std");
const program = @import("program");
const left = @import("left");
const right = @import("right");
const Host = @import("nested_host.zig");

const Case = struct {
    fail_at: ?usize = null,
    begins: usize = 3,
    commits: usize = 1,
    left_value: u64 = 301,
    right_value: u64 = 300,
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

        try std.testing.expectEqual(@as(u64, 103), output.before.value);
        try std.testing.expectEqualSlices(u64, &.{8}, output.before.history);
        try std.testing.expectEqual(@as(u64, 200), output.child.initial.first);
        try std.testing.expectEqual(@as(u64, 203), output.child.initial.second);
        try std.testing.expectEqual(@as(u64, 301), output.child.written);
    }

    try std.testing.expectEqual(case.begins, host.begins);
    try std.testing.expectEqual(case.commits, host.commits);
    try std.testing.expectEqual(case.left_value, left_state.value);
    try std.testing.expectEqual(case.right_value, right_state.value);
    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, original_right.history);
    try std.testing.expectEqualSlices(u64, &.{if (case.commits == 0) 8 else 300}, left_state.history);
    try std.testing.expectEqualSlices(u64, &.{50}, right_state.history);
}

test "RX nested Store refresh permutes both read and write slots" {
    try check(std.testing.allocator, .{});
}

test "RX nested Store refresh permutation success allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{}});
}

test "RX nested Store refresh permutation failure allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .fail_at = 3, .commits = 0, .left_value = 203, .right_value = 200 }});
}

test "RX nested Store first refresh failure prevents service entry" {
    try check(std.testing.allocator, .{ .fail_at = 1, .begins = 1, .commits = 0, .left_value = 3, .right_value = 100 });
}

test "RX nested Store read refresh failure preserves outer snapshot" {
    try check(std.testing.allocator, .{ .fail_at = 2, .begins = 2, .commits = 0, .left_value = 103, .right_value = 100 });
}

test "RX nested Store write refresh failure preserves earlier multi Object refresh" {
    try check(std.testing.allocator, .{ .fail_at = 3, .commits = 0, .left_value = 203, .right_value = 200 });
}
