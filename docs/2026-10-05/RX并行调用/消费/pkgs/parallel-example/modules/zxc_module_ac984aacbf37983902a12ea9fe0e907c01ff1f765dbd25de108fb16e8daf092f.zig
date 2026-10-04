const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: u64) anyerror!void {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = in;
}
