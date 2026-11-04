const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000 {
    @setRuntimeSafety(true);

    const value_8: (zx_abi).value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58 = block_48: {
        const value_2: (zx_abi).value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba = (zx_abi).value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba{ .items = ((in).expressions).kinds, .headered = false, };

        break :block_48 block_47: {
            const operand_25 = block_24: {
                const operand_20 = value_2;
                const operand_21 = @as(u64, 0);

                const operand_22 = block_23: {
                    break :block_23 (zx_abi).value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58{ .items = (&[_]?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6{}), .headered = false, };
                };

                break :block_24 @as((zx_abi).value_5fd6d441d3180a196d3716fae1f94ba890f374bd50a3c6aa4ca3cce72e93f210, (zx_abi).value_5fd6d441d3180a196d3716fae1f94ba890f374bd50a3c6aa4ca3cce72e93f210{ .index = operand_21, .result = operand_22, .source = operand_20, });
            };
            const loop_fields_27 = struct {
                index: u64,
                result: (zx_abi).value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58,
                source: *const (zx_abi).value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba,
                zx_origin: ?*const (zx_abi).zx_type_156ae23e9cfe6b3b61799ecbfe5a0c6a998096a577c01043c475dbfd39725bda = null,
            };

            const loop_seed_26: (zx_abi).value_5fd6d441d3180a196d3716fae1f94ba890f374bd50a3c6aa4ca3cce72e93f210 = operand_25;

            break :block_47 (if (((loop_seed_26).index < @as(u64, (((loop_seed_26).source).items).len))) block_45: {
                var state_19: loop_fields_27 = loop_fields_27{ .index = (loop_seed_26).index, .result = (loop_seed_26).result, .source = (&(loop_seed_26).source), .zx_origin = (loop_seed_26).zx_origin, };

                while (true) {
                    state_19 = block_43: {
                        _ = block_42: {
                            const operand_40 = (((state_19).source).*).items;
                            const operand_41 = (state_19).index;

                            if ((operand_41 >= (operand_40).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_42 (operand_40)[@intCast(operand_41)];
                        };

                        const value_6: ?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);

                        break :block_43 block_39: {
                            const operand_28 = ((state_19).source).*;
                            const operand_29 = ((state_19).index + @as(u64, 1));
                            const operand_30 = (block_37: {
                                const operand_31 = (state_19).result;

                                const operand_33 = block_32: {
                                    break :block_32 value_6;
                                };

                                const operand_34 = (try ((std).math).add(usize, ((operand_31).items).len, 1));

                                break :block_37 @as((zx_abi).value_728d2383a7b5714f531290e6953ef3a173b85b9ab82a32fc253477fa434524db, .{ block_36: {
                                    const operand_35 = (try (zx_abi).zxReserve(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, allocator, (operand_31).items, operand_34, true));

                                    (operand_35)[((operand_31).items).len] = operand_33;

                                    break :block_36 (zx_abi).value_fbcea94e2e2f2dda10c1dba6b3907ac628e9d594ae91877115e25642bc706d58{ .items = operand_35, .headered = true, };
                                }, {}, null, });
                            }).@"0";

                            break :block_39 loop_fields_27{ .index = operand_29, .result = operand_30, .source = block_38: {
                                _ = operand_28;

                                break :block_38 (&(loop_seed_26).source);
                            }, };
                        };
                    };

                    if ((!((state_19).index < @as(u64, ((((state_19).source).*).items).len)))) {
                        break;
                    }
                }

                const operand_44 = (zx_abi).value_5fd6d441d3180a196d3716fae1f94ba890f374bd50a3c6aa4ca3cce72e93f210{ .index = (state_19).index, .result = (state_19).result, .source = ((state_19).source).*, .zx_origin = (state_19).zx_origin, };

                break :block_45 (operand_44).result;
            } else block_46: {
                break :block_46 (loop_seed_26).result;
            });
        };
    };

    return block_18: {
        const operand_1 = block_10: {
            const operand_9 = block_8: {
                const operand_2 = (in).root;
                const operand_3 = @as(u64, 0);
                const operand_4 = operand_2;
                const operand_5 = operand_3;

                break :block_8 block_7: {
                    const operand_6 = (try (allocator).create((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2));

                    (operand_6).* = @as((zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{ .id = operand_4, .arm = operand_5, });

                    break :block_7 @as(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, operand_6);
                };
            };

            break :block_10 (zx_abi).value_9abd23e7675966d9bb975045a789abcb353fb365db04f01d35777c2ef0a68d56{ .items = (try (allocator).dupe(*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2, (&[_]*const (zx_abi).zx_type_14cd085379943d00f98557d8a978fe987a60a5b1449fe3c3d9a0ee66354180a2{operand_9, }))), .headered = false, };
        };

        const operand_11 = value_8;

        const operand_12 = block_17: {
            const operand_13 = @as([]const u8, "");
            const operand_14 = @as(u64, 0);
            const operand_15 = @as(u64, 0);
            const operand_16 = @as([]const u8, "");

            break :block_17 @as((zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de{ .code = operand_13, .start = operand_14, .end = operand_15, .message = operand_16, });
        };

        break :block_18 @as((zx_abi).value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000, (zx_abi).value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000{ .frames = operand_1, .values = operand_11, .diagnostic = operand_12, });
    };
}

