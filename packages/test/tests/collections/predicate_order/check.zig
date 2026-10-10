const std = @import("std");
const program = @import("program");
const host = @import("host");

fn check(args: struct {
    input: program.Input,
    rule: host.Rule,
    cursor: u64,
    expected: struct {
        value: bool,
        calls: usize,
        cursor: u64,
        marked: []const u64,
        visits: []const *const struct { item: i64, index: u64 },
        events: []const host.Event,
    },
}) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var storage: [8194]i64 = @splat(-1234567);

    @memcpy(storage[1..][0..args.input.items.len], args.input.items);

    const original = storage;
    var input = args.input.*;
    input.items = storage[1..][0..args.input.items.len];

    const input_items = input.items;

    host.reset(args.rule, args.cursor);

    const actual = try program.execute(&arena, &input);

    try std.testing.expectEqual(args.expected.value, actual);
    try std.testing.expectEqual(args.expected.calls, host.count);
    try std.testing.expectEqual(args.expected.cursor, host.cursor);
    try std.testing.expectEqualSlices(host.Event, args.expected.events, host.events[0..host.event_count]);
    try std.testing.expectEqualSlices(i64, &original, &storage);
    try std.testing.expect(input.items.ptr == input_items.ptr);
    try std.testing.expectEqual(input_items.len, input.items.len);
    try std.testing.expectEqual(args.expected.visits.len, host.count);

    for (host.visits[0..host.count], args.expected.visits) |visit, expected| {
        try std.testing.expectEqual(expected.item, visit.item);
        try std.testing.expectEqual(expected.index, visit.index);
        try std.testing.expect(visit.source.ptr == input_items.ptr);
        try std.testing.expectEqualSlices(i64, args.input.items, visit.source);
        try std.testing.expectEqual(visit.item, visit.source[@intCast(visit.index)]);
    }

    for (host.marked, 0..) |marked, index| {
        try std.testing.expectEqual(std.mem.indexOfScalar(u64, args.expected.marked, index) != null, marked);
    }
}
