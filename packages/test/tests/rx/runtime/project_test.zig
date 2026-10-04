const std = @import("std");
const program = @import("program");

fn check(input: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
}

test "RX project executes every layer from zero" {
    try check(0, 90);
}

test "RX project executes every layer from seven" {
    try check(7, 300);
}

test "RX project executes every layer from thirty one" {
    try check(31, 1020);
}

test "RX project preserves maximum safe multiplication input" {
    const quotient = std.math.maxInt(u64) / 30;

    try check(quotient - 3, quotient * 30);
}
