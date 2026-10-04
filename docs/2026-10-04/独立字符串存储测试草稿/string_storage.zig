const std = @import("std");

pub fn check(comptime program: type, input: program.Input, expected: union(enum) { value: program.Output, failure: anyerror }) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const left = input.left orelse "";
    const right = input.right orelse "";
    const left_storage = try std.testing.allocator.alloc(u8, left.len + 1);

    defer std.testing.allocator.free(left_storage);

    const right_storage = try std.testing.allocator.alloc(u8, right.len + 1);

    defer std.testing.allocator.free(right_storage);

    @memcpy(left_storage[0..left.len], left);
    @memcpy(right_storage[0..right.len], right);

    try std.testing.expect(left_storage.ptr != right_storage.ptr);

    const actual_input: program.Input = &.{
        .left = if (input.left != null) left_storage[0..left.len] else null,
        .right = if (input.right != null) right_storage[0..right.len] else null,
    };
    const actual = try program.execute(&arena, actual_input);

    try std.testing.expectEqualDeep(expected.value, actual);
    try std.testing.expectEqualStrings(left, left_storage[0..left.len]);
    try std.testing.expectEqualStrings(right, right_storage[0..right.len]);
}
