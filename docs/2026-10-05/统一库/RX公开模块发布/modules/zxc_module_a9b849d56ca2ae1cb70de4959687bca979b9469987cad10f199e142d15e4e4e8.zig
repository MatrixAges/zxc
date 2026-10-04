const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_bee0e90ef23d5e3b904327450edca4de92b8031db78ea90540ac9143061c928c")).call(allocator, in));
}
