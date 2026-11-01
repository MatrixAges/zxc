const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3) error{ }!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = (in).id;

        break :block_2 (if ((operand_1 == @as(u32, 2))) @as(u64, 255) else (if ((operand_1 == @as(u32, 3))) @as(u64, 65535) else (if ((operand_1 == @as(u32, 4))) @as(u64, 4294967295) else (if ((operand_1 == @as(u32, 6))) (if ((in).negative) @as(u64, 2147483648) else @as(u64, 2147483647)) else (if ((operand_1 == @as(u32, 7))) (if ((in).negative) @as(u64, 9223372036854775808) else @as(u64, 9223372036854775807)) else @as(u64, 18446744073709551615))))));
    };
}

