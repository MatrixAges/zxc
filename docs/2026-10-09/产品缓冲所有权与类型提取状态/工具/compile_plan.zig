const std = @import("std");
const plan = @import("plan");
const abi = @import("zxc_abi");

export fn compilePlan(arena: *std.heap.ArenaAllocator, input: *const abi.zx_type_30, output: *?*const abi.zx_type_29) bool {
    output.* = plan.execute(arena, input) catch return false;

    return true;
}
