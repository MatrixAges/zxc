const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: f32) error{ }!f64 {
    const native_result = ((zx_native).float).widen(in);

    _ = allocator;

    return native_result;
}
