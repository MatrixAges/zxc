const std = @import("std");

pub fn check(comptime program: type, left: u64, right: u64, expected: program.Output) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const Scalar = @FieldType(program.Input, "left");
    const Bits = std.meta.Int(.unsigned, @bitSizeOf(Scalar));

    const actual = try program.execute(&arena, .{
        .left = @bitCast(@as(Bits, @intCast(left))),
        .right = @bitCast(@as(Bits, @intCast(right))),
    });

    try std.testing.expectEqualDeep(expected, actual);
}
