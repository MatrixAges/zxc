const std = @import("std");
const library = @import("library");

test "republished native scopes keep independent ABI and resources" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    for ([_]i32{ -20, 0, 27, 1000 }) |input| {
        const output = try library.execute(&arena, input);

        try std.testing.expectEqual(input + 3, output.left);
        try std.testing.expectEqual(input + 22, output.right);
        try std.testing.expectEqual(output.left, output.pair.left);
        try std.testing.expectEqual(output.right, output.pair.right);
    }
}
