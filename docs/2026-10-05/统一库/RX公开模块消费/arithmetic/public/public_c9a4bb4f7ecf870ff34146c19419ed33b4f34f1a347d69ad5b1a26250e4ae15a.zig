const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = arena;

    return (in + @as(u64, 1));
}
