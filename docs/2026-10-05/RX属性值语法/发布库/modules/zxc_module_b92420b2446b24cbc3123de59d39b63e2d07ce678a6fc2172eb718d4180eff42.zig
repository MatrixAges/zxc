const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u8) anyerror![]const u8 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

