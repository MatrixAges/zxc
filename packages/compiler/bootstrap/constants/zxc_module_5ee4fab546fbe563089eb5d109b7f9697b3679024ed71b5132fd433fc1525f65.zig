const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_aa0d26cc0e88cd5936e5f12c41131a9936fbc2135966c84abd7ef1777ab7654c) error{ OutOfMemory, }!(zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_8f568b3b17837d2cfc380f3eb13c0b6101bbce8c12497f629d23ff5912b77c07 = block_55: {
        break :block_55 (try (@import("zxc_module_0b4e5b08b5272b98a696c13c1dc3ea54fd0d4e7c93faa02ee80e48c0621749ab.zig")).callValue(allocator, (in).operator));
    };

    if (((value_1).comparison or (value_1).logical)) {
        const value_2: bool = (if (((in).operator == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .LogicalAnd))) (((in).left).boolean and ((in).right).boolean) else (((in).left).boolean or ((in).right).boolean));

        return block_54: {
            const operand_41 = block_52: {
                const operand_42 = (in).left;
                const operand_43 = (in).type_id;
                const operand_44 = @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean);

                const operand_45 = (if ((value_1).comparison) block_48: {
                    const operand_46 = in;
                    var state_borrow_47: (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2 = undefined;
                    state_borrow_47 = (zx_abi).zx_type_53ec76125587621e567047ed3078e428abfa19d940d79fb21079139e2232c5a2{ .left = (operand_46).left, .operator = (operand_46).operator, .right = (operand_46).right, .type_id = (operand_46).type_id, };

                    break :block_48 (try (@import("zxc_module_ddcedbb1056abd7f5ef85e7eaca18d3783d477afbaa165ffde1036a49329465a.zig")).call(allocator, ((operand_46).zx_origin orelse (&state_borrow_47))));
                } else block_49: {
                    break :block_49 value_2;
                });

                break :block_52 block_51: {
                    const operand_50 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_50).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = operand_45, .enumeration = (operand_42).enumeration, .floating = (operand_42).floating, .integer = (operand_42).integer, .kind = operand_44, .negative = (operand_42).negative, .text = (operand_42).text, .type_id = operand_43, });

                    break :block_51 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_50);
                };
            };

            const operand_53 = @as([]const u8, "");

            break :block_54 @as((zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730, (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730{ .value = operand_41, .message = operand_53, });
        };
    }

    const value_3: (zx_abi).value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb = block_40: {
        break :block_40 (try (@import("zxc_module_e1c8902ffd77744a4ecf862199993c3e50b214e897f7f9840a414ec58ea80913.zig")).callValue(allocator, block_39: {
            const operand_36 = @as(?u32, ((in).left).type_id);
            const operand_37 = false;
            const operand_38 = false;

            break :block_39 @as((zx_abi).value_14e4e20a7eaf52d62a05f5e3274156a4a5e995de1cbdb7488cfe2fb12943bc46, (zx_abi).value_14e4e20a7eaf52d62a05f5e3274156a4a5e995de1cbdb7488cfe2fb12943bc46{ .expected = operand_36, .floating = operand_37, .negative = operand_38, });
        }));
    };

    if ((value_3).floating) {
        return block_35: {
            const operand_22 = block_33: {
                const operand_23 = (in).left;

                const operand_24 = block_30: {
                    const operand_25 = ((in).left).floating;
                    const operand_26 = ((in).right).floating;
                    const operand_27 = (in).operator;
                    const operand_28 = (value_3).single;
                    const operand_29 = (zx_abi).zx_type_5f777d5b198394d687d6c94540bd89ed586a39364125b4e444e5457a2eddeedd{ .left = operand_25, .right = operand_26, .operator = operand_27, .single = operand_28, };

                    break :block_30 (try (@import("zxc_module_d05506898623613ea90588492d7e6ce555ce0c800abc33ec9f3954741442d0b3.zig")).call(allocator, (&operand_29)));
                };

                break :block_33 block_32: {
                    const operand_31 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                    (operand_31).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = (operand_23).boolean, .enumeration = (operand_23).enumeration, .floating = operand_24, .integer = (operand_23).integer, .kind = (operand_23).kind, .negative = (operand_23).negative, .text = (operand_23).text, .type_id = (operand_23).type_id, });

                    break :block_32 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_31);
                };
            };

            const operand_34 = @as([]const u8, "");

            break :block_35 @as((zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730, (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730{ .value = operand_22, .message = operand_34, });
        };
    }

    const value_4: (zx_abi).value_b8158d62b5c164a2d0aac9fde6849ee1b0cf6a0c9c3479e7f6f9d6e8218509a2 = block_21: {
        break :block_21 (try (@import("zxc_module_636a4292a37594fc6cb4ad96264cb3bd392cc9c75b0a45cdc409de0aabd3a5a2.zig")).callValue(allocator, block_20: {
            const operand_10 = block_13: {
                const operand_11 = ((in).left).integer;
                const operand_12 = ((in).left).negative;

                break :block_13 @as((zx_abi).value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43, (zx_abi).value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43{ .magnitude = operand_11, .negative = operand_12, });
            };

            const operand_14 = block_17: {
                const operand_15 = ((in).right).integer;
                const operand_16 = ((in).right).negative;

                break :block_17 @as((zx_abi).value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43, (zx_abi).value_1e90546f6982f1ef7f90613f34c60e8d93b00a5485317b1a6eeab83c3362fc43{ .magnitude = operand_15, .negative = operand_16, });
            };

            const operand_18 = (in).operator;
            const operand_19 = value_3;

            break :block_20 @as((zx_abi).value_9665061c1684657adf2f7d7bb1d3cae18bfd07f85cc1b7701ce65593d567c0be, (zx_abi).value_9665061c1684657adf2f7d7bb1d3cae18bfd07f85cc1b7701ce65593d567c0be{ .left = operand_10, .right = operand_14, .operator = operand_18, .target = operand_19, });
        }));
    };

    return block_9: {
        const operand_1 = block_7: {
            const operand_2 = (in).left;
            const operand_3 = ((value_4).value).magnitude;
            const operand_4 = ((value_4).value).negative;

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6));

                (operand_5).* = @as((zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{ .boolean = (operand_2).boolean, .enumeration = (operand_2).enumeration, .floating = (operand_2).floating, .integer = operand_3, .kind = (operand_2).kind, .negative = operand_4, .text = (operand_2).text, .type_id = (operand_2).type_id, });

                break :block_6 @as(*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, operand_5);
            };
        };

        const operand_8 = (value_4).message;

        break :block_9 @as((zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730, (zx_abi).value_e28fd699d58e74d3c912203afb76a64c555ba1b78217862008d3fa7e7c69c730{ .value = operand_1, .message = operand_8, });
    };
}

