const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_e52f9211d8f6044cb4f813c095aa621a601cd429170dd46684f5e602d4e0321f) anyerror!bool {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3 = (in).@"0";
    const value_2: bool = (try (@import("zxc_module_84276465a08357fbcb9164cbc2bb538acfc3c549caec7e98ac0b3dd71b5e5048")).call(allocator, (value_1).enabled));

    return value_2;
}

