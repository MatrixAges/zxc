const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_29371eced86d96eea39cc7796fba3944a4b895260e58e18a351d891e0e1ebe54) anyerror![]const u8 {
    const native_result = (try ((zx_native).url_api).fileURLToBytes(allocator, in));

    return native_result;
}

