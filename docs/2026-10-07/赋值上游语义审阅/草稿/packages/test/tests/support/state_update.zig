const std = @import("std");

pub fn check(comptime program: type, left: u64, right: u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const Scalar = @FieldType(@typeInfo(program.Input).pointer.child, "left");
    const Bits = @Int(.unsigned, @bitSizeOf(Scalar));

    const input: @typeInfo(program.Input).pointer.child = .{
        .left = @bitCast(@as(Bits, @intCast(left))),
        .right = @bitCast(@as(Bits, @intCast(right))),
    };

    const actual = try program.execute(&arena, &input);

    try std.testing.expectEqual(@as(Bits, @intCast(left)), @as(Bits, @bitCast(input.left)));
    try std.testing.expectEqual(@as(Bits, @intCast(right)), @as(Bits, @bitCast(input.right)));

    inline for (.{ "scalar", "field", "element" }) |name| {
        const value = @field(actual.*, name);

        if (expected) |bits| {
            try std.testing.expectEqual(@as(Bits, @intCast(bits)), @as(Bits, @bitCast(value)));
        } else {
            try std.testing.expect(std.math.isNan(value));
        }
    }
}
