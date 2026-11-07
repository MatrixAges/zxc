const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_7970eff8567619a6c79205cd484d311286d1e449e28577c894b0b138f180bd99) error{
    IndexOutOfBounds,
}!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: *const (zx_abi).zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d = (in).previous;
    const value_2: *const (zx_abi).zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d = (in).current;
    const value_3: u64 = (in).index;

    const value_4: []const u8 = block_45: {
        const operand_43 = (value_1).paths;
        const operand_44 = value_3;

        if ((operand_44 >= (operand_43).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_45 (operand_43)[@intCast(operand_44)];
    };

    const value_5: []const u8 = block_42: {
        const operand_40 = (value_2).paths;
        const operand_41 = value_3;

        if ((operand_41 >= (operand_40).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_42 (operand_40)[@intCast(operand_41)];
    };

    const value_6: u64 = block_39: {
        const operand_37 = (value_1).inodes;
        const operand_38 = value_3;

        if ((operand_38 >= (operand_37).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_39 (operand_37)[@intCast(operand_38)];
    };

    const value_7: u64 = block_36: {
        const operand_34 = (value_2).inodes;
        const operand_35 = value_3;

        if ((operand_35 >= (operand_34).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_36 (operand_34)[@intCast(operand_35)];
    };

    const value_8: u64 = block_33: {
        const operand_31 = (value_1).sizes;
        const operand_32 = value_3;

        if ((operand_32 >= (operand_31).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_33 (operand_31)[@intCast(operand_32)];
    };

    const value_9: u64 = block_30: {
        const operand_28 = (value_2).sizes;
        const operand_29 = value_3;

        if ((operand_29 >= (operand_28).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_30 (operand_28)[@intCast(operand_29)];
    };

    const value_10: i32 = block_27: {
        const operand_25 = (value_1).mtime_high;
        const operand_26 = value_3;

        if ((operand_26 >= (operand_25).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_27 (operand_25)[@intCast(operand_26)];
    };

    const value_11: i32 = block_24: {
        const operand_22 = (value_2).mtime_high;
        const operand_23 = value_3;

        if ((operand_23 >= (operand_22).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_24 (operand_22)[@intCast(operand_23)];
    };

    const value_12: u64 = block_21: {
        const operand_19 = (value_1).mtime_low;
        const operand_20 = value_3;

        if ((operand_20 >= (operand_19).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_21 (operand_19)[@intCast(operand_20)];
    };

    const value_13: u64 = block_18: {
        const operand_16 = (value_2).mtime_low;
        const operand_17 = value_3;

        if ((operand_17 >= (operand_16).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_18 (operand_16)[@intCast(operand_17)];
    };

    const value_14: i32 = block_15: {
        const operand_13 = (value_1).ctime_high;
        const operand_14 = value_3;

        if ((operand_14 >= (operand_13).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_15 (operand_13)[@intCast(operand_14)];
    };

    const value_15: i32 = block_12: {
        const operand_10 = (value_2).ctime_high;
        const operand_11 = value_3;

        if ((operand_11 >= (operand_10).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_12 (operand_10)[@intCast(operand_11)];
    };

    const value_16: u64 = block_9: {
        const operand_7 = (value_1).ctime_low;
        const operand_8 = value_3;

        if ((operand_8 >= (operand_7).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_9 (operand_7)[@intCast(operand_8)];
    };

    const value_17: u64 = block_6: {
        const operand_4 = (value_2).ctime_low;
        const operand_5 = value_3;

        if ((operand_5 >= (operand_4).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_6 (operand_4)[@intCast(operand_5)];
    };

    return (((((((!(!block_3: {
        const operand_1 = value_4;
        const operand_2 = value_5;

        break :block_3 ((std).mem).eql(u8, operand_1, operand_2);
    })) and (value_6 == value_7)) and (value_8 == value_9)) and (value_10 == value_11)) and (value_12 == value_13)) and (value_14 == value_15)) and (value_16 == value_17));
}
