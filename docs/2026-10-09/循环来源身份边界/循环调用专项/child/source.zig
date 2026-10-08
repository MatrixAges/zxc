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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in).leaf;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return ((in).leaf).*;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_46: {
        const operand_36 = block_41: {
            const operand_37 = (in).start;
            const operand_38 = (in).start;

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_39).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_37, .previous = operand_38, });

                break :block_40 @as(*const (zx_abi).zx_type_14, operand_39);
            };
        };

        const operand_42 = @as(u64, 0);
        const operand_43 = (in).count;

        break :block_46 block_45: {
            const operand_44 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_44).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_36, .index = operand_42, .limit = operand_43, });

            break :block_45 @as(*const (zx_abi).zx_type_15, operand_44);
        };
    };

    const value_15: *const (zx_abi).zx_type_15 = block_35: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_31: {
                const value_4: *const (zx_abi).zx_type_14 = block_30: {
                    const operand_28 = state_10;
                    var state_borrow_29: (zx_abi).zx_type_15 = undefined;

                    state_borrow_29 = (zx_abi).zx_type_15{ .index = (operand_28).index, .leaf = (operand_28).leaf, .limit = (operand_28).limit, };

                    break :block_30 (try function_0(allocator, ((operand_28).zx_origin orelse (&state_borrow_29))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_27: {
                    break :block_27 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_26: {
                    break :block_26 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_25: {
                        break :block_25 block_24: {
                            const operand_23 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_23).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_21: {
                                break :block_21 value_6;
                            }).previous, .total = (block_22: {
                                break :block_22 value_7;
                            } + @as(i64, 1)), });

                            break :block_24 @as(*const (zx_abi).zx_type_14, operand_23);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_19: {
                        break :block_19 block_18: {
                            const operand_17 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_17).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_15: {
                                break :block_15 value_4;
                            }).total, .total = (block_16: {
                                break :block_16 value_10;
                            }).total, });

                            break :block_18 @as(*const (zx_abi).zx_type_14, operand_17);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_13: {
                        break :block_13 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_31 value_14;
            };

            state_changed_12 = true;
        }

        break :block_35 (if (state_changed_12) block_34: {
            break :block_34 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_32).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_33 @as(*const (zx_abi).zx_type_15, operand_32);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).leaf).total;
        const operand_2 = ((value_15).leaf).total;
        const operand_3 = ((value_15).leaf).previous;
        const operand_4 = (value_15).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

