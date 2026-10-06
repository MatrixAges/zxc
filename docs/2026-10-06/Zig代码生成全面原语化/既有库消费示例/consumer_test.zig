const std = @import("std");
const library = @import("library");

test "single RX entry preserves boolean behavior through published public module" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(true, try library.execute(&arena, false));
    try std.testing.expectEqual(false, try library.execute(&arena, true));
}
