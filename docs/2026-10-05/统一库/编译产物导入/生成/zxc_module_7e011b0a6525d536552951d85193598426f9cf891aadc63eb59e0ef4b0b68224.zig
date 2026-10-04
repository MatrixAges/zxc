const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3) anyerror!u8 {
    @setRuntimeSafety(true);

    const value_1: u8 = (try (@import("zxc_module_85d43cc1a2631b01c906fc1f34d643d7d592b7429f984c368ec43b1efd6fb967")).call(allocator, in));
    const switch_1 = (in).enabled;

    if ((switch_1 == true)) {
        return value_1;
    } else {
        return @as(u8, 0);
    }
}
