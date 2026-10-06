const std = @import("std");
const program = @import("program");
const probe = @import("host").probe;

pub const Expected = struct {
    result: union(enum) { value: u64, failure: anyerror },
    mode: enum { inline_execution, threaded } = .threaded,
    canceled: usize = 1,
    after: usize = 0,
    outer: usize = 0,
    hold_cleanup: bool = false,
    completed_start: bool = false,
};

pub fn run(input: program.Input, expected: Expected) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var threaded = std.Io.Threaded.init(std.testing.allocator, .{ .async_limit = if (expected.mode == .threaded) .unlimited else .nothing });

    defer threaded.deinit();

    const original = threaded.io();
    var vtable = original.vtable.*;
    vtable.async = @import("completed_io.zig").start;

    const io = if (expected.completed_start) std.Io{ .userdata = original.userdata, .vtable = &vtable } else original;

    probe.reset(expected.hold_cleanup);

    const controller: ?std.Thread = if (expected.hold_cleanup) try std.Thread.spawn(.{}, probe.controller, .{io}) else null;

    defer if (controller) |thread| thread.join();
    defer probe.releaseAll(io);

    const actual = program.execute(&arena, input, io);

    switch (expected.result) {
        .value => |value| try std.testing.expectEqual(value, try actual),
        .failure => |err| try std.testing.expectError(err, actual),
    }

    try std.testing.expectEqual(@as(usize, 1), probe.started.load(.seq_cst));
    try std.testing.expectEqual(@as(usize, 1), probe.finished.load(.seq_cst));
    try std.testing.expectEqual(@as(usize, if (expected.mode == .threaded) 1 else 0), probe.workers.load(.seq_cst));
    try std.testing.expectEqual(expected.canceled, probe.canceled.load(.seq_cst));
    try std.testing.expectEqual(expected.after, probe.after_calls.load(.seq_cst));
    try std.testing.expectEqual(expected.outer, probe.outer_calls.load(.seq_cst));
    try std.testing.expectEqual(@as(usize, if (expected.hold_cleanup) 1 else 0), probe.released.load(.seq_cst));
    try std.testing.expectEqual(@as(usize, if (expected.completed_start) 1 else 0), probe.completed_starts.load(.seq_cst));
    try std.testing.expect(!probe.controller_failed.load(.seq_cst));
}
