const std = @import("std");
const allocation_testing = @import("allocation_testing");
const application = @import("application");
const State = @import("zxc_state");

fn continuity(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const initial = state.value_0;
    var outputs: [3]application.Output = undefined;
    const increments = [_]u64{ 1, 7, 2 };

    for (increments, &outputs) |increment, *output| {
        var request = state.request();

        defer request.deinit();

        output.* = try request.execute(increment);
    }

    var total: u64 = 0;

    for (increments, outputs, 0..) |increment, output, index| {
        try std.testing.expectEqual(3 + total, output.before_left.value);
        try std.testing.expectEqual(100 + total, output.before_right.value);

        total += increment;

        try std.testing.expectEqual(3 + total, output.after_left.value);
        try std.testing.expectEqual(100 + total, output.after_right.value);
        try std.testing.expectEqualSlices(u64, &.{9 + @as(u64, @intCast(index))}, output.after_left.history);
        try std.testing.expectEqualSlices(u64, &.{51 + @as(u64, @intCast(index))}, output.after_right.history);
    }

    try std.testing.expectEqual(@as(u64, 3), initial.value);
    try std.testing.expectEqualSlices(u64, &.{8}, initial.history);
    try std.testing.expectEqual(@as(u64, 13), state.value_0.value);
    try std.testing.expectEqual(@as(u64, 110), state.value_1.value);
}

test "generated Request retains published values and outputs after request destruction" {
    try continuity(std.testing.allocator);
}

test "generated Request continuity releases all failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, continuity, .{});
}

test "generated Request empty commit releases its independent arena" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    var arena = std.heap.ArenaAllocator.init(debug.allocator());

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const baseline = debug.total_requested_bytes;
    const original = state.value_0;

    {
        var request = state.request();

        defer request.deinit();

        const bytes = try request.arena.allocator().alloc(u8, 8192);

        @memset(bytes, 0x5a);

        try request.commit(.{ .store_0 = null, .store_1 = null });
        try std.testing.expect(debug.total_requested_bytes > baseline);
    }

    try std.testing.expectEqual(baseline, debug.total_requested_bytes);
    try std.testing.expectEqual(original, state.value_0);
}

test "generated Request rejected multi Object commit releases candidate storage" {
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

    {
        var request = state.request();

        defer request.deinit();

        const candidate = try request.arena.allocator().create(@TypeOf(left.*));
        candidate.* = left.*;

        try std.testing.expectError(error.MultipleStoreObjects, request.commit(.{ .store_0 = candidate, .store_1 = right }));
    }

    try std.testing.expectEqual(baseline, debug.total_requested_bytes);
    try std.testing.expectEqual(left, state.value_0);
    try std.testing.expectEqual(right, state.value_1);
}

test "generated State destruction releases committed request arenas" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try continuity(debug.allocator());
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}

test "generated Request isolates two live State instances" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var other_arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer other_arena.deinit();

    var state = State{ .arena = &arena };
    var other = State{ .arena = &other_arena };

    defer state.deinit();
    defer other.deinit();

    try state.initialize();
    try other.initialize();

    {
        var request = state.request();

        defer request.deinit();

        _ = try request.execute(7);
    }

    try std.testing.expectEqual(@as(u64, 10), state.value_0.value);
    try std.testing.expectEqual(@as(u64, 3), other.value_0.value);
    try std.testing.expectEqual(@as(u64, 100), other.value_1.value);
}

test "generated overlapping Request lifetimes observe current committed slots" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    var first_output: application.Output = undefined;

    {
        var first = state.request();
        var second = state.request();

        defer first.deinit();
        defer second.deinit();

        first_output = try first.execute(1);

        const next = try second.execute(2);

        try std.testing.expectEqual(@as(u64, 4), next.before_left.value);
        try std.testing.expectEqual(@as(u64, 101), next.before_right.value);
    }

    try std.testing.expectEqual(@as(u64, 4), first_output.after_left.value);
    try std.testing.expectEqual(@as(u64, 6), state.value_0.value);
    try std.testing.expectEqual(@as(u64, 103), state.value_1.value);
}

test "generated Request finite write sequence retains earliest snapshot" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const original = state.value_0;

    for (0..32) |index| {
        var request = state.request();

        defer request.deinit();

        const result = try request.execute(1);

        try std.testing.expectEqual(4 + @as(u64, @intCast(index)), result.after_left.value);
        try std.testing.expectEqualSlices(u64, &.{9 + @as(u64, @intCast(index))}, result.after_left.history);
    }

    try std.testing.expectEqual(@as(u64, 3), original.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
    try std.testing.expectEqual(@as(u64, 35), state.value_0.value);
}
