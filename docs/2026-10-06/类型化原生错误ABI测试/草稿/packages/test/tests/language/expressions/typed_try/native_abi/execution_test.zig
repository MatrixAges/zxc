const std = @import("std");
const program = @import("program");
const host = @import("host");

test "finite native ABI executes success and declared failure paths" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(@as(u64, 7), try program.execute(&arena, 7));
    try std.testing.expectEqual(@as(u64, 0), try program.execute(&arena, 0));
    try std.testing.expectEqual(@as(u64, if (host.fallible) 0 else 1), try program.execute(&arena, 1));
}
