const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_569857ab18ea15bc344de2261ff713ca9037f41a1159e53f0a46a9cc352fd549) error{ OutOfMemory, }!(zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_689e23ee7139780f604480466a9018948fb64d9ad804e5418ca24225333ddd26 = block_68: {
        break :block_68 (try (@import("zxc_module_0b4e5b08b5272b98a696c13c1dc3ea54fd0d4e7c93faa02ee80e48c0621749ab.zig")).callValue(allocator, (in).operator));
    };

    if (((value_1).comparison or (value_1).logical)) {
        const value_2: bool = (if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd))) (((in).left).boolean and ((in).right).boolean) else (((in).left).boolean or ((in).right).boolean));

        return block_67: {
            const operand_50 = block_65: {
                const operand_51 = (in).left;
                const operand_52 = (in).type_id;
                const operand_53 = @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean);

                const operand_54 = (if ((value_1).comparison) block_55: {
                    break :block_55 (try (@import("zxc_module_ddcedbb1056abd7f5ef85e7eaca18d3783d477afbaa165ffde1036a49329465a.zig")).callValue(allocator, in));
                } else block_56: {
                    break :block_56 value_2;
                });

                const operand_60 = operand_54;
                const operand_61 = operand_53;
                const operand_62 = operand_52;

                break :block_65 block_64: {
                    const operand_63 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_63).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_59: {
                        var updated_57: (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (operand_51).*;
                        const updated_57_value_0 = operand_60;
                        const updated_57_value_4 = operand_61;
                        const updated_57_value_7 = operand_62;
                        (updated_57).boolean = updated_57_value_0;
                        (updated_57).kind = updated_57_value_4;
                        (updated_57).type_id = updated_57_value_7;

                        break :block_59 updated_57;
                    });

                    break :block_64 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_63);
                };
            };

            const operand_66 = @as([]const u8, "");

            break :block_67 @as((zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079, (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079{ .value = operand_50, .message = operand_66, });
        };
    }

    const value_3: (zx_abi).value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738 = block_49: {
        break :block_49 (try (@import("zxc_module_e1c8902ffd77744a4ecf862199993c3e50b214e897f7f9840a414ec58ea80913.zig")).callValue(allocator, block_48: {
            const operand_45 = @as(?u32, ((in).left).type_id);
            const operand_46 = false;
            const operand_47 = false;

            break :block_48 @as((zx_abi).value_6896a6f6ff06025aa0a5b1bbd683e697aaec890757fbb83719139c018dd0273e, (zx_abi).value_6896a6f6ff06025aa0a5b1bbd683e697aaec890757fbb83719139c018dd0273e{ .expected = operand_45, .floating = operand_46, .negative = operand_47, });
        }));
    };

    if ((value_3).floating) {
        return block_44: {
            const operand_27 = block_42: {
                const operand_28 = (in).left;

                const operand_29 = block_35: {
                    break :block_35 (try (@import("zxc_module_d05506898623613ea90588492d7e6ce555ce0c800abc33ec9f3954741442d0b3.zig")).callValue(allocator, block_34: {
                        const operand_30 = ((in).left).floating;
                        const operand_31 = ((in).right).floating;
                        const operand_32 = (in).operator;
                        const operand_33 = (value_3).single;

                        break :block_34 @as((zx_abi).value_fcb5f5f55d3dfdeb01df684c868983d93c574c18a04bbb9db91705b5ce695521, (zx_abi).value_fcb5f5f55d3dfdeb01df684c868983d93c574c18a04bbb9db91705b5ce695521{ .left = operand_30, .right = operand_31, .operator = operand_32, .single = operand_33, });
                    }));
                };

                const operand_37 = operand_29;

                break :block_42 block_41: {
                    const operand_40 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_40).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_39: {
                        var updated_36: (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (operand_28).*;
                        const operand_38 = operand_37;

                        (updated_36).floating = operand_38;

                        break :block_39 updated_36;
                    });

                    break :block_41 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_40);
                };
            };

            const operand_43 = @as([]const u8, "");

            break :block_44 @as((zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079, (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079{ .value = operand_27, .message = operand_43, });
        };
    }

    const value_4: (zx_abi).value_6b47f20da602e44b98b2a97d02f21f0dbd5a9da959daa8ecedf10c67febd2a1d = block_26: {
        break :block_26 (try (@import("zxc_module_636a4292a37594fc6cb4ad96264cb3bd392cc9c75b0a45cdc409de0aabd3a5a2.zig")).callValue(allocator, block_25: {
            const operand_15 = block_18: {
                const operand_16 = ((in).left).integer;
                const operand_17 = ((in).left).negative;

                break :block_18 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_16, .negative = operand_17, });
            };

            const operand_19 = block_22: {
                const operand_20 = ((in).right).integer;
                const operand_21 = ((in).right).negative;

                break :block_22 @as((zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2, (zx_abi).value_fa0b2f990e440d45aa9c478fcb2ad94eb0bb9338760981c0790a6705caea75c2{ .magnitude = operand_20, .negative = operand_21, });
            };

            const operand_23 = (in).operator;
            const operand_24 = value_3;

            break :block_25 @as((zx_abi).value_0c5df734a22686860134c5a0b4c00493a1fdf6aa6b84440441b736799db1a762, (zx_abi).value_0c5df734a22686860134c5a0b4c00493a1fdf6aa6b84440441b736799db1a762{ .left = operand_15, .right = operand_19, .operator = operand_23, .target = operand_24, });
        }));
    };

    return block_14: {
        const operand_1 = block_12: {
            const operand_2 = (in).left;
            const operand_3 = ((value_4).value).magnitude;
            const operand_4 = ((value_4).value).negative;
            const operand_8 = operand_3;
            const operand_9 = operand_4;

            break :block_12 block_11: {
                const operand_10 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_10).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, block_7: {
                    var updated_5: (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = (operand_2).*;
                    const updated_5_value_3 = operand_8;
                    const updated_5_value_5 = operand_9;
                    (updated_5).integer = updated_5_value_3;
                    (updated_5).negative = updated_5_value_5;

                    break :block_7 updated_5;
                });

                break :block_11 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_10);
            };
        };

        const operand_13 = (value_4).message;

        break :block_14 @as((zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079, (zx_abi).value_1c7d158439ca5ecd65b6fbea96d477643e278a3b9b8b6906d7170d5e0d508079{ .value = operand_1, .message = operand_13, });
    };
}
