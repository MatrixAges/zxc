const std = @import("std");

const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_bcc2278c84fb72dec155bb98112a73003c148de208e4ff877b335efc051a603f) anyerror!u64 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try (@import("zxc_module_eaaaceb1235237945bc01b2c631d242fc2c35b0b30d0ec61cf93be28d59e6273")).call(allocator, (if ((in).choose) block_3: {
        const operand_1 = (in).left;
        const operand_2 = @as(u64, 0);

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    } else block_6: {
        const operand_4 = (in).right;
        const operand_5 = @as(u64, 0);

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    })));

    return value_1;
}

