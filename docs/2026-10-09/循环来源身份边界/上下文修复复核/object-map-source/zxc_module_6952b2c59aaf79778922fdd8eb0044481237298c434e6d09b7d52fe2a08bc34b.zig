const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("host");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5) error{ NativeFailure, }!*const (zx_abi).zx_type_fec2916bbc8912b33dcbfc5ce5faec8d33bdfd65e5cfbe7eecd2565e09c522f5 {
    const native_result = (try (zx_native).echo(in));

    _ = allocator;

    return native_result;
}

