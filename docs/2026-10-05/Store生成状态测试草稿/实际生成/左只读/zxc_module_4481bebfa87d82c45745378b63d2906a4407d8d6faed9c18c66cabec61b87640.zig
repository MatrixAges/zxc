const std = @import("std");

const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247) anyerror!*const (zx_abi).zx_type_c120fa9c961619599852a3169453e6f8a11e402bd8241bd48513689a0fe14247 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

