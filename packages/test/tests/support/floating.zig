const std = @import("std");

pub fn check(comptime program: type, left: u64, right: u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const Scalar = @FieldType(@typeInfo(program.Input).pointer.child, "left");
    const Bits = @Int(.unsigned, @bitSizeOf(Scalar));

    const actual = try program.execute(&arena, &.{
        .left = @bitCast(@as(Bits, @intCast(left))),
        .right = @bitCast(@as(Bits, @intCast(right))),
    });

    if (expected) |bits| {
        try std.testing.expectEqual(@as(Bits, @intCast(bits)), @as(Bits, @bitCast(actual)));
    } else {
        try std.testing.expect(std.math.isNan(actual));
    }
}
