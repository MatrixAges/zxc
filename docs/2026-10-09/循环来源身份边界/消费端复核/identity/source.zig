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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ }!(zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_43: {
        const operand_33 = block_38: {
            const operand_34 = (in).start;
            const operand_35 = (in).start;

            break :block_38 block_37: {
                const operand_36 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_36).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_34, .previous = operand_35, });

                break :block_37 @as(*const (zx_abi).zx_type_14, operand_36);
            };
        };

        const operand_39 = @as(u64, 0);
        const operand_40 = (in).count;

        break :block_43 block_42: {
            const operand_41 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_41).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_33, .index = operand_39, .limit = operand_40, });

            break :block_42 @as(*const (zx_abi).zx_type_15, operand_41);
        };
    };

    return block_32: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_4 = struct {
            index: u64,
            leaf: state_type_3,
            limit: u64,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .index = (operand_2).index, .leaf = state_type_3{ .previous = ((operand_2).leaf).previous, .total = ((operand_2).leaf).total, }, .limit = (operand_2).limit, };
        };

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_22: {
                const value_4: state_type_4 = block_21: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_20 = block_19: {
                        const operand_16 = (&operand_15);
                        const operand_17 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_16).index, .leaf = (operand_16).leaf, .limit = (operand_16).limit, .zx_origin = operand_16, }));

                        break :block_19 (if (((operand_17).zx_origin != null)) ((operand_17).zx_origin.?).* else block_18: {
                            break :block_18 (zx_abi).zx_type_15{ .index = (operand_17).index, .leaf = (operand_17).leaf, .limit = (operand_17).limit, };
                        });
                    };

                    break :block_21 state_type_4{ .index = (operand_20).index, .leaf = state_type_3{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, }, .limit = (operand_20).limit, };
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).leaf;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_4 = block_12: {
                    break :block_12 state_type_4{ .index = (value_5).index, .leaf = block_11: {
                        break :block_11 state_type_3{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_4 = value_8;
                const value_10: state_type_3 = (value_9).leaf;

                const value_11: state_type_4 = block_10: {
                    break :block_10 state_type_4{ .index = (value_9).index, .leaf = block_9: {
                        break :block_9 state_type_3{ .previous = ((value_4).leaf).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_22 value_14;
            };

            state_changed_7 = true;
        }

        break :block_32 block_31: {
            const operand_23 = ((value_1).leaf).total;
            const operand_24 = ((state_1).leaf).total;
            const operand_25 = ((state_1).leaf).previous;
            const operand_26 = (state_1).index;
            const operand_27 = @as(i64, 0);
            const operand_28 = (in).values;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_23, .total = operand_24, .previous = operand_25, .steps = operand_26, .other = operand_27, .values = operand_28, });

                break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
            };
        };
    };
}

