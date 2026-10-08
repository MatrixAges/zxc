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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ OutOfMemory, }!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    return block_5: {
        const operand_1 = (in).leaf;
        const operand_2 = (in).index;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_3).* = @as((zx_abi).zx_type_16, .{ operand_1, operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_16, operand_3);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ OutOfMemory, }!(zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_8: {
        const operand_6 = (in).leaf;
        const operand_7 = (in).index;

        break :block_8 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_6, operand_7, null, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_42: {
        const operand_32 = block_37: {
            const operand_33 = (in).start;
            const operand_34 = (in).start;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_35).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_33, .previous = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_14, operand_35);
            };
        };

        const operand_38 = @as(u64, 0);
        const operand_39 = (in).count;

        break :block_42 block_41: {
            const operand_40 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_40).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_32, .index = operand_38, .limit = operand_39, });

            break :block_41 @as(*const (zx_abi).zx_type_15, operand_40);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_31: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_27: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_26: {
                    break :block_26 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_25: {
                    break :block_25 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_24: {
                    break :block_24 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_23: {
                        break :block_23 block_22: {
                            const operand_21 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_21).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_19: {
                                break :block_19 value_6;
                            }).previous, .total = (block_20: {
                                break :block_20 value_7;
                            } + @as(i64, 1)), });

                            break :block_22 @as(*const (zx_abi).zx_type_14, operand_21);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_17: {
                        break :block_17 block_16: {
                            const operand_15 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_15).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_14: {
                                break :block_14 value_10;
                            }).total, });

                            break :block_16 @as(*const (zx_abi).zx_type_14, operand_15);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_27 value_13;
            };

            state_changed_12 = true;
        }

        break :block_31 (if (state_changed_12) block_30: {
            break :block_30 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_28).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_29 @as(*const (zx_abi).zx_type_15, operand_28);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).leaf).total;
        const operand_2 = ((value_14).leaf).total;
        const operand_3 = ((value_14).leaf).previous;
        const operand_4 = (value_14).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

