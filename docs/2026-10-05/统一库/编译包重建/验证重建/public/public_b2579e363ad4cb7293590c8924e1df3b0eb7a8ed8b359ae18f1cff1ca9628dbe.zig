const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = bool;
pub const Output = bool;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: bool) anyerror!bool {
    @setRuntimeSafety(true);

    _ = arena;

    return (!in);
}
