const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44) error{
    IndexOutOfBounds,
    OutOfMemory,
    Overflow,
}!(zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 = block_39: {
        break :block_39 (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
            .items = (&[_]*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0{}),
            .storage = .plain,
        };
    };

    return block_38: {
        const value_11: (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = block_37: {
            const operand_35 = value_1;
            const operand_36 = @as(u64, 0);

            break :block_37 @as((zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5, (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5{
                .values = operand_35,
                .index = operand_36,
            });
        };

        const value_12: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = in;

        break :block_38 block_34: {
            break :block_34 block_33: {
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
                    const operand_28 = block_27: {
                        const value_5: *const (zx_abi).zx_type_f32a2f1b3e858d65603564b96c7e29e423cfc69283104e955a8cf7b8fe6a5b44 = block_26: {
                            break :block_26 value_12;
                        };
                        break :block_27 block_25: {
                            const value_6: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 = block_24: {
                                break :block_24 (try (@import("zxc_module_cd98359391a9bf4d564075bd1a962e06a1924831e5e275e8e6ca6881618749c2.zig")).callValue(allocator, block_23: {
                                    const operand_20 = block_21: {
                                        break :block_21 value_5;
                                    };

                                    const operand_22 = (state_1).index;

                                    break :block_23 @as((zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670, (zx_abi).value_1d242fa07cc24f0ba80005ebf93581f5523cda258c690fec0b2efb92e2f81670{
                                        .graph = operand_20,
                                        .index = operand_22,
                                    });
                                }));
                            };
                            var value_7: (zx_abi).value_a545fc4d7ff45861d68a8cfbae3eca58729b81f35d47032131985fb164093dc5 = block_19: {
                                break :block_19 block_18: {
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
                                                    .storage = (if ((((((operand_10).items).len == 0) or ((operand_14).ptr != ((operand_10).items).ptr)) or ((operand_10).storage == .exclusive))) .exclusive else .shared),
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
                            };
                            const value_8: u64 = (value_7).index;

                            const operand_8 = (block_7: {
                                break :block_7 value_8;
                            } + @as(u64, 1));

                            (value_7).index = operand_8;
                            (value_7).zx_origin = null;

                            break :block_25 value_7;
                        };
                    };

                    const operand_29 = (operand_28).index;
                    const operand_30 = ((operand_28).values).items;
                    const operand_31 = ((operand_28).values).storage;
                    const operand_32 = (operand_28).zx_origin;
                    (state_1).index = operand_29;
                    ((state_1).values).items = operand_30;
                    ((state_1).values).storage = operand_31;
                    (state_1).zx_origin = operand_32;
                }

                break :block_33 (state_1).values;
            };
        };
    };
}
