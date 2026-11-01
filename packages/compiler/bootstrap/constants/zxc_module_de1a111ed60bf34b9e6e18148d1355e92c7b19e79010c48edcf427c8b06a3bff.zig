const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: f64) error{ }!f32 {
    const native_result = ((zx_native).float).narrow(in);

    _ = allocator;

    return native_result;
}

