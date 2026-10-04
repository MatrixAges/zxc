const std = @import("std");
const program = @import("program");
const initial = @import("initial");
const Host = @import("host.zig");

const Case = struct {
    increment: u64,
    state: u64,
    commits: usize,
    conflict_at: ?usize = null,
    result: union(enum) { values: struct { first: u64, second: u64 }, conflict },
};

fn check(allocator: std.mem.Allocator, case: Case) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = try initial.execute(&arena, {});
    const original = state;
    var host = Host{ .store_0 = &state, .conflict_at = case.conflict_at };
    const actual = program.execute(&arena, case.increment, &host);

    try std.testing.expectEqual(@as(u64, 3), original.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
    try std.testing.expect(host.commits <= 2);
    try std.testing.expectEqual(@as(u64, 3) + case.increment * @as(u64, @intCast(host.commits)), state.value);
    try std.testing.expectEqualSlices(u64, &.{8 + @as(u64, @intCast(host.commits))}, state.history);

    if (host.commits != 0) try std.testing.expect(state.history.ptr != original.history.ptr);

    if (actual) |_| {} else |err| {
        if (err == error.OutOfMemory) return err;
    }

    switch (case.result) {
        .values => |expected| {
            const output = try actual;

            try std.testing.expectEqual(expected.first, output.first);
            try std.testing.expectEqual(expected.second, output.second);
            try std.testing.expectEqual(case.state, output.current);
        },
        .conflict => try std.testing.expectError(error.Conflict, actual),
    }

    try std.testing.expectEqual(case.state, state.value);
    try std.testing.expectEqual(case.commits, host.commits);
}

test "RX declared Store zero increments still commit each Call" {
    try check(std.testing.allocator, .{ .increment = 0, .state = 3, .commits = 2, .result = .{ .values = .{ .first = 3, .second = 3 } } });
}

test "RX declared Store aliases share updated state" {
    try check(std.testing.allocator, .{ .increment = 1, .state = 5, .commits = 2, .result = .{ .values = .{ .first = 4, .second = 5 } } });
}

test "RX declared Store getter observes the previous Call commit" {
    try check(std.testing.allocator, .{ .increment = 7, .state = 17, .commits = 2, .result = .{ .values = .{ .first = 10, .second = 17 } } });
}

test "RX declared Store preserves maximum safe state" {
    const maximum = std.math.maxInt(u64);

    try check(std.testing.allocator, .{ .increment = (maximum - 3) / 2, .state = maximum, .commits = 2, .result = .{ .values = .{ .first = 9223372036854775809, .second = maximum } } });
}

test "RX declared Store first conflict preserves initial state" {
    try check(std.testing.allocator, .{ .increment = 1, .state = 3, .commits = 0, .conflict_at = 1, .result = .conflict });
}

test "RX declared Store later conflict preserves earlier commit" {
    try check(std.testing.allocator, .{ .increment = 7, .state = 10, .commits = 1, .conflict_at = 2, .result = .conflict });
}

test "RX declared Store successful execution allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .increment = 7, .state = 17, .commits = 2, .result = .{ .values = .{ .first = 10, .second = 17 } } }});
}

test "RX declared Store later conflict allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Case{ .increment = 7, .state = 10, .commits = 1, .conflict_at = 2, .result = .conflict }});
}

test "RX declared Store repeated calls do not reinitialize state" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = try initial.execute(&arena, {});
    const original = state;
    var host = Host{ .store_0 = &state };
    const first = try program.execute(&arena, 1, &host);
    const previous = state;
    const second = try program.execute(&arena, 2, &host);

    try std.testing.expectEqual(@as(u64, 4), first.first);
    try std.testing.expectEqual(@as(u64, 5), first.second);
    try std.testing.expectEqual(@as(u64, 5), first.current);
    try std.testing.expectEqual(@as(u64, 7), second.first);
    try std.testing.expectEqual(@as(u64, 9), second.second);
    try std.testing.expectEqual(@as(u64, 9), second.current);
    try std.testing.expectEqual(@as(u64, 9), state.value);
    try std.testing.expectEqual(@as(usize, 4), host.commits);
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
    try std.testing.expectEqualSlices(u64, &.{10}, previous.history);
    try std.testing.expectEqualSlices(u64, &.{12}, state.history);
}
