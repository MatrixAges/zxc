const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880b149ad851273c430c9b1d96143a0ede292aae39eca41936709e699db2dacd) anyerror!bool {
    const native_result = (try ((zx_native).url_api).canParse(allocator, in));

    return native_result;
}

