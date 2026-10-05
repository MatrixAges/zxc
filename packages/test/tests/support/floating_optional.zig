const std = @import("std");

pub fn check(comptime program: type, input: *const struct { left: ?u64, right: ?u64 }, expected: union(enum) { value: program.Output, failure: anyerror }) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const Optional = @FieldType(@typeInfo(program.Input).pointer.child, "left");
    const Scalar = @typeInfo(Optional).optional.child;
    const Bits = @Int(.unsigned, @bitSizeOf(Scalar));

    const actual = try program.execute(&arena, &.{
        .left = if (input.left) |bits| @as(Scalar, @bitCast(@as(Bits, @intCast(bits)))) else null,
        .right = if (input.right) |bits| @as(Scalar, @bitCast(@as(Bits, @intCast(bits)))) else null,
    });

    try std.testing.expectEqualDeep(expected.value, actual);
}
