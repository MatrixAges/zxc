const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_3: {
        const operand_1 = in;
        const operand_2 = @as(u64, 0);

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}
