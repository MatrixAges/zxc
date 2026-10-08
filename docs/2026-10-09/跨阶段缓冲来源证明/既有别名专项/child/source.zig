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

    const value_15: *const (zx_abi).zx_type_15 = block_32: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_14 = struct {
            index: u64,
            leaf: state_type_13,
            limit: u64,
        };

        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .leaf = state_type_13{ .previous = ((operand_11).leaf).previous, .total = ((operand_11).leaf).total, }, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_26: {
                const value_4: state_type_13 = block_25: {
                    const operand_20 = state_10;
                    const operand_21 = (zx_abi).zx_type_14{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, };
                    const operand_22 = (zx_abi).zx_type_15{ .index = (operand_20).index, .leaf = (&operand_21), .limit = (operand_20).limit, };

                    const operand_24 = block_23: {
                        break :block_23 (try function_0_value(allocator, (&operand_22)));
                    };

                    break :block_25 state_type_13{ .previous = (operand_24).previous, .total = (operand_24).total, };
                };

                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_14 = block_19: {
                    break :block_19 state_type_14{ .index = (value_5).index, .leaf = block_18: {
                        break :block_18 state_type_13{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_14 = value_8;
                const value_10: state_type_13 = (value_9).leaf;

                const value_11: state_type_14 = block_17: {
                    break :block_17 state_type_14{ .index = (value_9).index, .leaf = block_16: {
                        break :block_16 state_type_13{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_14 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_26 value_14;
            };

            state_changed_12 = true;
        }

        break :block_32 (if (state_changed_12) block_31: {
            const operand_30 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_30).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_28).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).leaf).previous, .total = ((state_10).leaf).total, });

                break :block_29 @as(*const (zx_abi).zx_type_14, operand_28);
            }, .limit = (state_10).limit, });

            break :block_31 @as(*const (zx_abi).zx_type_15, operand_30);
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

