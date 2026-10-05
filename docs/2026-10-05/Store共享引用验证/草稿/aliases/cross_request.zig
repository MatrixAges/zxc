const std = @import("std");
const Fixture = @import("fixture.zig");
const Case = struct { count: usize = 17, start: usize = 0, end: usize = 17, replacements: usize = 1 };

fn run(allocator: std.mem.Allocator, case: Case) !void {
    var fixture = try Fixture.init(allocator);

    defer fixture.deinit();

    const state = &fixture.state;

    {
        var request = state.request();

        defer request.deinit();

        try Fixture.left(&request, 100, try Fixture.values(&request, case.count, 1000));
    }

    const first = state.value_0;

    {
        var request = state.request();

        defer request.deinit();

        try Fixture.right(&request, 200, first.history[case.start..case.end]);
    }

    const shared = state.value_1;

    for (0..case.replacements) |index| {
        var request = state.request();

        defer request.deinit();

        try Fixture.left(&request, @intCast(index), try Fixture.values(&request, 65, 9000));
    }

    for (first.history, 0..) |item, index| try std.testing.expectEqual(1000 + @as(u64, @intCast(index)), item);
    try std.testing.expectEqualSlices(u64, first.history[case.start..case.end], state.value_1.history);
    try std.testing.expectEqual(@as(u64, 200), state.value_1.value);

    {
        var request = state.request();

        defer request.deinit();

        try Fixture.right(&request, 300, try Fixture.values(&request, 3, 7000));
    }

    try std.testing.expectEqualSlices(u64, first.history[case.start..case.end], shared.history);
    try std.testing.expectEqual(@as(u64, 100), first.value);
    try std.testing.expectEqualSlices(u64, &.{ 7000, 7001, 7002 }, state.value_1.history);
}

test "cross Store full slice survives source slot replacement" {
    try run(std.testing.allocator, .{});
}

test "cross Store interior slice survives source region end" {
    try run(std.testing.allocator, .{ .start = 3, .end = 13 });
}

test "cross Store empty tail slice remains valid" {
    try run(std.testing.allocator, .{ .start = 17, .end = 17 });
}

test "cross Store single element slice remains valid" {
    try run(std.testing.allocator, .{ .start = 8, .end = 9 });
}

test "cross Store large slice survives repeated unrelated writes" {
    try run(std.testing.allocator, .{ .count = 4096, .start = 7, .end = 4001, .replacements = 64 });
}

test "cross Store shared history releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .start = 3, .end = 13, .replacements = 3 }});
}

test "cross Store final destruction releases all live and historical slices" {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer std.testing.expectEqual(.ok, debug.deinit()) catch @panic("leak");

    try run(debug.allocator(), .{ .replacements = 64 });
    try std.testing.expectEqual(@as(usize, 0), debug.total_requested_bytes);
}
