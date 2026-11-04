const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_19ebf3d3daa1235aa9ca0e94693f070406096da386675c891f585ac3f6cab6cf) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_25: {
        const operand_23 = (((in).input).expressions).kinds;
        const operand_24 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, ((in).frame).id));

        if ((operand_24 >= (operand_23).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_25 (operand_23)[@intCast(operand_24)];
    };

    if (((block_20: {
        break :block_20 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_21: {
        break :block_21 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)))) {
        return block_22: {
            break :block_22 (try (@import("zxc_module_d091a2c13fd58458ee549ed30219dfc43970426e2baf9c4e964bf91640c2d20b.zig")).callValue(allocator, in));
        };
    }

    if ((block_18: {
        break :block_18 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) {
        return block_19: {
            break :block_19 (try (@import("zxc_module_3df70753f3f82078be9d4a2f1fb21880dbc76f447ff5787a09fb6f773a90fe1c.zig")).callValue(allocator, in));
        };
    }

    if ((block_16: {
        break :block_16 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) {
        return block_17: {
            break :block_17 (try (@import("zxc_module_2eacaec8fc1c63e7e74aae76ee97843ce718a6d309b7cff5b0e6631ea16f3591.zig")).callValue(allocator, in));
        };
    }

    return block_15: {
        const operand_1 = (in).frame;
        const operand_2 = @as(?u32, null);

        const operand_3 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_13: {
            const operand_7 = block_6: {
                const operand_4 = (in).input;
                const operand_5 = ((in).frame).id;

                break :block_6 @as((zx_abi).value_1323d051ef2b29690bf3e0d5973157e37a2ee5ed38a6c2349631e1e356aa78df, (zx_abi).value_1323d051ef2b29690bf3e0d5973157e37a2ee5ed38a6c2349631e1e356aa78df{ .input = operand_4, .id = operand_5, });
            };

            var state_borrow_8: (zx_abi).zx_type_70cc73e2d4def4cea2ef2031e5a44f78bd47edce381ada1465ee5b5bfd0992e2 = undefined;

            const operand_10 = (try (@import("zxc_module_cf64de78638ac75e2cfa08d887799a00f788ef839699255831589bc118a1e950.zig")).callValue(allocator, ((operand_7).zx_origin orelse block_9: {
                state_borrow_8 = (zx_abi).zx_type_70cc73e2d4def4cea2ef2031e5a44f78bd47edce381ada1465ee5b5bfd0992e2{ .id = (operand_7).id, .input = (operand_7).input, };

                break :block_9 (&state_borrow_8);
            })));

            break :block_13 block_12: {
                const operand_11 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_11).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_10);

                break :block_12 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_11);
            };
        });

        const operand_14 = @as([]const u8, "");

        break :block_15 @as((zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60, (zx_abi).value_55236f425e7ca85b27b66cbf27549e540336bb749c48e0162fd9997fd0cd1a60{ .frame = operand_1, .child = operand_2, .value = operand_3, .message = operand_14, });
    };
}

