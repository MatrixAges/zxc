const std = @import("std");
const allocation_testing = @import("allocation_testing");
const application = @import("application");
const State = @import("zxc_state");

fn check(allocator: std.mem.Allocator, fail_first: bool) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const original_left = state.value_0;
    const original_right = state.value_1;
    const actual = executeRequest(&state, &.{ .increment = 7, .left_index = if (fail_first) 1 else 0, .right_index = if (fail_first) 0 else 1 });

    if (actual) |_| {} else |err| {
        if (err == error.OutOfMemory) return err;
    }

    try std.testing.expectError(error.IndexOutOfBounds, actual);
    try std.testing.expectEqual(@as(u64, if (fail_first) 3 else 10), state.value_0.value);
    try std.testing.expectEqual(original_right, state.value_1);

    const after_failure = state.value_0;
    const result = try executeRequest(&state, &.{ .increment = 2, .left_index = 0, .right_index = 0 });

    try std.testing.expectEqual(@as(u64, if (fail_first) 9 else 10), result.first);
    try std.testing.expectEqual(@as(u64, 51), result.second);
    try std.testing.expectEqual(@as(u64, if (fail_first) 5 else 12), state.value_0.value);
    try std.testing.expectEqual(@as(u64, 102), state.value_1.value);
    try std.testing.expectEqual(@as(u64, if (fail_first) 3 else 10), after_failure.value);
    try std.testing.expectEqualSlices(u64, &.{if (fail_first) 8 else 9}, after_failure.history);
    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, original_right.history);
}

test "generated Request first failing setter discards pending data and remains usable" {
    try check(std.testing.allocator, true);
}

test "generated Request later failing setter preserves earlier publication" {
    try check(std.testing.allocator, false);
}

test "generated Request first failure and recovery allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{true});
}

test "generated Request later failure and recovery allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{false});
}

fn executeRequest(state: *State, input: application.Input) !application.Output {
    var request = state.request();

    defer request.deinit();

    return request.execute(input);
}

test "generated Request failure before publication releases all temporary memory" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    var arena = std.heap.ArenaAllocator.init(debug.allocator());

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const baseline = debug.total_requested_bytes;
    const left = state.value_0;
    const right = state.value_1;

    try std.testing.expectError(error.IndexOutOfBounds, executeRequest(&state, &.{ .increment = 7, .left_index = 1, .right_index = 0 }));
    try std.testing.expectEqual(baseline, debug.total_requested_bytes);
    try std.testing.expectEqual(left, state.value_0);
    try std.testing.expectEqual(right, state.value_1);
}

test "generated Request failure after publication retains committed data until State destruction" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    {
        var arena = std.heap.ArenaAllocator.init(debug.allocator());

        defer arena.deinit();

        var state = State{ .arena = &arena };

        defer state.deinit();

        try state.initialize();

        const baseline = debug.total_requested_bytes;
        const right = state.value_1;

        try std.testing.expectError(error.IndexOutOfBounds, executeRequest(&state, &.{ .increment = 7, .left_index = 0, .right_index = 1 }));
        try std.testing.expect(debug.total_requested_bytes > baseline);
        try std.testing.expectEqual(@as(u64, 10), state.value_0.value);
        try std.testing.expectEqualSlices(u64, &.{9}, state.value_0.history);
        try std.testing.expectEqual(right, state.value_1);
    }

    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}
