const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_de7e557a1f4d614dfa1118c605778c70db10cfe21b8d0483d1af3768155ad272) error{ OutOfMemory, }!(zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (in).value;

    if (((in).operator == @as((zx_abi).zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc, .Not))) {
        return block_41: {
            const operand_32 = block_39: {
                const operand_33 = block_34: {
                    break :block_34 value_1;
                };
                const operand_35 = (!(block_36: {
                    break :block_36 value_1;
                }).boolean);

                break :block_39 block_38: {
                    const operand_37 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_37).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_35, .enumeration = (operand_33).enumeration, .floating = (operand_33).floating, .integer = (operand_33).integer, .kind = (operand_33).kind, .negative = (operand_33).negative, .text = (operand_33).text, .type_id = (operand_33).type_id, });

                    break :block_38 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_37);
                };
            };

            const operand_40 = @as([]const u8, "");

            break :block_41 @as((zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730, (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730{ .value = operand_32, .message = operand_40, });
        };
    }

    if (((block_21: {
        break :block_21 value_1;
    }).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) {
        return block_31: {
            const operand_22 = block_29: {
                const operand_23 = block_24: {
                    break :block_24 value_1;
                };

                const operand_25 = (-(block_26: {
                    break :block_26 value_1;
                }).floating);

                break :block_29 block_28: {
                    const operand_27 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_27).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = (operand_23).boolean, .enumeration = (operand_23).enumeration, .floating = operand_25, .integer = (operand_23).integer, .kind = (operand_23).kind, .negative = (operand_23).negative, .text = (operand_23).text, .type_id = (operand_23).type_id, });

                    break :block_28 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_27);
                };
            };

            const operand_30 = @as([]const u8, "");

            break :block_31 @as((zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730, (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730{ .value = operand_22, .message = operand_30, });
        };
    }

    const value_2: bool = (((block_19: {
        break :block_19 value_1;
    }).integer != @as(u64, 0)) and (!(block_20: {
        break :block_20 value_1;
    }).negative));

    const value_3: u64 = block_18: {
        const operand_14 = (block_13: {
            break :block_13 value_1;
        }).type_id;

        const operand_16 = block_15: {
            break :block_15 value_2;
        };

        const operand_17 = (zx_abi).zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3{ .id = operand_14, .negative = operand_16, };

        break :block_18 (try (@import("zxc_module_97d5acb0eac558f02d6519bf2215567b8add38ec1e12c3a84f1b6119657a70b9.zig")).call(allocator, (&operand_17)));
    };

    return block_12: {
        const operand_1 = block_8: {
            const operand_2 = block_3: {
                break :block_3 value_1;
            };
            const operand_4 = block_5: {
                break :block_5 value_2;
            };

            break :block_8 block_7: {
                const operand_6 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_6).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = (operand_2).boolean, .enumeration = (operand_2).enumeration, .floating = (operand_2).floating, .integer = (operand_2).integer, .kind = (operand_2).kind, .negative = operand_4, .text = (operand_2).text, .type_id = (operand_2).type_id, });

                break :block_7 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_6);
            };
        };

        const operand_9 = (if (((block_10: {
            break :block_10 value_1;
        }).integer > block_11: {
            break :block_11 value_3;
        })) @as([]const u8, "integer constant negation overflows its type") else @as([]const u8, ""));

        break :block_12 @as((zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730, (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730{ .value = operand_1, .message = operand_9, });
    };
}

