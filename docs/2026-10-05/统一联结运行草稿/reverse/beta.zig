const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const Input = u64;

pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (((try (@import("zxc_module_253b38380b6ac5b8d198a06487234fa60e9d48fa7f4db1ac43881a925b2d639f")).call(allocator, in)) * @as(u64, 3)) + @as(u64, 7));
}

