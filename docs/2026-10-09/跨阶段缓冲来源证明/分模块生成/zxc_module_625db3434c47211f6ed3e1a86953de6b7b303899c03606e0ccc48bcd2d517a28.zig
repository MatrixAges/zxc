const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_dba05a3363484e58dd45bd70c3f5dd4a4fabacaeb7d75145acd4f0bc860b7990) error{ OutOfMemory, }![]const bool {
    @setRuntimeSafety(true);

    return block_4: {
        const operand_1 = (in).specifiers;
        const operand_2 = (try (allocator).alloc(bool, (operand_1).len));

        for (operand_1, 0..) |_, index_3| {
            (operand_2)[index_3] = false;
        }

        break :block_4 operand_2;
    };
}

