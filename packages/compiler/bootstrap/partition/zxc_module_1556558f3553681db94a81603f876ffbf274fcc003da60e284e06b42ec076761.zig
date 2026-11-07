const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: u32) error{}!u64 {
    const native_result = ((zx_native).integer).widen(in);

    _ = allocator;

    return native_result;
}
