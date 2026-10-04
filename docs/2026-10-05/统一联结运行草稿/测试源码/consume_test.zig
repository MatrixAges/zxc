const std = @import("std");
const alpha = @import("alpha");
const beta = @import("beta");
const repeat = @import("repeat");

test "unified alpha executes nested dependency results" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]u64{ 0, 1, 7, 42, 65535, 1000000 }) |input| {
        try std.testing.expectEqual(input * 2 + 13, try alpha.execute(&arena, input));
    }
}

test "unified beta selects independent entry with shared leaf" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]u64{ 0, 1, 7, 42, 65535, 1000000 }) |input| {
        try std.testing.expectEqual(input * 3 + 13, try beta.execute(&arena, input));
    }
}

test "unified same-source alias preserves computation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]u64{ 0, 1, 7, 42, 65535, 1000000 }) |input| {
        try std.testing.expectEqual(input * 2 + 13, try repeat.execute(&arena, input));
    }
}

test "unified public entries compose and remain stable across interleaved calls" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]u64{ 0, 7, 1000, 7, 0 }) |input| {
        const first = try alpha.execute(&arena, input);
        const second = try beta.execute(&arena, first);
        try std.testing.expectEqual(input * 6 + 52, second);
        try std.testing.expectEqual(input * 12 + 117, try repeat.execute(&arena, second));
    }
}
