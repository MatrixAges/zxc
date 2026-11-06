const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).input).root));

    const value_2: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_34: {
        const operand_32 = (((in).cursor).values).items;

        const operand_33 = block_31: {
            break :block_31 value_1;
        };

        if ((operand_33 >= (operand_32).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_34 (operand_32)[@intCast(operand_33)];
    };

    if ((!block_27: {
        const operand_25 = (((in).cursor).diagnostic).message;
        const operand_26 = @as([]const u8, "");

        break :block_27 ((std).mem).eql(u8, operand_25, operand_26);
    })) {
        return block_30: {
            const operand_28 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_29 = ((in).cursor).diagnostic;

            break :block_30 @as((zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4, (zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4{ .value = operand_28, .diagnostic = operand_29, });
        };
    }

    const value_3: bool = (((!(!(block_22: {
        break :block_22 value_2;
    } != null))) and ((block_23: {
        break :block_23 value_2;
    }.?).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) and (!(try (@import("zxc_module_9e4d6d324af814c908af5d7f74d4752965f92a61bc987b8b78e692ffacf11a42.zig")).call(allocator, (block_24: {
        break :block_24 value_2;
    }.?).floating))));

    if (block_5: {
        break :block_5 value_3;
    }) {
        return block_21: {
            const operand_6 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);

            const operand_7 = block_20: {
                const operand_8 = @as([]const u8, "unsupported");

                const operand_9 = block_13: {
                    const operand_11 = (((in).input).expressions).span_start;

                    const operand_12 = block_10: {
                        break :block_10 value_1;
                    };

                    if ((operand_12 >= (operand_11).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_13 (operand_11)[@intCast(operand_12)];
                };
                const operand_14 = block_18: {
                    const operand_16 = (((in).input).expressions).span_end;

                    const operand_17 = block_15: {
                        break :block_15 value_1;
                    };

                    if ((operand_17 >= (operand_16).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_18 (operand_16)[@intCast(operand_17)];
                };

                const operand_19 = @as([]const u8, "non-finite constant values cannot be materialized as IR literals");

                break :block_20 @as((zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808{ .code = operand_8, .start = operand_9, .end = operand_14, .message = operand_19, });
            };

            break :block_21 @as((zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4, (zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4{ .value = operand_6, .diagnostic = operand_7, });
        };
    }

    return block_4: {
        const operand_1 = block_2: {
            break :block_2 value_2;
        };

        const operand_3 = ((in).cursor).diagnostic;

        break :block_4 @as((zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4, (zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4{ .value = operand_1, .diagnostic = operand_3, });
    };
}

