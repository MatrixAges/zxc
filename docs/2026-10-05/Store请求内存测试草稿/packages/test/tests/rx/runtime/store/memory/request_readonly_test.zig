const std = @import("std");
const State = @import("zxc_state");

fn check(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    for (0..3) |_| {
        var request = state.request();

        defer request.deinit();

        const output = try request.execute({});

        try std.testing.expectEqual(@as(u64, 3), output.first);
        try std.testing.expectEqual(@as(u64, 100), output.second);
    }
}

test "generated readonly Request executes using its own arena" {
    try check(std.testing.allocator);
}

test "generated readonly Request cleans every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{});
}

test "generated readonly Request releases output storage after each request" {
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

    for (0..64) |_| {
        {
            var request = state.request();

            defer request.deinit();

            const output = try request.execute({});

            try std.testing.expectEqual(@as(u64, 3), output.first);
            try std.testing.expectEqual(@as(u64, 100), output.second);
            try std.testing.expect(debug.total_requested_bytes > baseline);
        }

        try std.testing.expectEqual(baseline, debug.total_requested_bytes);
        try std.testing.expectEqual(left, state.value_0);
        try std.testing.expectEqual(right, state.value_1);
    }
}

test "generated readonly Request rejects publication and releases candidates" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    const left = state.value_0;
    var request = state.request();

    defer request.deinit();

    const candidate = try request.arena.allocator().create(@TypeOf(left.*));
    candidate.* = left.*;

    try std.testing.expectError(error.StoreNotWritable, request.commit(.{ .store_0 = candidate, .store_1 = null }));
    try std.testing.expectEqual(left, state.value_0);
}
