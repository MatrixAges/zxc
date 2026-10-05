const std = @import("std");
const f = @import("fixture.zig");

fn run(allocator: std.mem.Allocator, overflow: bool) !void {
    var options = f.options(&.{"mirror"});

    options.env = &.{ &.{ .name = "A", .value = "first" }, &.{ .name = "A", .value = "last" } };

    if (overflow) options.max_stderr_bytes = 2;

    const result = f.child.spawnSyncWithInput(allocator, f.io, &.{ .options = &options, .input = &.{ 0, 1, 2, 255, 128 } }) catch |err| {
        if (err == error.OutOfMemory) return err;
        if (!overflow) return err;
        try std.testing.expectEqual(error.StreamTooLong, err);

        return;
    };

    defer f.free(allocator, result);

    try std.testing.expect(!overflow);
    try std.testing.expectEqualSlices(u8, &.{ 0, 1, 2, 255, 128 }, result.stdout);
    try std.testing.expectEqualSlices(u8, &.{ 0, 1, 2, 255, 128 }, result.stderr);
}

test "child input success releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, run, .{false});
}

test "child input limit failure releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(f.allocator, run, .{true});
}

test "child input success frees all result allocations" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try run(debug.allocator(), false);
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}

test "child input failure frees partial capture allocations" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try run(debug.allocator(), true);
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}
