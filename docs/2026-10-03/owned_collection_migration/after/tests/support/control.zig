const std = @import("std");

pub fn check(comptime program: type, input: program.Input, expected: union(enum) { value: program.Output, failure: anyerror }) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const actual = program.execute(&arena, input);

    switch (expected) {
        .value => |value| try std.testing.expectEqualDeep(value, try actual),
        .failure => |failure| try std.testing.expectError(failure, actual),
    }
}
