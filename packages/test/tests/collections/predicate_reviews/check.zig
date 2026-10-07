const std = @import("std");
const program = @import("program");
const host = @import("host");

fn check(args: struct {
    input: []const i64,
    probe: host.Spec,
    expected: struct {
        calls: usize,
        visited: []const i64,
        input: []const i64,
        result: union(enum) { value: bool, failure: anyerror },
    },
}) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var storage: [8194]i64 = @splat(-1234567);

    @memcpy(storage[1..][0..args.input.len], args.input);

    const original = storage;

    host.reset(args.probe);

    const result = program.execute(&arena, storage[1..][0..args.input.len]);

    try std.testing.expectEqualSlices(i64, &original, &storage);
    try std.testing.expectEqualSlices(i64, args.expected.input, storage[1..][0..args.input.len]);
    try std.testing.expectEqual(args.expected.calls, host.calls);
    try std.testing.expectEqualSlices(i64, args.expected.visited, host.trace[0..host.calls]);
    try std.testing.expectEqual(@as(usize, 0), arena.queryCapacity());

    switch (args.expected.result) {
        .value => |value| try std.testing.expectEqual(value, try result),
        .failure => |failure| try std.testing.expectError(failure, result),
    }
}
