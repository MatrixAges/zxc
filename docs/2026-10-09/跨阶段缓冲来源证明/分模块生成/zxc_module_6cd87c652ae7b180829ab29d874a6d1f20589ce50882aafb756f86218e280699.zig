const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_9b6f373dc55cc8bc51ff4cd91578ccc485f4097c47d0c4db5ea297ea1a026cae) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const value_12: (zx_abi).zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a = block_32: {
        const operand_10 = block_9: {
            const operand_2 = (in).origins;
            const operand_3 = (in).names;
            const operand_4 = (in).index;
            const operand_5 = (in).name;
            const operand_6 = @as(u64, 0);
            const operand_7 = @as(u64, 0);
            const operand_8 = true;

            break :block_9 (zx_abi).zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a{ .origins = operand_2, .names = operand_3, .id = operand_4, .name = operand_5, .index = operand_6, .result = operand_7, .valid = operand_8, };
        };

        var state_1: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (operand_10).id, .index = (operand_10).index, .name = (operand_10).name, .names = (operand_10).names, .origins = (operand_10).origins, .result = (operand_10).result, .valid = (operand_10).valid, .zx_origin = (&operand_10), };

        while (((state_1).valid and ((state_1).index < @as(u64, (((state_1).origins).ids).len)))) {
            state_1 = block_29: {
                const value_8: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((block_17: {
                    const operand_16 = block_15: {
                        const operand_13 = ((state_1).origins).ids;
                        const operand_14 = (state_1).index;

                        if ((operand_14 >= (operand_13).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_15 (operand_13)[@intCast(operand_14)];
                    };

                    break :block_17 (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, operand_16));
                } == (state_1).id)) block_28: {
                    const value_7: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = (if ((((state_1).result != @as(u64, 0)) or (!block_23: {
                        const operand_21 = block_20: {
                            const operand_18 = (state_1).names;
                            const operand_19 = (state_1).index;

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        };

                        const operand_22 = (state_1).name;

                        break :block_23 ((std).mem).eql(u8, operand_21, operand_22);
                    }))) block_25: {
                        const value_3: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        const value_4: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_24: {
                            break :block_24 @as((zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_3).id, .index = (value_3).index, .name = (value_3).name, .names = (value_3).names, .origins = (value_3).origins, .result = (value_3).result, .valid = false, });
                        };

                        break :block_25 value_4;
                    } else block_27: {
                        const value_5: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = state_1;

                        const value_6: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_26: {
                            break :block_26 @as((zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_5).id, .index = (value_5).index, .name = (value_5).name, .names = (value_5).names, .origins = (value_5).origins, .result = ((state_1).index + @as(u64, 2)), .valid = (value_5).valid, });
                        };

                        break :block_27 value_6;
                    });

                    break :block_28 value_7;
                } else state_1);

                const value_9: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = value_8;
                const value_10: u64 = (value_9).index;

                const value_11: (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = block_12: {
                    break :block_12 @as((zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca, (zx_abi).value_zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca{ .id = (value_9).id, .index = (block_11: {
                        break :block_11 value_10;
                    } + @as(u64, 1)), .name = (value_9).name, .names = (value_9).names, .origins = (value_9).origins, .result = (value_9).result, .valid = (value_9).valid, });
                };

                break :block_29 value_11;
            };
        }

        break :block_32 block_31: {
            break :block_31 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_30: {
                break :block_30 (zx_abi).zx_type_246a30e15d607724c1fd5492fd31dbbad17e32171c25a84b4ca5c08f4b46f21a{ .id = (state_1).id, .index = (state_1).index, .name = (state_1).name, .names = (state_1).names, .origins = (state_1).origins, .result = (state_1).result, .valid = (state_1).valid, };
            });
        };
    };

    return (if (((&value_12)).valid) ((&value_12)).result else @as(u64, 1));
}

