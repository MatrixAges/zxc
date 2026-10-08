const std = @import("std");
const program = @import("program");
const host = @import("host");
const options = @import("options");
const fixture = @import("fixture.zig");
const oracle = @import("oracle");
pub const method = std.meta.stringToEnum(oracle.Method, options.method).?;
pub const Case = struct { values: []const i64, variant: usize = 1, failure: host.Failure = .none, fail_at: usize = 0 };

pub fn run(arena: *std.heap.ArenaAllocator, args: Case) !?program.Output {
    var data = fixture.Data{};
    const context = data.init(args.variant);
    const original_first = data.first;
    const original_second = data.second;
    const original_context = data.context;

    var storage: [8194]i64 = @splat(-987654321);

    @memcpy(storage[1..][0..args.values.len], args.values);

    const expected = oracle.evaluate(method, args.values, data.score);
    const failed_callback = args.failure == .callback and args.fail_at <= expected.count;
    const count: usize = if (args.failure == .echo) 0 else if (failed_callback) args.fail_at else expected.count;
    const value = fixture.Input{ .items = storage[1..][0..args.values.len], .context = context };
    const input: program.Input = &value;

    host.reset(context, args.failure, args.fail_at);

    const actual = program.execute(arena, input);

    try std.testing.expectEqualSlices(i64, args.values, input.items);
    try std.testing.expectEqual(@as(i64, -987654321), storage[0]);
    try std.testing.expectEqual(@as(i64, -987654321), storage[args.values.len + 1]);
    try std.testing.expectEqualSlices(i64, &original_first, &data.first);
    try std.testing.expectEqualSlices(i64, &original_second, &data.second);
    if (options.kind != .list) try std.testing.expectEqualDeep(original_context, data.context);
    try std.testing.expectEqual(@as(usize, 1), host.echoes);
    try std.testing.expectEqual(count, host.calls);
    try std.testing.expect(!host.invalid_borrow);
    try std.testing.expectEqualSlices(i64, args.values[0..count], host.trace[0..count]);
    for (host.scores[0..count]) |score| try std.testing.expectEqual(data.score, score);

    if (args.failure == .echo or failed_callback) {
        try std.testing.expectError(error.NativeFailure, actual);

        return null;
    }

    const output = try actual;

    if (method == .map or method == .filter) {
        try std.testing.expectEqualSlices(i64, expected.values[0..expected.len], output);
    } else {
        try std.testing.expectEqual(expected.decision, output);
    }

    return output;
}
