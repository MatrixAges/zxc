const std = @import("std");
const f = @import("fixture.zig");

test "owned function analysis preserves an empty function table" {
    try f.check(0, .none);
}

test "owned function analysis preserves independent scalar dependency prefixes" {
    for ([_]usize{ 1, 17, 257 }) |count| try f.check(count, .none);
}

test "owned function analysis propagates IO without inventing process capability" {
    try f.check(17, .io);
}

test "owned function analysis propagates process without inventing IO capability" {
    try f.check(17, .process);
}

test "owned summaries remain independent when another batch is released" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try f.program(arena.allocator(), 3, .io);
    const second = try f.program(arena.allocator(), 3, .process);
    var retained = try f.checks.summary.create(std.testing.allocator, second);

    defer retained.deinit();

    {
        var released = try f.checks.summary.create(std.testing.allocator, first);

        defer released.deinit();

        try f.expected(released.value, 3, .io);
        try f.expected(retained.value, 3, .process);
    }

    try f.expected(retained.value, 3, .process);
}
