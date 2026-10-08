const std = @import("std");
const initial = @import("initial");
const abi = @import("zxc_abi");

export fn compileInitial(arena: *std.heap.ArenaAllocator, input: *const abi.zx_type_65, output: **const abi.zx_type_58) bool {
    output.* = initial.execute(arena, input) catch return false;

    return true;
}
