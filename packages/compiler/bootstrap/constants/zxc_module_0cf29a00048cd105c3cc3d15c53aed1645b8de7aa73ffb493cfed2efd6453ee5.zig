const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_2bc98809742cdb5e417517aaf2902b5999ac65f64b1c5cd3f15968b6f1ded035) error{ OutOfMemory, }!(zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (in).value;

    if (((in).operator == @as((zx_abi).zx_type_c6461b7a5dc793cd488e19b7dfaa77adb3feded09802d087ab84f52092ba2cdc, .Not))) {
        return block_66: {
            const operand_49 = block_64: {
                const operand_50 = block_51: {
                    break :block_51 value_1;
                };
                const operand_52 = (!(block_53: {
                    break :block_53 value_1;
                }).boolean);

                const operand_54 = operand_52;
                const operand_55 = (operand_50).enumeration;
                const operand_56 = (operand_50).floating;
                const operand_57 = (operand_50).integer;
                const operand_58 = (operand_50).kind;
                const operand_59 = (operand_50).negative;
                const operand_60 = (operand_50).text;
                const operand_61 = (operand_50).type_id;

                break :block_64 block_63: {
                    const operand_62 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_62).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_54, .enumeration = operand_55, .floating = operand_56, .integer = operand_57, .kind = operand_58, .negative = operand_59, .text = operand_60, .type_id = operand_61, });

                    break :block_63 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_62);
                };
            };

            const operand_65 = @as([]const u8, "");

            break :block_66 @as((zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801, (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801{ .value = operand_49, .message = operand_65, });
        };
    }

    if (((block_30: {
        break :block_30 value_1;
    }).kind == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) {
        return block_48: {
            const operand_31 = block_46: {
                const operand_32 = block_33: {
                    break :block_33 value_1;
                };
                const operand_34 = (-(block_35: {
                    break :block_35 value_1;
                }).floating);

                const operand_36 = (operand_32).boolean;
                const operand_37 = (operand_32).enumeration;
                const operand_38 = operand_34;
                const operand_39 = (operand_32).integer;
                const operand_40 = (operand_32).kind;
                const operand_41 = (operand_32).negative;
                const operand_42 = (operand_32).text;
                const operand_43 = (operand_32).type_id;

                break :block_46 block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_44).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_36, .enumeration = operand_37, .floating = operand_38, .integer = operand_39, .kind = operand_40, .negative = operand_41, .text = operand_42, .type_id = operand_43, });

                    break :block_45 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_44);
                };
            };

            const operand_47 = @as([]const u8, "");

            break :block_48 @as((zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801, (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801{ .value = operand_31, .message = operand_47, });
        };
    }

    const value_2: bool = (((block_28: {
        break :block_28 value_1;
    }).integer != @as(u64, 0)) and (!(block_29: {
        break :block_29 value_1;
    }).negative));

    return block_27: {
        const value_3: u64 = block_26: {
            const operand_22 = (block_21: {
                break :block_21 value_1;
            }).type_id;

            const operand_24 = block_23: {
                break :block_23 value_2;
            };

            const operand_25 = (zx_abi).zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3{ .id = operand_22, .negative = operand_24, };

            break :block_26 (try (@import("zxc_module_97d5acb0eac558f02d6519bf2215567b8add38ec1e12c3a84f1b6119657a70b9.zig")).call(allocator, (&operand_25)));
        };

        break :block_27 block_20: {
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

            break :block_20 @as((zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801, (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801{ .value = operand_1, .message = operand_17, });
        };
    };
}

