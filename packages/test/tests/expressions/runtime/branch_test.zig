const std = @import("std");
const program = @import("program");

fn check(divisor: u64, choose: bool, value: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ divisor, choose, value };

    try std.testing.expectEqual(expected, try program.execute(&arena, &input));
}

test "bound condition skips division by zero in unselected branch" {
    try check(0, true, 81, 81);
}

test "bound condition evaluates division branch" {
    try check(9, false, 81, 9);
}

test "division branch reads changed runtime bindings" {
    try check(4, false, 100, 25);
}
