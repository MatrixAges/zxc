const std = @import("std");
const program = @import("program");

fn check(choose: bool) !void {
    var left = "左侧内容".*;
    var right = "right value".*;
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    const input: std.meta.Child(program.Input) = .{ &right, choose, &left };
    const output = program.execute(&arena, &input) catch |err| {
        arena.deinit();

        return err;
    };

    arena.deinit();

    const expected: []const u8 = if (choose) &left else &right;

    try std.testing.expect(output.ptr == expected.ptr);
    try std.testing.expectEqualStrings(expected, output);
}

test "left string binding remains borrowed after arena release" {
    try check(true);
}

test "right string binding remains borrowed after arena release" {
    try check(false);
}
