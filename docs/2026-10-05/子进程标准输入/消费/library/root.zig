const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c;
pub const Output = *const (zx_abi).zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507;
pub const consumes_input = false;
pub const requires_io = true;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_09cb3e3e24d7f297084480de58372532797d99d0aa447caad8ad7df1234ce51c, io: (std).Io) anyerror!*const (zx_abi).zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_2ec2758f1cd9616b0c1502445516f14f3ef30215e0bf6892fd535aea5043c507 = (try (@import("zxc_module_132fc04c1d7c8500f7e61b5e9ef35780a0f52c32009489d3a9018cca368885c0")).call(allocator, in, io));

    return value_1;
}

