const std = @import("std");
const program = @import("program");
pub const host = @import("host");
const options = @import("options");
pub const Value = host.Value;
pub const seeded = options.seeded;
pub const text = options.kind == .text;
pub const Case = struct { values: []const Value, seed: Value = if (text) "seed" else 17, failure: host.Failure = .none, fail_at: usize = 0 };

fn equal(expected: Value, actual: Value) !void {
    if (text) try std.testing.expectEqualStrings(expected, actual) else try std.testing.expectEqual(expected, actual);
}

pub fn execute(args: Case) !void {
    var storage: [8194]Value = @splat(if (text) "canary" else -987654321);

    @memcpy(storage[1..][0..args.values.len], args.values);

    const start: usize = if (seeded) 0 else @min(1, args.values.len);
    const available = args.values.len - start;
    const initial_count: usize = if (seeded and args.failure != .source) 1 else 0;
    const count = if (args.failure == .source or (seeded and args.failure == .seed)) 0 else if (args.failure == .callback and args.fail_at <= available) args.fail_at else available;

    host.reset(args.failure, args.fail_at);

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input = @typeInfo(program.Input).pointer.child{ .items = storage[1..][0..args.values.len], .seed = args.seed };
    const actual = program.execute(&arena, &input);

    try std.testing.expectEqual(@as(usize, 1), host.source_calls);
    try std.testing.expectEqual(initial_count, host.seed_calls);
    try std.testing.expectEqual(count, host.count);
    try std.testing.expectEqual(1 + initial_count + count, host.event_count);
    try std.testing.expectEqual(@as(u8, 'S'), host.events[0]);
    if (initial_count != 0) try std.testing.expectEqual(@as(u8, 'I'), host.events[1]);

    for (host.visits[0..count], 0..) |visit, offset| {
        const index = start + offset;
        const previous = if (index == 0) args.seed else args.values[index - 1];

        try equal(previous, visit.previous);
        try equal(args.values[index], visit.current);
        try std.testing.expectEqual(@as(u64, @intCast(index)), visit.index);
        try std.testing.expect(visit.source.ptr == input.items.ptr);
        try std.testing.expectEqual(input.items.len, visit.source.len);
        try std.testing.expectEqual(@as(u8, 'V'), host.events[1 + initial_count + offset]);
    }

    for (args.values, input.items) |expected, value| try equal(expected, value);

    try equal(args.seed, input.seed);
    try equal(if (text) "canary" else -987654321, storage[0]);
    try equal(if (text) "canary" else -987654321, storage[args.values.len + 1]);
    if (args.failure == .source) return std.testing.expectError(error.SourceFailure, actual);
    if (seeded and args.failure == .seed) return std.testing.expectError(error.SeedFailure, actual);
    if (!seeded and args.values.len == 0) return std.testing.expectError(error.IndexOutOfBounds, actual);
    if (args.failure == .callback and args.fail_at <= available) return std.testing.expectError(error.CallbackFailure, actual);

    const value = try actual;
    const expected = if (args.values.len == 0) args.seed else args.values[args.values.len - 1];

    try equal(expected, value);
}
