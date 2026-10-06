const std = @import("std");
const nominal = @import("生成/nominal.zig");

export fn compileNominal(arena: *std.heap.ArenaAllocator, input: nominal.Input) bool {
    _ = nominal.execute(arena, input) catch return false;

    return true;
}
