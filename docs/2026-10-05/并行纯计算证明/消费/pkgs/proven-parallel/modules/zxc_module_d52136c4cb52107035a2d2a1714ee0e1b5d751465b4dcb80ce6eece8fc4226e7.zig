const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: bool) anyerror!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    return (!in);
}

