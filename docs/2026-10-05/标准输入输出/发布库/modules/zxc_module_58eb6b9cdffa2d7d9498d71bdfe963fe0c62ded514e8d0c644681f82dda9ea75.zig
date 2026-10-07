const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native).process).writeStdoutText(io, in));

    _ = allocator;

    return native_result;
}

