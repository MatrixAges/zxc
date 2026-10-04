const std = @import("std");
const program = @import("program");

fn check(input: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
}

test "RX Switch integer first label" {
    try check(0, 10);
}

test "RX Switch integer second label" {
    try check(7, 70);
}

test "RX Switch integer unmatched zero neighbor" {
    try check(1, 2);
}

test "RX Switch integer unmatched interior" {
    try check(8, 9);
}

test "RX Switch integer maximum subject" {
    try check(std.math.maxInt(u64) - 1, std.math.maxInt(u64));
}
