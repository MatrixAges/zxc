const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).input).root));

    const value_2: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_33: {
        const operand_31 = (((in).cursor).values).items;

        const operand_32 = block_30: {
            break :block_30 value_1;
        };

        if ((operand_32 >= (operand_31).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_33 (operand_31)[@intCast(operand_32)];
    };

    if ((!block_26: {
        const operand_24 = (((in).cursor).diagnostic).message;
        const operand_25 = @as([]const u8, "");

        break :block_26 ((std).mem).eql(u8, operand_24, operand_25);
    })) {
        return block_29: {
            const operand_27 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_28 = ((in).cursor).diagnostic;

            break :block_29 @as((zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191, (zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191{ .value = operand_27, .diagnostic = operand_28, });
        };
    }

    if ((((block_5: {
        break :block_5 value_2;
    } != null) and ((block_6: {
        break :block_6 value_2;
    }.?).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) and (!(try (@import("zxc_module_9e4d6d324af814c908af5d7f74d4752965f92a61bc987b8b78e692ffacf11a42.zig")).call(allocator, (block_7: {
        break :block_7 value_2;
    }.?).floating))))) {
        return block_23: {
            const operand_8 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);

            const operand_9 = block_22: {
                const operand_10 = @as([]const u8, "unsupported");

                const operand_11 = block_15: {
                    const operand_13 = (((in).input).expressions).span_start;

                    const operand_14 = block_12: {
                        break :block_12 value_1;
                    };

                    if ((operand_14 >= (operand_13).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_15 (operand_13)[@intCast(operand_14)];
                };
                const operand_16 = block_20: {
                    const operand_18 = (((in).input).expressions).span_end;

                    const operand_19 = block_17: {
                        break :block_17 value_1;
                    };

                    if ((operand_19 >= (operand_18).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_20 (operand_18)[@intCast(operand_19)];
                };

                const operand_21 = @as([]const u8, "non-finite constant values cannot be materialized as IR literals");

                break :block_22 @as((zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de{ .code = operand_10, .start = operand_11, .end = operand_16, .message = operand_21, });
            };

            break :block_23 @as((zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191, (zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191{ .value = operand_8, .diagnostic = operand_9, });
        };
    }

    return block_4: {
        const operand_1 = block_2: {
            break :block_2 value_2;
        };

        const operand_3 = ((in).cursor).diagnostic;

        break :block_4 @as((zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191, (zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191{ .value = operand_1, .diagnostic = operand_3, });
    };
}

