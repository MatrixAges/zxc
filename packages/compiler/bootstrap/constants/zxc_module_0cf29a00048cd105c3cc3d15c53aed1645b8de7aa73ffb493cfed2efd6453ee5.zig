const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_a5c84b87defda1648dfc9197232caacb869e2d570b4433b8088307078682ff5c) error{ OutOfMemory, }!(zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (in).value;

    if (((in).operator == @as((zx_abi).zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc, .Not))) {
        return block_65: {
            const operand_48 = block_63: {
                const operand_49 = block_50: {
                    break :block_50 value_1;
                };
                const operand_51 = (!(block_52: {
                    break :block_52 value_1;
                }).boolean);

                const operand_53 = operand_51;
                const operand_54 = (operand_49).enumeration;
                const operand_55 = (operand_49).floating;
                const operand_56 = (operand_49).integer;
                const operand_57 = (operand_49).kind;
                const operand_58 = (operand_49).negative;
                const operand_59 = (operand_49).text;
                const operand_60 = (operand_49).type_id;

                break :block_63 block_62: {
                    const operand_61 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_61).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_53, .enumeration = operand_54, .floating = operand_55, .integer = operand_56, .kind = operand_57, .negative = operand_58, .text = operand_59, .type_id = operand_60, });

                    break :block_62 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_61);
                };
            };

            const operand_64 = @as([]const u8, "");

            break :block_65 @as((zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079, (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079{ .value = operand_48, .message = operand_64, });
        };
    }

    if (((block_29: {
        break :block_29 value_1;
    }).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) {
        return block_47: {
            const operand_30 = block_45: {
                const operand_31 = block_32: {
                    break :block_32 value_1;
                };

                const operand_33 = (-(block_34: {
                    break :block_34 value_1;
                }).floating);

                const operand_35 = (operand_31).boolean;
                const operand_36 = (operand_31).enumeration;
                const operand_37 = operand_33;
                const operand_38 = (operand_31).integer;
                const operand_39 = (operand_31).kind;
                const operand_40 = (operand_31).negative;
                const operand_41 = (operand_31).text;
                const operand_42 = (operand_31).type_id;

                break :block_45 block_44: {
                    const operand_43 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_43).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_35, .enumeration = operand_36, .floating = operand_37, .integer = operand_38, .kind = operand_39, .negative = operand_40, .text = operand_41, .type_id = operand_42, });

                    break :block_44 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_43);
                };
            };

            const operand_46 = @as([]const u8, "");

            break :block_47 @as((zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079, (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079{ .value = operand_30, .message = operand_46, });
        };
    }

    const value_2: bool = (((block_27: {
        break :block_27 value_1;
    }).integer != @as(u64, 0)) and (!(block_28: {
        break :block_28 value_1;
    }).negative));

    const value_3: u64 = block_26: {
        break :block_26 (try (@import("zxc_module_97d5acb0eac558f02d6519bf2215567b8add38ec1e12c3a84f1b6119657a70b9.zig")).callValue(allocator, block_25: {
            const operand_21 = (block_22: {
                break :block_22 value_1;
            }).type_id;

            const operand_23 = block_24: {
                break :block_24 value_2;
            };

            break :block_25 @as((zx_abi).value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82, (zx_abi).value_c87219e24d3e912c9a036fe6a18be300d09a8f99aeeec6690c2b78df81dbaa82{ .id = operand_21, .negative = operand_23, });
        }));
    };

    return block_20: {
        const operand_1 = block_16: {
            const operand_2 = block_3: {
                break :block_3 value_1;
            };
            const operand_4 = block_5: {
                break :block_5 value_2;
            };

            const operand_6 = (operand_2).boolean;
            const operand_7 = (operand_2).enumeration;
            const operand_8 = (operand_2).floating;
            const operand_9 = (operand_2).integer;
            const operand_10 = (operand_2).kind;
            const operand_11 = operand_4;
            const operand_12 = (operand_2).text;
            const operand_13 = (operand_2).type_id;

            break :block_16 block_15: {
                const operand_14 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_14).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_6, .enumeration = operand_7, .floating = operand_8, .integer = operand_9, .kind = operand_10, .negative = operand_11, .text = operand_12, .type_id = operand_13, });

                break :block_15 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_14);
            };
        };

        const operand_17 = (if (((block_18: {
            break :block_18 value_1;
        }).integer > block_19: {
            break :block_19 value_3;
        })) @as([]const u8, "integer constant negation overflows its type") else @as([]const u8, ""));

        break :block_20 @as((zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079, (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079{ .value = operand_1, .message = operand_17, });
    };
}
