const std = @import("std");
const library = @import("library");

test "single ZX entry preserves identity through published public module" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    for ([_]u8{ 0, 1, 127, 255 }) |value| {
        try std.testing.expectEqual(value, try library.execute(&arena, value));
    }
}
