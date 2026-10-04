const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const Input = u64;

pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return ((try (@import("zxc_module_bd8263d9034e7269ef7e05e473d490a451d36d022c166e3106183dc6e7a1c687")).call(allocator, (try (@import("zxc_module_253b38380b6ac5b8d198a06487234fa60e9d48fa7f4db1ac43881a925b2d639f")).call(allocator, in)))) + @as(u64, 5));
}

