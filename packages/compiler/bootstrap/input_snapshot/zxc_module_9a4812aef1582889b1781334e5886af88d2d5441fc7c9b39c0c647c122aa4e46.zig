const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048) error{
    IndexOutOfBounds,
    OutOfMemory,
}!bool {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_5a31193b5920d201b6075944d49198068f2dad47ac083906cac5ca1086afb53a.zig")).call(allocator, in));
    const switch_2 = (!value_1);

    if ((switch_2 == true)) {
        return false;
    }

    const value_2: bool = (try (@import("zxc_module_c92f71f4357d7c1c1bc6cd3099f6d76f809e35287d4fa27ab3d2d1ab2e1bbbe8.zig")).call(allocator, in));
    const switch_1 = (!value_2);

    if ((switch_1 == true)) {
        return false;
    }

    const value_3: bool = (try (@import("zxc_module_80256bc0173b1a75690b26ca087c7763ebadea2bf3dd9bb34cde436c5f4430a1.zig")).call(allocator, in));

    return value_3;
}
