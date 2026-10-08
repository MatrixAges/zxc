const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_12;
pub const Output = *const (zx_abi).zx_type_13;
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .start = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .initial = zx_shape_7, .other = zx_shape_7, .previous = zx_shape_7, .steps = zx_shape_5, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .previous = zx_shape_7, .total = zx_shape_7, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .leaf = zx_shape_14, .limit = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .left = zx_shape_14, .limit = zx_shape_5, .previous = zx_shape_7, .right = zx_shape_14, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .limit = zx_shape_5, .pair = zx_shape_16, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .previous = zx_shape_7, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .box = zx_shape_19, .index = zx_shape_5, .limit = zx_shape_5, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ }!(zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_18 = block_58: {
        const operand_44 = block_54: {
            const operand_50 = block_49: {
                const operand_45 = (in).start;
                const operand_46 = (in).start;

                break :block_49 block_48: {
                    const operand_47 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_47).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_45, .previous = operand_46, });

                    break :block_48 @as(*const (zx_abi).zx_type_14, operand_47);
                };
            };

            const operand_51 = @as(u64, 0);

            break :block_54 block_53: {
                const operand_52 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_52).* = @as((zx_abi).zx_type_16, .{ operand_50, operand_51, });

                break :block_53 @as(*const (zx_abi).zx_type_16, operand_52);
            };
        };

        const operand_55 = (in).count;

        break :block_58 block_57: {
            const operand_56 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_56).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_44, .limit = operand_55, });

            break :block_57 @as(*const (zx_abi).zx_type_18, operand_56);
        };
    };

    const value_18: *const (zx_abi).zx_type_18 = block_43: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_11).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_11).pair).@"0", ((operand_11).pair).@"1", (operand_11).pair, }), .zx_origin = operand_11, };
        var state_changed_12 = false;

        while ((((state_10).pair).@"1" < (state_10).limit)) {
            state_10 = block_37: {
                const value_4: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_36: {
                    break :block_36 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = state_10;
                const value_6: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_5).pair;
                const value_7: *const (zx_abi).zx_type_14 = (value_6).@"0";

                const value_8: i64 = (block_35: {
                    break :block_35 value_7;
                }).total;

                const value_9: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_34: {
                    break :block_34 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_5).limit, .pair = block_33: {
                        const operand_31 = block_30: {
                            break :block_30 block_29: {
                                const operand_28 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_28).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_26: {
                                    break :block_26 value_7;
                                }).previous, .total = (block_27: {
                                    break :block_27 value_8;
                                } + @as(i64, 1)), });

                                break :block_29 @as(*const (zx_abi).zx_type_14, operand_28);
                            };
                        };

                        const operand_32 = (value_6).@"1";

                        break :block_33 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_31, operand_32, null, });
                    }, });
                };

                const value_10: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_9;
                const value_11: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_10).pair;
                const value_12: *const (zx_abi).zx_type_14 = (value_11).@"0";

                const value_13: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_25: {
                    break :block_25 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_10).limit, .pair = block_24: {
                        const operand_22 = block_21: {
                            break :block_21 block_20: {
                                const operand_19 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_19).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((value_4).pair).@"0").total, .total = (block_18: {
                                    break :block_18 value_12;
                                }).total, });

                                break :block_20 @as(*const (zx_abi).zx_type_14, operand_19);
                            };
                        };

                        const operand_23 = (value_11).@"1";

                        break :block_24 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_22, operand_23, null, });
                    }, });
                };

                const value_14: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_13;
                const value_15: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_17: {
                    break :block_17 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_14).limit, .pair = block_16: {
                        const operand_13 = (value_15).@"0";

                        const operand_15 = (block_14: {
                            break :block_14 value_16;
                        } + @as(u64, 1));

                        break :block_16 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_13, operand_15, null, });
                    }, });
                };

                break :block_37 value_17;
            };

            state_changed_12 = true;
        }

        break :block_43 (if (state_changed_12) block_42: {
            break :block_42 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_18));

                (operand_40).* = (zx_abi).zx_type_18{ .limit = (state_10).limit, .pair = (if ((((state_10).pair).@"2" != null)) ((state_10).pair).@"2".? else block_39: {
                    const operand_38 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_38).* = @as((zx_abi).zx_type_16, .{ ((state_10).pair).@"0", ((state_10).pair).@"1", });
                    break :block_39 @as(*const (zx_abi).zx_type_16, operand_38);
                }), };

                break :block_41 @as(*const (zx_abi).zx_type_18, operand_40);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (((value_1).pair).@"0").total;
        const operand_2 = (((value_18).pair).@"0").total;
        const operand_3 = (((value_18).pair).@"0").previous;
        const operand_4 = ((value_18).pair).@"1";
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

