const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7970eff8567619a6c79205cd484d311286d1e449e28577c894b0b138f180bd99) error{
    IndexOutOfBounds,
}!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = (in).index;

    const value_2: i32 = block_12: {
        const operand_10 = ((in).current).ctime_high;
        const operand_11 = value_1;

        if ((operand_11 >= (operand_10).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_12 (operand_10)[@intCast(operand_11)];
    };

    const value_3: u64 = block_9: {
        const operand_7 = ((in).current).ctime_low;
        const operand_8 = value_1;

        if ((operand_8 >= (operand_7).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_9 (operand_7)[@intCast(operand_8)];
    };

    const value_4: i32 = block_6: {
        const operand_4 = ((in).previous).read_high;
        const operand_5 = value_1;

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    };

    const value_5: u64 = block_3: {
        const operand_1 = ((in).previous).read_low;
        const operand_2 = value_1;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };

    if ((value_4 > (in).now_high)) {
        return false;
    }

    if (((value_4 == (in).now_high) and (value_5 > (in).now_low))) {
        return false;
    }

    if ((value_4 < value_2)) {
        return false;
    }

    if ((value_4 == value_2)) {
        if ((value_5 <= value_3)) {
            return false;
        }

        return ((value_5 - value_3) > @as(u64, 1000000000));
    }

    if ((value_4 != (value_2 + @as(i32, 1)))) {
        return true;
    }

    if ((value_5 > @as(u64, 1000000000))) {
        return true;
    }

    const value_6: u64 = (@as(u64, 1000000000) - value_5);

    return ((@as(u64, 18446744073709551615) - value_3) >= value_6);
}
