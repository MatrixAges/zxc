const std = @import("std");

const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in + @as(u64, 2));
}

