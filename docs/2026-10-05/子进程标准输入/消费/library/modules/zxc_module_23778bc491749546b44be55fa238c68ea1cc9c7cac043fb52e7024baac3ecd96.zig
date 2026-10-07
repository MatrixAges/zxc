const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c, io: (std).Io) anyerror!*const (zx_abi).zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507 {
    const native_result = (try ((zx_native).child_process).spawnSyncWithInput(allocator, io, in));

    return native_result;
}

