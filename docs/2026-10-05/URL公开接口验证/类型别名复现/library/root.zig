const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = bool;
pub const Output = bool;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: bool) anyerror!bool {
    @setRuntimeSafety(true);

    _ = arena;

    return in;
}

