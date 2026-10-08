const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("host");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_a17a638feca3659c82c168d52479e07d4ef7a83817db4750e5bc21bee42a6d2e) error{ NativeFailure, }!bool {
    const native_result = (try (zx_native).predicate((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

