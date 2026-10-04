const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u8;
pub const Output = u8;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u8) anyerror!u8 {
    @setRuntimeSafety(true);

    _ = arena;

    return in;
}

