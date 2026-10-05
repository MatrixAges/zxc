const std = @import("std");
const allocation_testing = @import("allocation_testing");
const State = @import("zxc_state");
const f = @import("fixture");
const execute = @import("execute.zig");

fn failureRecovery(allocator: std.mem.Allocator, after_commit: bool) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();
    try fixture.write("good", "new");

    var input = try execute.input(&fixture, if (after_commit) "good" else "missing", "missing");
    const failed = execute.run(&state, &input, f.io);

    if (failed) |_| {} else |err| {
        if (err == error.OutOfMemory) return err;
    }

    try std.testing.expectError(error.FileNotFound, failed);
    try std.testing.expectEqual(@as(u64, if (after_commit) 1 else 0), state.value_0.count);

    input = try execute.input(&fixture, "good", "good");

    const output = try execute.run(&state, &input, f.io);

    try std.testing.expectEqualStrings("new", output.text);
    try std.testing.expectEqual(@as(u64, if (after_commit) 2 else 1), output.count);
}

test "Store IO failure before commit and recovery clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failureRecovery, .{false});
}

test "Store IO failure after commit and recovery clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(f.allocator, failureRecovery, .{true});
}

fn memory(after_commit: bool) !void {
    var fixture = try f.init();

    defer fixture.deinit();

    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    {
        var arena = std.heap.ArenaAllocator.init(debug.allocator());

        defer arena.deinit();

        var state = State{ .arena = &arena };

        defer state.deinit();

        try state.initialize();
        try fixture.write("good", "new");

        const baseline = debug.total_requested_bytes;
        const original = state.value_0;
        const input = try execute.input(&fixture, if (after_commit) "good" else "missing", "missing");

        try std.testing.expectError(error.FileNotFound, execute.run(&state, &input, f.io));

        if (after_commit) {
            try std.testing.expect(debug.total_requested_bytes > baseline);
            try std.testing.expectEqualStrings("new", state.value_0.text);
            try std.testing.expectEqual(@as(u64, 1), state.value_0.count);
        } else {
            try std.testing.expectEqual(baseline, debug.total_requested_bytes);
            try std.testing.expectEqual(original, state.value_0);
        }
    }

    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}

test "Store IO uncommitted error releases its entire request arena" {
    try memory(false);
}

test "Store IO committed error retains bytes until State and parent arena destruction" {
    try memory(true);
}
