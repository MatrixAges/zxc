const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_d460ce9a70a5e6244cb3db0b13850313c4687230311a46f4201cacbfa860e05e) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_3: {
        const operand_1 = (in).values;
        const operand_2 = (in).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}

