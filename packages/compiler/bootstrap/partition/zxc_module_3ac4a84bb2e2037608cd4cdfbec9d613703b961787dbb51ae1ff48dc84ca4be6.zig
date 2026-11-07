const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 = block_44: {
        break :block_44 (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
            .items = (&[_]*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0{}),
            .storage = .plain,
        };
    };

    return block_43: {
        const value_11: (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = block_42: {
            const operand_40 = value_1;
            const operand_41 = @as(u64, 0);

            break :block_42 @as((zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5, (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5{
                .values = operand_40,
                .index = operand_41,
            });
        };

        const value_12: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = in;

        break :block_43 block_39: {
            break :block_39 block_38: {
                const operand_2 = value_11;
                var state_1: (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = operand_2;

                while (block_6: {
                    const value_3: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = block_5: {
                        break :block_5 value_12;
                    };

                    break :block_6 ((state_1).index < @as(u64, ((block_4: {
                        break :block_4 value_3;
                    }).roots).len));
                }) {
                    const operand_33 = block_32: {
                        const value_5: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = block_31: {
                            break :block_31 value_12;
                        };

                        break :block_32 block_30: {
                            const value_6: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 = block_29: {
                                const operand_23 = block_22: {
                                    const operand_19 = block_20: {
                                        break :block_20 value_5;
                                    };

                                    const operand_21 = (state_1).index;

                                    break :block_22 @as((zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670, (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670{
                                        .graph = operand_19,
                                        .index = operand_21,
                                    });
                                };
                                var state_borrow_24: (zx_abi).zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04 = undefined;

                                const operand_26 = (try (@import("zxc_module_cd98359391a9bf4d564075bd1a962e06a1924831e5e275e8e6ca6881618749c2.zig")).callValue(allocator, ((operand_23).zx_origin orelse block_25: {
                                    state_borrow_24 = (zx_abi).zx_type_fac74823528ee70421ea01e33f07fcc2720bd37e898d7dcd472ca535d77b1c04{
                                        .graph = (operand_23).graph,
                                        .index = (operand_23).index,
                                    };

                                    break :block_25 (&state_borrow_24);
                                })));

                                break :block_29 block_28: {
                                    const operand_27 = (try (allocator).create((zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0));

                                    (operand_27).* = @as((zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, operand_26);

                                    break :block_28 @as(*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, operand_27);
                                };
                            };
                            var value_7: (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = block_18: {
                                var updated_9: (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = state_1;

                                const operand_17 = (block_16: {
                                    const operand_10 = (state_1).values;

                                    const operand_12 = block_11: {
                                        break :block_11 value_6;
                                    };

                                    const operand_13 = (try ((std).math).add(usize, ((operand_10).items).len, 1));

                                    break :block_16 @as((zx_abi).value_815ae0977cc108d3872b516d613b6f7677cf0c29ff030c881161032de451261c, .{
                                        block_15: {
                                            const operand_14 = (try (zx_abi).zxReserve(*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, allocator, (operand_10).items, operand_13, true));

                                            (operand_14)[((operand_10).items).len] = operand_12;

                                            break :block_15 (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
                                                .items = operand_14,
                                                .storage = (if (((((operand_10).items).len == 0) or ((operand_10).storage == .exclusive))) .exclusive else .shared),
                                            };
                                        },
                                        {},
                                        null,
                                    });
                                }).@"0";

                                (updated_9).values = operand_17;
                                (updated_9).zx_origin = null;

                                break :block_18 updated_9;
                            };
                            const value_8: u64 = (value_7).index;

                            const operand_8 = (block_7: {
                                break :block_7 value_8;
                            } + @as(u64, 1));

                            (value_7).index = operand_8;
                            (value_7).zx_origin = null;

                            break :block_30 value_7;
                        };
                    };

                    const operand_34 = (operand_33).index;
                    const operand_35 = ((operand_33).values).items;
                    const operand_36 = ((operand_33).values).storage;
                    const operand_37 = (operand_33).zx_origin;

                    (state_1).index = operand_34;
                    ((state_1).values).items = operand_35;
                    ((state_1).values).storage = operand_36;
                    (state_1).zx_origin = operand_37;
                }

                break :block_38 (state_1).values;
            };
        };
    };
}
