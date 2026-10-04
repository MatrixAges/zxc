const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try (@import("zxc_module_4f1874a8601b9d40840a577631765bf60726e6f56294d4937b70e189c85cac0d")).call(allocator, in));

    return value_1;
}
