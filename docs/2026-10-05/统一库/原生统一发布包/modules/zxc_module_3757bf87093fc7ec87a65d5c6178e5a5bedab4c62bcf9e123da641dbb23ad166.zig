const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("library_native_0cd6f1314c2010436047124e0e37cbfae481405200b5bc72cecbfa5f29d6612b");

pub fn call(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1) anyerror!(zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1 {
    const native_result = (try (zx_native).flip(in));

    _ = allocator;

    return native_result;
}
