const std = @import("std");
const program = @import("program");

fn check(number: u64, maybe: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .number = number, .maybe = maybe };
    const before = input;
    const actual = try program.execute(&arena, &input);

    try std.testing.expectEqual(@as(?u64, number), actual.left);
    try std.testing.expectEqual(maybe, actual.right);
    try std.testing.expectEqualDeep(before, input);
}

test "RX diamond wraps zero and preserves null independently" {
    try check(0, null);
}

test "RX diamond wraps nonzero and preserves null independently" {
    try check(9, null);
}

test "RX diamond distinguishes present zero from null" {
    try check(0, 0);
}

test "RX diamond preserves different caller values" {
    try check(37, 19);
}

test "RX diamond preserves maximum and neighboring values" {
    try check(std.math.maxInt(u64), std.math.maxInt(u64) - 1);
}
