const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048) error{}!bool {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d = ((in).previous).files;
    const value_2: u64 = @as(u64, (((in).current).paths).len);
    const value_3: u64 = @as(u64, ((value_1).paths).len);
    const value_4: u64 = @as(u64, ((value_1).read_high).len);
    const value_5: u64 = @as(u64, ((value_1).read_low).len);
    const value_6: bool = (try (@import("zxc_module_9ae3a4ae48a29cccb106a8a2a01735f3d47d86551ddec5efb24cbd0c75ac56d0.zig")).call(allocator, (in).current));
    const value_7: bool = (try (@import("zxc_module_9ae3a4ae48a29cccb106a8a2a01735f3d47d86551ddec5efb24cbd0c75ac56d0.zig")).call(allocator, value_1));

    return (((((!(!value_6)) and value_7) and (value_2 == value_3)) and (value_4 == value_2)) and (value_5 == value_2));
}
