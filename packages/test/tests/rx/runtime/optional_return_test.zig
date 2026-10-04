const std = @import("std");
const program = @import("program");

fn check(value: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(value, try program.execute(&arena, value));
}

test "RX optional result preserves null" {
    try check(null);
}

test "RX optional result preserves zero" {
    try check(0);
}

test "RX optional result preserves maximum" {
    try check(std.math.maxInt(u64));
}
