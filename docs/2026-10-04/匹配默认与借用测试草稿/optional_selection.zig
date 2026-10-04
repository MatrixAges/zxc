const std = @import("std");

pub fn check(comptime program: type, input: program.Input, expected: union(enum) { value: program.Output, failure: anyerror }) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var left = (input.left orelse input.fallback).*;
    var right = (input.right orelse input.fallback).*;
    var fallback = input.fallback.*;
    const actual_input: program.Input = &.{
        .left = if (input.left != null) &left else null,
        .right = if (input.right != null) &right else null,
        .fallback = &fallback,
    };

    try std.testing.expect(&left != &right);
    try std.testing.expect(&left != &fallback);
    try std.testing.expect(&right != &fallback);

    const actual = try program.execute(&arena, actual_input);
    const selected = if (actual_input.left) |value| value else if (actual_input.right) |value| value else actual_input.fallback;

    try std.testing.expect(actual == selected);
    try std.testing.expectEqualDeep(expected.value, actual);
    try std.testing.expectEqualDeep((input.left orelse input.fallback).*, left);
    try std.testing.expectEqualDeep((input.right orelse input.fallback).*, right);
    try std.testing.expectEqualDeep(input.fallback.*, fallback);
}
