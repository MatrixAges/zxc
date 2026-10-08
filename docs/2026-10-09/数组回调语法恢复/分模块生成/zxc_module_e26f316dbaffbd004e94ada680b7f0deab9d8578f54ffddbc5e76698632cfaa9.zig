const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("integers");

pub fn call(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native).narrow(in));

    _ = allocator;

    return native_result;
}

