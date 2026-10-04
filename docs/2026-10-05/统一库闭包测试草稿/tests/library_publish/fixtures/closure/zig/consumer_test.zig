const std = @import("std");
const main = @import("main");
const echo = @import("echo");
const workflow = @import("workflow");
const Mode = @import("types").PublishedMode;

test "published diamond dependencies share nominal enum identity and preserve calls" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const modes = [_]Mode{ .First, .Second, .Third };

    for (modes, 0..) |mode, index| {
        try std.testing.expectEqual(modes[(index + 2) % modes.len], try main.execute(&arena, mode));
        try std.testing.expectEqual(modes[(index + 1) % modes.len], try echo.execute(&arena, mode));
        try std.testing.expectEqual(modes[(index + 2) % modes.len], try workflow.execute(&arena, mode));
    }
}
