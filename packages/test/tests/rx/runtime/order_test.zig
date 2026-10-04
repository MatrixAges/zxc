const std = @import("std");
const program = @import("program");

fn check(input: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(expected, try program.execute(&arena, input));
}

test "RX executes dependent calls from zero" {
    try check(0, 11);
}

test "RX executes dependent calls from one" {
    try check(1, 22);
}

test "RX keeps adjacent bindings after discarded result" {
    try check(7, 88);
}

test "RX preserves binding values across repeated function import" {
    try check(99, 1100);
}

test "RX computes with runtime numeric input" {
    try check(100000, 1100011);
}
