const std = @import("std");
const graph = @import("graph_fixture.zig");
const allocator = std.testing.allocator;
const source = [_]u32{ 1, 3, 0, 4, 1, 1, 8, 0, 1, 0, 2, 10, 12, 13, 1, 0 };

test "backend source accepts zero positions and absent source text" {
    try graph.check(allocator, &source, null);
    var extra = source;
    @memset(extra[9..16], 0);

    try graph.check(allocator, &extra, null);
}

test "backend source rejects overflowing line and column numbers" {
    for ([_]usize{ 9, 10 }) |index| {
        var extra = source;
        extra[index] = std.math.maxInt(u32);

        try graph.check(allocator, &extra, error.InvalidBackendProtocol);
    }
}

test "backend source accepts largest incrementable line and column" {
    var extra = source;
    extra[9] = std.math.maxInt(u32) - 1;
    extra[10] = std.math.maxInt(u32) - 1;

    try graph.check(allocator, &extra, null);
}

test "backend source rejects main position before span start" {
    var extra = source;
    extra[12] = 9;

    try graph.check(allocator, &extra, error.InvalidBackendProtocol);
}

test "backend source rejects column smaller than span prefix" {
    var extra = source;
    extra[10] = 1;

    try graph.check(allocator, &extra, error.InvalidBackendProtocol);
}

test "backend source rejects invalid path and line text indices" {
    for ([_]usize{ 8, 14 }) |index| {
        var extra = source;
        extra[index] = 100;

        try graph.check(allocator, &extra, error.InvalidBackendProtocol);
    }
}

test "backend source rejects missing reference trace storage" {
    var extra = source;
    extra[15] = 1;

    try graph.check(allocator, &extra, error.InvalidBackendProtocol);
}

test "backend trace sentinel count is not a string reference" {
    var extra = source ++ [_]u32{ 0, 0 };
    extra[15] = 1;

    for ([_]u32{ 0, 3, std.math.maxInt(u32) - 1 }) |count| {
        extra[16] = count;
        try graph.check(allocator, &extra, null);
    }

    extra[16] = std.math.maxInt(u32);
    try graph.check(allocator, &extra, error.InvalidBackendProtocol);
}

test "backend noncyclic trace accepts a distinct source record" {
    var extra = source ++ [_]u32{ 1, 18, 1, 0, 0, 0, 0, 0, 0, 0 };
    extra[15] = 1;

    try graph.check(allocator, &extra, null);
    extra[16] = 100;
    try graph.check(allocator, &extra, error.InvalidBackendProtocol);
    extra[16] = 1;
    extra[17] = 100;
    try graph.check(allocator, &extra, error.InvalidBackendProtocol);
}
