const std = @import("std");
const program = @import("program");

test "upstream singleton string is returned when reduce omits its initial" {
    const value = "initialValue is not present";
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const actual = try program.execute(&arena, &.{value});

    try std.testing.expectEqualStrings(value, actual);
}
