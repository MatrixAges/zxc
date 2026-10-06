const std = @import("std");
const intern = @import("生成/intern.zig");

export fn compileIntern(arena: *std.heap.ArenaAllocator, input: intern.Input) bool {
    _ = intern.execute(arena, input) catch return false;

    return true;
}
