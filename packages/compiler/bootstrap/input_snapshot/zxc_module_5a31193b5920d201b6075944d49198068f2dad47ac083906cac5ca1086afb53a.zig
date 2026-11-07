const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_e2d7d96b804892d7fad8d1e3c183a0f9619c1e3575fb06c877c77d7f92653048) error{}!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: bool = block_6: {
        const operand_4 = (in).context;
        const operand_5 = ((in).previous).context;

        break :block_6 ((std).mem).eql(u8, operand_4, operand_5);
    };

    const value_2: u64 = @as(u64, (((in).previous).fingerprint).len);

    const value_3: bool = block_3: {
        const operand_1 = (in).stored_checksum;
        const operand_2 = (in).actual_checksum;

        break :block_3 ((std).mem).eql(u8, operand_1, operand_2);
    };

    return (((!(!value_1)) and value_3) and (value_2 == @as(u64, 64)));
}
