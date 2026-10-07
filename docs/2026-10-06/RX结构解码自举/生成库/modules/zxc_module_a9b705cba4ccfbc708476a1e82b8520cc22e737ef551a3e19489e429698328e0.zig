const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("rx_ast");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79) error{ }![]const u8 {
    const native_result = (zx_native).nodeName(in);

    _ = allocator;

    return native_result;
}

