const std = @import("std");
const original = @import("original");
const linked = @import("linked");

test "original and relinked module execute helper addition" {
    inline for (.{ original, linked }) |program| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        for ([_]u64{ 0, 7, 65535, std.math.maxInt(u64) - 1 }) |value| {
            try std.testing.expectEqual(value + 1, try program.execute(&arena, value));
        }
    }
}
