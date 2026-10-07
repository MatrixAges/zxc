const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_85f53cf866651ba5d4bd74ce1e90db419ddb409cf1b0c192451854c18c3534f7")).call(allocator, in, io));
}

