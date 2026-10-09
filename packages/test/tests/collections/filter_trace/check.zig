const std = @import("std");
const program = @import("program");
const host = @import("host");

fn check(args: struct {
    input: []const i64,
    probe: host.Spec,
    expected: struct {
        calls: usize,
        visits: []const *const struct { item: i64, index: u64 },
        source_calls: usize,
        result: union(enum) { value: []const i64, failure: anyerror },
    },
}) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var storage: [8194]i64 = @splat(-1234567);

    @memcpy(storage[1..][0..args.input.len], args.input);

    const original = storage;
    const input = storage[1..][0..args.input.len];

    host.reset(args.probe);

    const result = program.execute(&arena, input);

    try std.testing.expectEqualSlices(i64, &original, &storage);
    try std.testing.expectEqual(args.expected.source_calls, host.source_calls);
    try std.testing.expectEqual(args.expected.calls, host.count);
    try std.testing.expectEqual(args.expected.visits.len, host.count);

    for (host.visits[0..host.count], args.expected.visits) |actual, expected| {
        try std.testing.expectEqual(expected.item, actual.item);
        try std.testing.expectEqual(expected.index, actual.index);
        try std.testing.expect(actual.source.ptr == input.ptr);
        try std.testing.expectEqual(input.len, actual.source.len);
        try std.testing.expectEqualSlices(i64, args.input, actual.source);
        try std.testing.expectEqual(actual.item, actual.source[@intCast(actual.index)]);
    }

    switch (args.expected.result) {
        .value => |value| try std.testing.expectEqualSlices(i64, value, try result),
        .failure => |failure| try std.testing.expectError(failure, result),
    }
}
