const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_78cd03b75045dcc072d2f483f11143a15babbc0e95d6ecd35d8fba36343a8ab2")).call(allocator, in));
}
