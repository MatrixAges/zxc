const std = @import("std");
const zx_abi = @import("zxc_abi");
const zx_native = @import("library_native_6c9c0b66a907af74268a736d2868e8d92ff63965567327ece1d8f5b06c47aed2");

pub fn call(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33) anyerror!(zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33 {
    const native_result = (try (zx_native).flip(in));

    _ = allocator;

    return native_result;
}
