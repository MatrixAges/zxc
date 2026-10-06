const std = @import("std");

pub fn execute(comptime Rule: type, input: Rule.Input) Rule.Output {
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    return Rule.execute(&arena, input) catch unreachable;
}
