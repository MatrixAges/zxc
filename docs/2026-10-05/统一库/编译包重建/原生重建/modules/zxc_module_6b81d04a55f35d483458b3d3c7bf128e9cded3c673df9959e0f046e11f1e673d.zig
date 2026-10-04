const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33) anyerror!(zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33 {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_85b3264a7b18e9bd91aeeee158fd4fcf6483a9058c4146f4eec12780983b57ee")).call(allocator, in));
}
