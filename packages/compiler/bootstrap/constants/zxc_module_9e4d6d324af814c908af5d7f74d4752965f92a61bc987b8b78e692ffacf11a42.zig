const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: f64) error{ }!bool {
    const native_result = ((zx_native).float).isFinite(in);

    _ = allocator;

    return native_result;
}
