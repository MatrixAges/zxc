const std = @import("std");
const program = @import("program");
const host = @import("host");
const options = @import("options");
const allocation_testing = @import("allocation_testing");
const universal = options.mode == .every;
const Case = struct { values: []const i64, rule: host.Rule = .positive, limit: usize = 0, failure: usize = 0, count: usize, result: bool };

fn execute(memory: std.mem.Allocator, args: Case) !void {
    var storage: [8194]i64 = @splat(-1234567);

    @memcpy(storage[1..][0..args.values.len], args.values);

    const original = storage;

    host.reset(args.rule, args.limit, args.failure);

    const fails = args.failure != 0 and args.failure <= args.count;
    const count = if (fails) args.failure else args.count;
    var arena = std.heap.ArenaAllocator.init(memory);

    defer arena.deinit();

    const actual = program.execute(&arena, storage[1..][0..args.values.len]);

    try std.testing.expectEqualSlices(i64, &original, &storage);
    try std.testing.expectEqual(count, host.calls);
    try std.testing.expectEqualSlices(i64, args.values[0..count], host.trace[0..count]);
    if (fails) try std.testing.expectError(error.NativeFailure, actual) else try std.testing.expectEqual(args.result, try actual);
    try std.testing.expectEqual(@as(usize, 0), arena.queryCapacity());
}

test "empty native predicates preserve identities and never call the host" {
    try execute(std.testing.allocator, .{ .values = &.{}, .failure = 1, .count = 0, .result = universal });
}

test "native predicates stop at the first decisive result" {
    const samples = [_]struct { values: []const i64, every: bool, some: bool, every_count: usize, some_count: usize }{
        .{ .values = &.{0}, .every = false, .some = false, .every_count = 1, .some_count = 1 },
        .{ .values = &.{1}, .every = true, .some = true, .every_count = 1, .some_count = 1 },
        .{ .values = &.{ 1, 0, 3 }, .every = false, .some = true, .every_count = 2, .some_count = 1 },
        .{ .values = &.{ 0, 1, 0 }, .every = false, .some = true, .every_count = 1, .some_count = 2 },
        .{ .values = &.{ -1, 0, 1 }, .every = false, .some = true, .every_count = 1, .some_count = 3 },
        .{ .values = &.{ 1, 1, 1 }, .every = true, .some = true, .every_count = 3, .some_count = 1 },
    };

    for (samples) |sample| try execute(std.testing.allocator, .{ .values = sample.values, .count = if (universal) sample.every_count else sample.some_count, .result = if (universal) sample.every else sample.some });
}

test "native predicates preserve all true and all false call counts" {
    for ([_]host.Rule{ .all, .none }) |rule| try execute(std.testing.allocator, .{ .values = &.{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }, .rule = rule, .count = if ((rule == .all) == universal) 10 else 1, .result = rule == .all });
}

test "native predicates use callback order independently of element values" {
    for ([_]usize{ 0, 1, 5, 9 }) |limit| try execute(std.testing.allocator, .{ .values = &.{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 }, .rule = .index, .limit = limit, .count = if (universal) @min(limit + 2, 10) else 1, .result = !universal or limit >= 9 });
}

test "native predicates propagate every reachable host failure" {
    for ([_]host.Rule{ .all, .none }) |rule| {
        for (1..12) |failure| try execute(std.testing.allocator, .{ .values = &.{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }, .rule = rule, .failure = failure, .count = if ((rule == .all) == universal) 10 else 1, .result = rule == .all });
    }
}

test "native predicates do not execute errors beyond the decisive result" {
    try execute(std.testing.allocator, .{ .values = &.{ 1, 0, 1, 0 }, .failure = 3, .count = if (universal) 2 else 1, .result = !universal });
    try execute(std.testing.allocator, .{ .values = &.{ 0, 1, 0, 1 }, .failure = 3, .count = if (universal) 1 else 2, .result = !universal });
}

test "native predicates scale without allocating a result container" {
    const values: [4096]i64 = @splat(1);

    try execute(std.testing.allocator, .{ .values = &values, .rule = if (universal) .all else .none, .count = 4096, .result = universal });
}

test "native predicates need no allocator for scalar callback execution" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execute, .{Case{ .values = &.{ 1, 2, 3 }, .rule = if (universal) .all else .none, .count = 3, .result = universal }});
}

test "native predicates keep scalar results independent across repeated calls" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var first = [_]i64{ 1, 2, 3 };
    var second = [_]i64{ 0, 0, 0 };

    host.reset(.all, 0, 0);

    const original = try program.execute(&arena, &first);

    try std.testing.expect(original);
    try std.testing.expectEqual(@as(usize, if (universal) 3 else 1), host.calls);

    host.reset(.none, 0, 0);

    try std.testing.expect(!try program.execute(&arena, &second));
    try std.testing.expectEqual(@as(usize, if (universal) 1 else 3), host.calls);
    try std.testing.expect(original);
    try std.testing.expectEqualSlices(i64, &.{ 1, 2, 3 }, &first);
    try std.testing.expectEqualSlices(i64, &.{ 0, 0, 0 }, &second);
    try std.testing.expectEqual(@as(usize, 0), arena.queryCapacity());
}
