const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;
        var value_1: u64 = @as(u64, 0);

        for (operand_1) |value_2| {
            value_1 = (value_1 + value_2);
        }

        break :block_2 value_1;
    };
}
