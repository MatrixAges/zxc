const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("library_native_548342be9273bad8c4760e8d54cb1f8c7458a71351c177953725e1b8a55cdc8b");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_0168994f792ac8ada956b043cd140b77e82eb43d46c29c466a054b976a7159c3) error{ NativeFailure, }!bool {
    const native_result = (try (zx_native).predicate((in).@"0", (in).@"1"));

    _ = allocator;

    return native_result;
}

