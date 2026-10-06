const std = @import("std");
const program = @import("program");
const probe = @import("host").probe;
const backend = @import("io_backend.zig");

pub const Expected = struct {
    result: union(enum) { value: u64, failure: anyerror },
    source_tags: []const u8 = &.{ 1, 2 },
    branches: usize = 2,
    reverse_completion: bool = true,
    release_on_await: bool = false,
    fail_at: usize = 0,
    unavailable: bool = false,
    attempts: ?usize = null,
    awaits: ?usize = null,
    cancels: usize = 0,
    canceled: usize = 0,
    overlap: ?usize = null,
};

pub fn run(input: program.Input, expected: Expected) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var threaded = std.Io.Threaded.init(std.testing.allocator, .{ .async_limit = .nothing, .concurrent_limit = if (expected.unavailable) .nothing else .unlimited });

    defer threaded.deinit();

    const original = threaded.io();
    var vtable = original.vtable.*;
    vtable.concurrent = backend.concurrent;
    vtable.await = backend.wait;
    vtable.cancel = backend.cancel;
    const io = std.Io{ .userdata = original.userdata, .vtable = &vtable };

    probe.reset(.{ .branches = expected.branches, .reverse_completion = expected.reverse_completion, .release_on_await = expected.release_on_await, .fail_at = expected.fail_at });

    defer probe.releaseAll(io);

    const actual = program.execute(&arena, input, io);

    switch (expected.result) {
        .value => |value| try std.testing.expectEqual(value, try actual),
        .failure => |err| try std.testing.expectError(err, actual),
    }

    try std.testing.expectEqual(expected.attempts orelse expected.branches, probe.attempts.load(.seq_cst));
    try std.testing.expectEqual(expected.awaits orelse expected.branches, probe.awaits.load(.seq_cst));
    try std.testing.expectEqual(expected.cancels, probe.cancels.load(.seq_cst));
    try std.testing.expectEqual(expected.canceled, probe.canceled.load(.seq_cst));
    try std.testing.expectEqual(expected.source_tags.len, probe.arrivals.load(.seq_cst));
    try std.testing.expectEqual(expected.source_tags.len, probe.finished.load(.seq_cst));
    try std.testing.expectEqual(expected.source_tags.len, probe.workers.load(.seq_cst));
    try std.testing.expectEqual(@as(usize, 0), probe.active.load(.seq_cst));
    try std.testing.expectEqual(expected.overlap orelse expected.branches, probe.overlap.load(.seq_cst));
    try std.testing.expectEqualSlices(u8, expected.source_tags, probe.arrival_trace[0..expected.source_tags.len]);

    const completions = probe.completion_trace[0..expected.source_tags.len];

    if (expected.reverse_completion) {
        try std.testing.expect(std.mem.indexOfScalar(u8, completions, 2).? < std.mem.indexOfScalar(u8, completions, 1).?);
    }

    if (expected.release_on_await) {
        try std.testing.expect(probe.second_awaited_after_first.load(.seq_cst));
        try std.testing.expect(std.mem.indexOfScalar(u8, completions, 1).? < std.mem.indexOfScalar(u8, completions, 2).?);
    }
}
