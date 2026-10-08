const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_36824d222156888ad075a6df3ce7e38bd1275901a7a57e773c1cabaedddf3f8c) error{ IndexOutOfBounds, }![]const u8 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (block_3: {
        const operand_1 = ((in).modules).identities;
        const operand_2 = (in).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    } orelse block_6: {
        const operand_4 = ((in).modules).specifiers;
        const operand_5 = (in).index;

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    });
}

