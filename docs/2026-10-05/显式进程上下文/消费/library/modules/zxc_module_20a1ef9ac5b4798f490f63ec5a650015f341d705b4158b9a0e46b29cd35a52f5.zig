const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: void, io: (std).Io) anyerror![]const u8 {
    _ = in;

    const native_result = (try ((zx_native).process).cwd(allocator, io));

    return native_result;
}

