const std = @import("std");
const program = @import("program");
const host = @import("host");
const options = @import("options");
const oracle = @import("oracle.zig");
pub const method = std.meta.stringToEnum(oracle.Method, options.method).?;
pub const Case = struct { values: []const i64, tag: i64 = -7, failure: host.Failure = .none, fail_at: usize = 0 };

pub fn execute(args: Case) !void {
    var storage: [8194]i64 = @splat(-987654321);

    @memcpy(storage[1..][0..args.values.len], args.values);

    const context = if (options.used) args.tag + 7 else 0;
    const expected = oracle.evaluate(method, args.values, context);
    const context_count: usize = if (args.failure == .source) 0 else 1;
    const callback_count: usize = if (args.failure == .source or args.failure == .context) 0 else if (args.failure == .callback and args.fail_at <= expected.count) args.fail_at else expected.count;

    host.reset(args.failure, args.fail_at);

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = @typeInfo(program.Input).pointer.child{ .items = storage[1..][0..args.values.len], .tag = args.tag };
    const input: program.Input = &value;
    const actual = program.execute(&arena, input);

    try std.testing.expectEqualSlices(i64, args.values, input.items);
    try std.testing.expectEqual(args.tag, input.tag);
    try std.testing.expectEqual(@as(i64, -987654321), storage[0]);
    try std.testing.expectEqual(@as(i64, -987654321), storage[args.values.len + 1]);
    try std.testing.expectEqual(@as(usize, 1), host.source_calls);
    try std.testing.expectEqual(context_count, host.context_calls);
    try std.testing.expectEqual(callback_count, host.calls);
    try std.testing.expectEqual(@as(usize, 1) + context_count + callback_count, host.event_count);
    try std.testing.expectEqual(@as(u8, 'S'), host.events[0]);

    if (context_count != 0) {
        try std.testing.expectEqual(@as(u8, 'C'), host.events[1]);
        try std.testing.expectEqual(args.tag, host.tag);
    }

    try std.testing.expectEqualSlices(i64, args.values[0..callback_count], host.items[0..callback_count]);

    for (host.contexts[0..callback_count], host.events[1 + context_count .. host.event_count]) |received, event| {
        try std.testing.expectEqual(context, received);
        try std.testing.expectEqual(@as(u8, 'V'), event);
    }

    switch (args.failure) {
        .source => return std.testing.expectError(error.SourceFailure, actual),
        .context => return std.testing.expectError(error.ContextFailure, actual),
        .callback => if (args.fail_at <= expected.count) return std.testing.expectError(error.CallbackFailure, actual),
        .none => {},
    }

    const output = try actual;

    if (method == .map or method == .filter) {
        try std.testing.expectEqualSlices(i64, expected.values[0..expected.len], output);
    } else {
        try std.testing.expectEqual(expected.decision, output);
    }
}
