const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_b31e1f3ff2606243a59770b9884ec2327cd4659f2c59d3c417c15492bad8fc24) error{ OutOfMemory, }!(zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_4c071f9504777ddeed90bd97d0884f5b59841982e195a30987fb29a8fe908f74 = block_81: {
        break :block_81 (try (@import("zxc_module_0b4e5b08b5272b98a696c13c1dc3ea54fd0d4e7c93faa02ee80e48c0621749ab.zig")).callValue(allocator, (in).operator));
    };

    if (((value_1).comparison or (value_1).logical)) {
        return block_80: {
            const value_2: bool = (if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd))) (((in).left).boolean and ((in).right).boolean) else (((in).left).boolean or ((in).right).boolean));

            break :block_80 block_79: {
                const operand_57 = block_77: {
                    const operand_58 = (in).left;
                    const operand_59 = (in).type_id;
                    const operand_60 = @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean);

                    const operand_61 = (if ((value_1).comparison) block_65: {
                        const operand_62 = in;
                        var state_borrow_63: (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = undefined;

                        break :block_65 (try (@import("zxc_module_ddcedbb1056abd7f5ef85e7eaca18d3783d477afbaa165ffde1036a49329465a.zig")).call(allocator, ((operand_62).zx_origin orelse block_64: {
                            state_borrow_63 = (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2{ .left = (operand_62).left, .operator = (operand_62).operator, .right = (operand_62).right, .type_id = (operand_62).type_id, };

                            break :block_64 (&state_borrow_63);
                        })));
                    } else block_66: {
                        break :block_66 value_2;
                    });

                    const operand_67 = operand_61;
                    const operand_68 = (operand_58).enumeration;
                    const operand_69 = (operand_58).floating;
                    const operand_70 = (operand_58).integer;
                    const operand_71 = operand_60;
                    const operand_72 = (operand_58).negative;
                    const operand_73 = (operand_58).text;
                    const operand_74 = operand_59;

                    break :block_77 block_76: {
                        const operand_75 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                        (operand_75).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_67, .enumeration = operand_68, .floating = operand_69, .integer = operand_70, .kind = operand_71, .negative = operand_72, .text = operand_73, .type_id = operand_74, });

                        break :block_76 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_75);
                    };
                };

                const operand_78 = @as([]const u8, "");

                break :block_79 @as((zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801, (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801{ .value = operand_57, .message = operand_78, });
            };
        };
    }

    const value_3: (zx_abi).value_4ae5d85f1854ef8438f79c8e2a34690101e11594d44d507f9e5d0fe976d713ba = block_56: {
        break :block_56 (try (@import("zxc_module_e1c8902ffd77744a4ecf862199993c3e50b214e897f7f9840a414ec58ea80913.zig")).callValue(allocator, block_55: {
            const operand_52 = @as(?u32, ((in).left).type_id);
            const operand_53 = false;
            const operand_54 = false;

            break :block_55 @as((zx_abi).value_56204d00921c77db48327c86c39a353531ec7fb63ae311b6628ea40dcbe3e37a, (zx_abi).value_56204d00921c77db48327c86c39a353531ec7fb63ae311b6628ea40dcbe3e37a{ .expected = operand_52, .floating = operand_53, .negative = operand_54, });
        }));
    };

    if ((value_3).floating) {
        return block_51: {
            const operand_30 = block_49: {
                const operand_31 = (in).left;

                const operand_32 = block_38: {
                    const operand_33 = ((in).left).floating;
                    const operand_34 = ((in).right).floating;
                    const operand_35 = (in).operator;
                    const operand_36 = (value_3).single;
                    const operand_37 = (zx_abi).zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd{ .left = operand_33, .right = operand_34, .operator = operand_35, .single = operand_36, };

                    break :block_38 (try (@import("zxc_module_d05506898623613ea90588492d7e6ce555ce0c800abc33ec9f3954741442d0b3.zig")).call(allocator, (&operand_37)));
                };

                const operand_39 = (operand_31).boolean;
                const operand_40 = (operand_31).enumeration;
                const operand_41 = operand_32;
                const operand_42 = (operand_31).integer;
                const operand_43 = (operand_31).kind;
                const operand_44 = (operand_31).negative;
                const operand_45 = (operand_31).text;
                const operand_46 = (operand_31).type_id;

                break :block_49 block_48: {
                    const operand_47 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_47).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_39, .enumeration = operand_40, .floating = operand_41, .integer = operand_42, .kind = operand_43, .negative = operand_44, .text = operand_45, .type_id = operand_46, });

                    break :block_48 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_47);
                };
            };

            const operand_50 = @as([]const u8, "");

            break :block_51 @as((zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801, (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801{ .value = operand_30, .message = operand_50, });
        };
    }

    const value_4: (zx_abi).value_518749b944e3124ffa95d6666f8946977aaa50b8334338de7d2d26f3ff6b1a64 = block_29: {
        break :block_29 (try (@import("zxc_module_636a4292a37594fc6cb4ad96264cb3bd392cc9c75b0a45cdc409de0aabd3a5a2.zig")).callValue(allocator, block_28: {
            const operand_18 = block_21: {
                const operand_19 = ((in).left).integer;
                const operand_20 = ((in).left).negative;

                break :block_21 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_19, .negative = operand_20, });
            };

            const operand_22 = block_25: {
                const operand_23 = ((in).right).integer;
                const operand_24 = ((in).right).negative;

                break :block_25 @as((zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7, (zx_abi).value_95a230426f58e2dcc38633e76b2defdea0ed4ce403a10783469a0d8a554aefb7{ .magnitude = operand_23, .negative = operand_24, });
            };

            const operand_26 = (in).operator;
            const operand_27 = value_3;

            break :block_28 @as((zx_abi).value_45e27a85c7b9586703e90f083f49768be5be45cac997454291d0ba1bf059ffb3, (zx_abi).value_45e27a85c7b9586703e90f083f49768be5be45cac997454291d0ba1bf059ffb3{ .left = operand_18, .right = operand_22, .operator = operand_26, .target = operand_27, });
        }));
    };

    return block_17: {
        const operand_1 = block_15: {
            const operand_2 = (in).left;
            const operand_3 = ((value_4).value).magnitude;
            const operand_4 = ((value_4).value).negative;
            const operand_5 = (operand_2).boolean;
            const operand_6 = (operand_2).enumeration;
            const operand_7 = (operand_2).floating;
            const operand_8 = operand_3;
            const operand_9 = (operand_2).kind;
            const operand_10 = operand_4;
            const operand_11 = (operand_2).text;
            const operand_12 = (operand_2).type_id;

            break :block_15 block_14: {
                const operand_13 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_13).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_5, .enumeration = operand_6, .floating = operand_7, .integer = operand_8, .kind = operand_9, .negative = operand_10, .text = operand_11, .type_id = operand_12, });

                break :block_14 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_13);
            };
        };

        const operand_16 = (value_4).message;

        break :block_17 @as((zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801, (zx_abi).value_df53e49a602877d45cafdf17dc2cca444fb52a1d2e680534d9c983eb4f36a801{ .value = operand_1, .message = operand_16, });
    };
}

