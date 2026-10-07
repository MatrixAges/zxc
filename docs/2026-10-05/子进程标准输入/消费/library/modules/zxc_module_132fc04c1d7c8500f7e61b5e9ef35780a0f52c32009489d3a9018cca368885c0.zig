const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c, io: (std).Io) anyerror!*const (zx_abi).zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507 {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_23778bc491749546b44be55fa238c68ea1cc9c7cac043fb52e7024baac3ecd96")).call(allocator, in, io));
}

