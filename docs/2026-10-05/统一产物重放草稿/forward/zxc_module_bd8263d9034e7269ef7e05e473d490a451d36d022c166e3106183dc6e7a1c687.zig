const std = @import("std");

const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    return ((try (@import("zxc_module_253b38380b6ac5b8d198a06487234fa60e9d48fa7f4db1ac43881a925b2d639f")).call(allocator, in)) * @as(u64, 2));
}

