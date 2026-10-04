const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;
pub const Output = u8;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3) anyerror!u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u8 = (try (@import("zxc_module_deed53df6a771da691d79f7b80e0f625b66fa971c3525cb5c3bc90940f49965f")).call(allocator, in));
    const switch_1 = (in).enabled;

    if ((switch_1 == true)) {
        return value_1;
    } else {
        return @as(u8, 0);
    }
}
