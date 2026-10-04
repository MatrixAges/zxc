const std = @import("std");
const program = @import("program");

fn check(input: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
}

test "RX shared dependency functions from zero" {
    try check(0, 1010101);
}

test "RX shared dependency functions from one" {
    try check(1, 1020102);
}

test "RX multilevel function imports preserve runtime argument" {
    try check(7, 1080108);
}
