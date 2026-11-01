const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, ((in).input).root));

    const value_2: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_33: {
        const operand_31 = ((in).cursor).values;

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

            break :block_29 @as((zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5, (zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5{ .value = operand_27, .diagnostic = operand_28, });
        };
    }

    if ((((block_5: {
        break :block_5 value_2;
    } != null) and ((block_6: {
        break :block_6 value_2;
    }.?).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) and (!(try (@import("zxc_module_04b4bcd17148f394659903b6d9bc5c2b08b669c291df9330727ab46600b6de87.zig")).call(allocator, (block_7: {
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

                break :block_22 @as((zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320{ .code = operand_10, .start = operand_11, .end = operand_16, .message = operand_21, });
            };

            break :block_23 @as((zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5, (zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5{ .value = operand_8, .diagnostic = operand_9, });
        };
    }

    return block_4: {
        const operand_1 = block_2: {
            break :block_2 value_2;
        };

        const operand_3 = ((in).cursor).diagnostic;

        break :block_4 @as((zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5, (zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5{ .value = operand_1, .diagnostic = operand_3, });
    };
}

