const std = @import("std");
const program = @import("program");
const left = @import("left");
const right = @import("right");
const Host = @import("host.zig");

comptime {
    _ = @import("refresh_test.zig");
}

const Case = struct {
    increment: u64,
    conflict_at: ?usize = null,
};

fn check(allocator: std.mem.Allocator, case: Case) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var left_state = try left.execute(&arena, {});
    var right_state = try right.execute(&arena, {});
    const original_left = left_state;
    const original_right = right_state;
    var host = Host{ .store_0 = &left_state, .store_1 = &right_state, .conflict_at = case.conflict_at };
    const actual = program.execute(&arena, case.increment, &host);

    try std.testing.expect(host.commits <= 2);
    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, original_right.history);
    try std.testing.expectEqual(@as(u64, 3) + (if (host.commits >= 1) case.increment else 0), left_state.value);
    try std.testing.expectEqual(@as(u64, 100) + (if (host.commits == 2) case.increment else 0), right_state.value);
    try std.testing.expectEqualSlices(u64, &.{if (host.commits >= 1) 9 else 8}, left_state.history);
    try std.testing.expectEqualSlices(u64, &.{if (host.commits == 2) 51 else 50}, right_state.history);

    if (actual) |_| {} else |err| {
        if (err == error.OutOfMemory) return err;
    }

    if (case.conflict_at) |index| {
        try std.testing.expectError(error.Conflict, actual);
        try std.testing.expectEqual(index - 1, host.commits);

        return;
    }

    const output = try actual;

    try std.testing.expectEqual(@as(usize, 2), host.commits);
    try std.testing.expectEqual(left_state.value, output.first);
    try std.testing.expectEqual(right_state.value, output.second);
    try std.testing.expectEqual(@as(u64, 3), output.before_left.value);
    try std.testing.expectEqual(@as(u64, 100), output.before_right.value);
    try std.testing.expectEqual(@as(u64, 100), output.untouched.value);
    try std.testing.expectEqualSlices(u64, &.{8}, output.before_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, output.before_right.history);
    try std.testing.expectEqualSlices(u64, &.{50}, output.untouched.history);
    try std.testing.expectEqual(left_state.value, output.after_left.value);
    try std.testing.expectEqual(right_state.value, output.after_right.value);
    try std.testing.expectEqualSlices(u64, &.{9}, output.after_left.history);
    try std.testing.expectEqualSlices(u64, &.{51}, output.after_right.history);
    try std.testing.expect(output.before_left.history.ptr != output.after_left.history.ptr);
    try std.testing.expect(output.before_right.history.ptr != output.after_right.history.ptr);
}

test "RX same named Store definitions keep distinct values" {
    try check(std.testing.allocator, .{ .increment = 7 });
}

test "RX two Store slots preserve isolated list updates with zero increment" {
    try check(std.testing.allocator, .{ .increment = 0 });
}

test "RX two Store slots each commit one increment" {
    try check(std.testing.allocator, .{ .increment = 1 });
}

test "RX two Store slots preserve maximum safe increment" {
    try check(std.testing.allocator, .{ .increment = std.math.maxInt(u64) - 100 });
}

test "RX first Store conflict preserves both initial values" {
    try check(std.testing.allocator, .{ .increment = 7, .conflict_at = 1 });
}

test "RX second Store conflict preserves first Store commit" {
    try check(std.testing.allocator, .{ .increment = 7, .conflict_at = 2 });
}

test "RX two Store successful execution allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .increment = 7 }});
}

test "RX two Store later conflict allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .increment = 7, .conflict_at = 2 }});
}

test "RX two Store repeated requests retain independent states and snapshots" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var left_state = try left.execute(&arena, {});
    var right_state = try right.execute(&arena, {});
    var host = Host{ .store_0 = &left_state, .store_1 = &right_state };
    const first = try program.execute(&arena, 1, &host);
    const second = try program.execute(&arena, 2, &host);

    try std.testing.expectEqual(@as(usize, 4), host.commits);
    try std.testing.expectEqual(@as(u64, 6), left_state.value);
    try std.testing.expectEqual(@as(u64, 103), right_state.value);
    try std.testing.expectEqual(@as(u64, 4), first.after_left.value);
    try std.testing.expectEqual(@as(u64, 101), first.after_right.value);
    try std.testing.expectEqual(@as(u64, 4), second.before_left.value);
    try std.testing.expectEqual(@as(u64, 101), second.before_right.value);
    try std.testing.expectEqual(@as(u64, 101), second.untouched.value);
    try std.testing.expectEqualSlices(u64, &.{9}, first.after_left.history);
    try std.testing.expectEqualSlices(u64, &.{51}, first.after_right.history);
    try std.testing.expectEqualSlices(u64, &.{10}, second.after_left.history);
    try std.testing.expectEqualSlices(u64, &.{52}, second.after_right.history);
}
