const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_c7d43c17aac39d8fa5ff7a7c2539633fda0c27a5d444f1dd0bb0a8b12f3e6108) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_24: {
        const operand_22 = (((in).input).expressions).kinds;
        const operand_23 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, ((in).frame).id));

        if ((operand_23 >= (operand_22).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_24 (operand_22)[@intCast(operand_23)];
    };

    if (((block_19: {
        break :block_19 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_20: {
        break :block_20 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)))) {
        return block_21: {
            break :block_21 (try (@import("zxc_module_d091a2c13fd58458ee549ed30219dfc43970426e2baf9c4e964bf91640c2d20b.zig")).callValue(allocator, in));
        };
    }

    if ((block_17: {
        break :block_17 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) {
        return block_18: {
            break :block_18 (try (@import("zxc_module_3df70753f3f82078be9d4a2f1fb21880dbc76f447ff5787a09fb6f773a90fe1c.zig")).callValue(allocator, in));
        };
    }

    if ((block_15: {
        break :block_15 value_1;
    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) {
        return block_16: {
            break :block_16 (try (@import("zxc_module_2eacaec8fc1c63e7e74aae76ee97843ce718a6d309b7cff5b0e6631ea16f3591.zig")).callValue(allocator, in));
        };
    }

    return block_14: {
        const operand_1 = (in).frame;
        const operand_2 = @as(?u32, null);

        const operand_3 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_12: {
            const operand_7 = block_6: {
                const operand_4 = (in).input;
                const operand_5 = ((in).frame).id;

                break :block_6 @as((zx_abi).value_686162ce84bf0ca7a8acc1ef308e84a546d3eb5f7c94d4c5725fc373b98b2027, (zx_abi).value_686162ce84bf0ca7a8acc1ef308e84a546d3eb5f7c94d4c5725fc373b98b2027{ .input = operand_4, .id = operand_5, });
            };

            var state_borrow_8: (zx_abi).zx_type_3425a43fd8455c89a26bbf3ccd1009e459c685a636082fd3a553b2166db51923 = undefined;

            state_borrow_8 = (zx_abi).zx_type_3425a43fd8455c89a26bbf3ccd1009e459c685a636082fd3a553b2166db51923{ .id = (operand_7).id, .input = (operand_7).input, };

            const operand_9 = (try (@import("zxc_module_cf64de78638ac75e2cfa08d887799a00f788ef839699255831589bc118a1e950.zig")).callValue(allocator, ((operand_7).zx_origin orelse (&state_borrow_8))));

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_10).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_9);

                break :block_11 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_10);
            };
        });

        const operand_13 = @as([]const u8, "");

        break :block_14 @as((zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f, (zx_abi).value_e9b001f2741e372c882b85971c517374e167d65a8491b50891eaae44e088a83f{ .frame = operand_1, .child = operand_2, .value = operand_3, .message = operand_13, });
    };
}

