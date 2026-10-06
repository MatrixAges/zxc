const std = @import("std");
const program = @import("program");
const host = @import("host");
const Mode = enum { inline_execution, threaded };

pub const Calls = struct {
    total: usize = 1,
    tasks: usize = 1,
};

pub fn output(input: program.Input, expected: program.Output, calls: Calls) !void {
    for ([_]Mode{ .inline_execution, .threaded }) |mode| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var threaded = std.Io.Threaded.init(std.testing.allocator, .{ .async_limit = if (mode == .threaded) .unlimited else .nothing });

        defer threaded.deinit();
        host.reset();

        const actual = try program.execute(&arena, input, threaded.io());

        if (program.Output == []const u64) {
            try std.testing.expectEqualSlices(u64, expected, actual);
        } else {
            try std.testing.expectEqual(expected, actual);
        }

        try expectCalls(mode, calls);
    }
}

pub fn failure(input: program.Input, expected: anyerror, calls: Calls) !void {
    for ([_]Mode{ .inline_execution, .threaded }) |mode| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var threaded = std.Io.Threaded.init(std.testing.allocator, .{ .async_limit = if (mode == .threaded) .unlimited else .nothing });

        defer threaded.deinit();
        host.reset();

        try std.testing.expectError(expected, program.execute(&arena, input, threaded.io()));
        try expectCalls(mode, calls);
    }
}

fn expectCalls(mode: Mode, expected: Calls) !void {
    try std.testing.expectEqual(expected.total, host.calls.load(.seq_cst));
    try std.testing.expectEqual(if (mode == .threaded) expected.tasks else 0, host.worker_calls.load(.seq_cst));
}
