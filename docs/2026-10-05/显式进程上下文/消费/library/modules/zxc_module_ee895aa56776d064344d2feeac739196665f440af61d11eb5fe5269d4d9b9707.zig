const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: []const u8, process: (((std).process).Init).Minimal) anyerror!?[]const u8 {
    const native_result = (try ((zx_native).process).getEnv(allocator, process, in));

    return native_result;
}

