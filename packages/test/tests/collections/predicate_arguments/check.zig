const std = @import("std");
const program = @import("program");
const host = @import("host");

fn check(args: struct {
    input: program.Input,
    probe: host.Spec,
    expected: struct {
        calls: usize,
        visits: []const *const struct { item: i64, index: u64 },
        source_calls: usize,
        result: union(enum) { value: bool, failure: anyerror },
    },
}) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var storage: [8194]i64 = @splat(-1234567);

    @memcpy(storage[1..][0..args.input.items.len], args.input.items);

    const original = storage;
    var input = args.input.*;

    input.items = storage[1..][0..args.input.items.len];

    host.reset(args.probe);

    const result = program.execute(&arena, &input);

    try std.testing.expectEqualSlices(i64, &original, &storage);
    try std.testing.expectEqual(args.expected.source_calls, host.source_calls);
    try std.testing.expectEqualDeep(args.input.*, input);
    try std.testing.expectEqual(args.expected.calls, host.count);
    try std.testing.expectEqual(args.expected.visits.len, host.count);

    for (host.visits[0..host.count], args.expected.visits) |actual, expected| {
        try std.testing.expectEqual(expected.item, actual.item);
        try std.testing.expectEqual(expected.index, actual.index);
        try std.testing.expect(actual.source.ptr == input.items.ptr);
        try std.testing.expectEqual(input.items.len, actual.source.len);
        try std.testing.expectEqualSlices(i64, args.input.items, actual.source);
        try std.testing.expectEqual(actual.item, actual.source[@intCast(actual.index)]);
    }

    switch (args.expected.result) {
        .value => |value| try std.testing.expectEqual(value, try result),
        .failure => |failure| try std.testing.expectError(failure, result),
    }
}
