const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_2fd79eb8a0fde8d5eb829cb4ca7a3446c49b0f0a939220aa310c15ac35582078) anyerror![]const u8 {
    const native_result = (try ((zx_native).url_api).pathToFileURL(allocator, in));

    return native_result;
}

