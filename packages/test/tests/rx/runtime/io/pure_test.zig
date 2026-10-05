const std = @import("std");
const program = @import("program");

fn check(input: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
}

test "pure export from an IO library keeps a two argument entry for zero" {
    try check(0, 11);
}

test "pure compiled consumer from an IO library needs no implicit host" {
    try check(7, 18);
}

test "pure export from an IO library preserves maximum safe integer" {
    try check(std.math.maxInt(u64) - 11, std.math.maxInt(u64));
}
