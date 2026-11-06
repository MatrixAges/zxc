const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_c22bc6bb44c823f09c9998e1942a4719f164fbdf3623e4af03459af19b95be16) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78 = (((in).input).expressions).*;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).id));

    const value_3: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_38: {
        const operand_36 = ((&value_1)).kinds;
        const operand_37 = value_2;

        if ((operand_37 >= (operand_36).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_38 (operand_36)[@intCast(operand_37)];
    };

    const value_4: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_35: {
        const operand_33 = ((&value_1)).payloads;
        const operand_34 = value_2;

        if ((operand_34 >= (operand_33).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_35 (operand_33)[@intCast(operand_34)];
    }));

    const value_5: bool = ((value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer)) or (value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger)));

    const value_6: u64 = block_32: {
        const operand_25 = value_3;

        break :block_32 switch (operand_25) { @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer) => block_31: {
            const operand_29 = ((&value_1)).integers;
            const operand_30 = value_4;

            if ((operand_30 >= (operand_29).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_31 (operand_29)[@intCast(operand_30)];
        }, else => (if ((operand_25 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger))) block_28: {
            const operand_26 = ((&value_1)).negative_integers;
            const operand_27 = value_4;

            if ((operand_27 >= (operand_26).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_28 (operand_26)[@intCast(operand_27)];
        } else @as(u64, 0)), };
    };

    return block_24: {
        const operand_1 = block_4: {
            const operand_2 = ((&value_1)).types;
            const operand_3 = value_2;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        };

        const operand_5 = (if (value_5) @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer) else value_3);
        const operand_6 = value_6;
        const operand_7 = ((value_6 != @as(u64, 0)) and (value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger)));

        const operand_8 = (if ((value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) block_11: {
            const operand_9 = ((&value_1)).floats;
            const operand_10 = value_4;

            if ((operand_10 >= (operand_9).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_11 (operand_9)[@intCast(operand_10)];
        } else @as(f64, @as(f64, @bitCast(@as(u64, 0)))));

        const operand_12 = (if ((value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String))) block_15: {
            const operand_13 = ((&value_1)).strings;
            const operand_14 = value_4;

            if ((operand_14 >= (operand_13).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_15 (operand_13)[@intCast(operand_14)];
        } else @as([]const u8, ""));

        const operand_16 = ((value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean)) and block_19: {
            const operand_17 = ((&value_1)).booleans;
            const operand_18 = value_4;

            if ((operand_18 >= (operand_17).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_19 (operand_17)[@intCast(operand_18)];
        });

        const operand_20 = (if ((value_3 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue))) block_23: {
            const operand_21 = ((&value_1)).enumerations;
            const operand_22 = value_4;

            if ((operand_22 >= (operand_21).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_23 (operand_21)[@intCast(operand_22)];
        } else @as(u32, 0));

        break :block_24 (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .type_id = operand_1, .kind = operand_5, .integer = operand_6, .negative = operand_7, .floating = operand_8, .text = operand_12, .boolean = operand_16, .enumeration = operand_20, };
    };
}

