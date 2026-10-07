const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("zxc_standard");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856, io: (std).Io) anyerror!*const (zx_abi).zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84 {
    const native_result = (try ((zx_native).http).request(allocator, io, in));

    return native_result;
}

