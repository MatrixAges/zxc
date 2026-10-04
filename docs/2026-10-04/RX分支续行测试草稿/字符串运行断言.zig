const std = @import("std");
const program = @import("program");

fn check(input: []const u8, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
}

test "RX Switch string exact label" {
    try check("ready", 10);
}

test "RX Switch string empty label" {
    try check("", 20);
}

test "RX Switch string UTF8 label" {
    try check("中文", 30);
}

test "RX Switch string XML decoded label" {
    try check("a&b", 40);
}

test "RX Switch string case sensitive mismatch" {
    try check("Ready", 99);
}

test "RX Switch string longer value mismatch" {
    try check("ready!", 99);
}

test "RX Switch string shorter value mismatch" {
    try check("read", 99);
}

test "RX Switch string embedded NUL mismatch" {
    try check("ready\x00", 99);
}
