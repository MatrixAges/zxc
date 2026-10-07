const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_58eb6b9cdffa2d7d9498d71bdfe963fe0c62ded514e8d0c644681f82dda9ea75")).call(allocator, in, io));
}

