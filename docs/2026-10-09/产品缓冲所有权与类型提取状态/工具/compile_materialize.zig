const std = @import("std");
const materialize = @import("materialize");
const abi = @import("zxc_abi");

export fn compileMaterialize(arena: *std.heap.ArenaAllocator, input: *const abi.zx_type_39, output: **const abi.zx_type_38) bool {
    output.* = materialize.execute(arena, input) catch return false;

    return true;
}
