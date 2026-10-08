const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("integers");

pub fn call(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native).widen(in);

    _ = allocator;

    return native_result;
}

