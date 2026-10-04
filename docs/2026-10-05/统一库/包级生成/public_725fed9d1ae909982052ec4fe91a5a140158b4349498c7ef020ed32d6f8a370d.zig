const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;
pub const Output = u8;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3) anyerror!u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u8 = (try (@import("zxc_module_82c4500d58b8f61da8ac20d05834dc6b593ef7ef4772463eb5a9e97c3e9b24ec")).call(allocator, in));
    const switch_1 = (in).enabled;

    if ((switch_1 == true)) {
        return value_1;
    } else {
        return @as(u8, 0);
    }
}
