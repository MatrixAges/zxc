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

    const value_1: *const (zx_abi).zx_type_15 = block_40: {
        const operand_30 = block_35: {
            const operand_31 = (in).start;
            const operand_32 = (in).start;

            break :block_35 block_34: {
                const operand_33 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_33).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_31, .previous = operand_32, });

                break :block_34 @as(*const (zx_abi).zx_type_14, operand_33);
            };
        };

        const operand_36 = @as(u64, 0);
        const operand_37 = (in).count;

        break :block_40 block_39: {
            const operand_38 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_38).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_30, .index = operand_36, .limit = operand_37, });

            break :block_39 @as(*const (zx_abi).zx_type_15, operand_38);
        };
    };

    return block_29: {
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
            state_1 = block_19: {
                const value_4: state_type_3 = block_18: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_17 = block_16: {
                        break :block_16 (try function_0_value(allocator, (&operand_15)));
                    };

                    break :block_18 state_type_3{ .previous = (operand_17).previous, .total = (operand_17).total, };
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
                        break :block_9 state_type_3{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_19 value_14;
            };

            state_changed_7 = true;
        }

        break :block_29 block_28: {
            const operand_20 = ((value_1).leaf).total;
            const operand_21 = ((state_1).leaf).total;
            const operand_22 = ((state_1).leaf).previous;
            const operand_23 = (state_1).index;
            const operand_24 = @as(i64, 0);
            const operand_25 = (in).values;

            break :block_28 block_27: {
                const operand_26 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_26).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_20, .total = operand_21, .previous = operand_22, .steps = operand_23, .other = operand_24, .values = operand_25, });

                break :block_27 @as(*const (zx_abi).zx_type_13, operand_26);
            };
        };
    };
}

