const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_19ebf3d3daa1235aa9ca0e94693f070406096da386675c891f585ac3f6cab6cf) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb = ((in).input).expressions;

    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_43: {
        const operand_41 = (block_40: {
            break :block_40 value_1;
        }).payloads;

        const operand_42 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

        if ((operand_42 >= (operand_41).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_43 (operand_41)[@intCast(operand_42)];
    }));

    const value_3: u32 = block_39: {
        const operand_37 = (block_35: {
            break :block_35 value_1;
        }).conditional_conditions;

        const operand_38 = block_36: {
            break :block_36 value_2;
        };

        if ((operand_38 >= (operand_37).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_39 (operand_37)[@intCast(operand_38)];
    };

    const value_4: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_34: {
        const operand_32 = (((in).cursor).values).items;

        const operand_33 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_31: {
            break :block_31 value_3;
        }));

        if ((operand_33 >= (operand_32).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_34 (operand_32)[@intCast(operand_33)];
    };

    if ((block_24: {
        break :block_24 value_4;
    } == null)) {
        return block_30: {
            const operand_25 = (in).frame;

            const operand_26 = @as(?u32, block_27: {
                break :block_27 value_3;
            });

            const operand_28 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_29 = @as([]const u8, "");

            break :block_30 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_25, .child = operand_26, .value = operand_28, .message = operand_29, });
        };
    }

    const value_5: u32 = (if ((block_13: {
        break :block_13 value_4;
    }.?).boolean) block_18: {
        const operand_16 = (block_14: {
            break :block_14 value_1;
        }).conditional_yes;

        const operand_17 = block_15: {
            break :block_15 value_2;
        };

        if ((operand_17 >= (operand_16).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_18 (operand_16)[@intCast(operand_17)];
    } else block_23: {
        const operand_21 = (block_19: {
            break :block_19 value_1;
        }).conditional_no;

        const operand_22 = block_20: {
            break :block_20 value_2;
        };

        if ((operand_22 >= (operand_21).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_23 (operand_21)[@intCast(operand_22)];
    });

    const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = block_12: {
        const operand_10 = (((in).cursor).values).items;

        const operand_11 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_9: {
            break :block_9 value_5;
        }));

        if ((operand_11 >= (operand_10).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_12 (operand_10)[@intCast(operand_11)];
    };

    return block_8: {
        const operand_1 = (in).frame;

        const operand_2 = (if ((block_3: {
            break :block_3 value_6;
        } == null)) @as(?u32, block_4: {
            break :block_4 value_5;
        }) else @as(?u32, null));

        const operand_5 = block_6: {
            break :block_6 value_6;
        };

        const operand_7 = @as([]const u8, "");

        break :block_8 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_1, .child = operand_2, .value = operand_5, .message = operand_7, });
    };
}

