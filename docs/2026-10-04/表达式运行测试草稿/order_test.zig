const std = @import("std");
const program = @import("program");

fn check(right: u64, left: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ right, left };

    try std.testing.expectEqual(expected, try program.execute(&arena, &input));
}

test "binding declaration order differs from expression occurrence order" {
    try check(3, 7, 73);
}

test "adjacent path prefixes remain independent when values reverse" {
    try check(7, 3, 37);
}

test "zero left binding preserves right binding" {
    try check(9, 0, 9);
}

test "zero right binding preserves weighted left binding" {
    try check(0, 9, 90);
}
