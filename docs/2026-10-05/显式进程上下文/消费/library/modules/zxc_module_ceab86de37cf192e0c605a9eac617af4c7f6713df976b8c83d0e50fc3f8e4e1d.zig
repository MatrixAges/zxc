const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: void, process: (((std).process).Init).Minimal) anyerror![]const []const u8 {
    _ = in;

    const native_result = (try ((zx_native).process).argv(allocator, process));

    return native_result;
}

