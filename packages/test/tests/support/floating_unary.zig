const std = @import("std");

pub fn check(comptime program: type, input: u64, expected: ?u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const Bits = std.meta.Int(.unsigned, @bitSizeOf(program.Input));
    const actual = try program.execute(&arena, @bitCast(@as(Bits, @intCast(input))));

    if (expected) |bits| {
        try std.testing.expectEqual(@as(Bits, @intCast(bits)), @as(Bits, @bitCast(actual)));
    } else {
        try std.testing.expect(std.math.isNan(actual));
    }
}
