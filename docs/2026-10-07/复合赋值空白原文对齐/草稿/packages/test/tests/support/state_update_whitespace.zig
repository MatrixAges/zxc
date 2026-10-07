const std = @import("std");

pub fn check(comptime program: type, left: u64, right: u64, shape: u64, expected: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: std.meta.Child(program.Input) = .{ .left = @bitCast(left), .right = @bitCast(right), .shape = @intCast(shape) };
    const actual = try program.execute(&arena, &input);

    try std.testing.expectEqual(left, @as(u64, @bitCast(input.left)));
    try std.testing.expectEqual(right, @as(u64, @bitCast(input.right)));
    try std.testing.expectEqual(shape, @as(u64, input.shape));

    inline for (.{ "scalar", "field", "element" }) |name| {
        try std.testing.expectEqual(expected, @as(u64, @bitCast(@field(actual.*, name))));
    }
}
