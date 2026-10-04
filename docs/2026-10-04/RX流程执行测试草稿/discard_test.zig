const std = @import("std");
const program = @import("program");

test "RX discarded call executes successfully before return" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expect(try program.execute(&arena, &.{7}));
}

test "RX discarded call propagates failure before return" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, &.{}));
}
