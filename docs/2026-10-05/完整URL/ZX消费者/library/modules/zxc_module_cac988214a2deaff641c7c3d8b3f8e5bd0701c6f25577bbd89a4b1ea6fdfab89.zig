const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd) anyerror!?*const (zx_abi).zx_type_b4999487d02b5701fd7adc11bfa4d60807105392f3bff0d8022039a510acafe5 {
    const native_result = (try ((zx_native).url_api).tryParse(allocator, in));

    return native_result;
}

