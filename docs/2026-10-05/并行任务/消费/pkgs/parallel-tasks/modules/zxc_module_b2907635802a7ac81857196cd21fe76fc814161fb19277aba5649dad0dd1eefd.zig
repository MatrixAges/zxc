const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8) anyerror!u8 {
    @setRuntimeSafety(true);

    const value_1: u8 = (in).@"0";
    const value_2: u8 = (try (@import("zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368")).call(allocator, value_1));
    const value_3: u8 = (try (@import("zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368")).call(allocator, value_2));

    return value_3;
}

