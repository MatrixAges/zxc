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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((@rem((in).index, @as(u64, 2)) == @as(u64, 0))) (in).left else (in).right);
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((@rem((in).index, @as(u64, 2)) == @as(u64, 0))) ((in).left).* else ((in).right).*);
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_17 = block_49: {
        const operand_32 = block_37: {
            const operand_33 = (in).start;
            const operand_34 = (in).start;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_35).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_33, .previous = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_14, operand_35);
            };
        };
        const operand_38 = block_43: {
            const operand_39 = ((in).start + @as(i64, 100));
            const operand_40 = (in).start;

            break :block_43 block_42: {
                const operand_41 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_41).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_39, .previous = operand_40, });

                break :block_42 @as(*const (zx_abi).zx_type_14, operand_41);
            };
        };

        const operand_44 = @as(u64, 0);
        const operand_45 = (in).count;
        const operand_46 = (in).start;

        break :block_49 block_48: {
            const operand_47 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_47).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_32, .right = operand_38, .index = operand_44, .limit = operand_45, .previous = operand_46, });

            break :block_48 @as(*const (zx_abi).zx_type_17, operand_47);
        };
    };

    return block_31: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_4 = struct {
            index: u64,
            left: state_type_3,
            limit: u64,
            previous: i64,
            right: state_type_3,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .index = (operand_2).index, .left = state_type_3{ .previous = ((operand_2).left).previous, .total = ((operand_2).left).total, }, .limit = (operand_2).limit, .previous = (operand_2).previous, .right = state_type_3{ .previous = ((operand_2).right).previous, .total = ((operand_2).right).total, }, };
        };

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_21: {
                const value_4: state_type_3 = block_20: {
                    const operand_14 = state_1;
                    const operand_15 = (zx_abi).zx_type_14{ .previous = ((operand_14).left).previous, .total = ((operand_14).left).total, };
                    const operand_16 = (zx_abi).zx_type_14{ .previous = ((operand_14).right).previous, .total = ((operand_14).right).total, };
                    const operand_17 = (zx_abi).zx_type_17{ .index = (operand_14).index, .left = (&operand_15), .limit = (operand_14).limit, .previous = (operand_14).previous, .right = (&operand_16), };

                    const operand_19 = block_18: {
                        break :block_18 (try function_0_value(allocator, (&operand_17)));
                    };

                    break :block_20 state_type_3{ .previous = (operand_19).previous, .total = (operand_19).total, };
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).left;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_4 = block_13: {
                    break :block_13 state_type_4{ .index = (value_5).index, .left = block_12: {
                        break :block_12 state_type_3{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_4 = value_8;
                const value_10: state_type_3 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_4 = block_11: {
                    break :block_11 state_type_4{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_10: {
                        break :block_10 state_type_3{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_4 = value_12;

                const value_14: state_type_4 = block_9: {
                    break :block_9 state_type_4{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };
                const value_15: state_type_4 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_21 value_17;
            };

            state_changed_7 = true;
        }

        break :block_31 block_30: {
            const operand_22 = ((value_1).left).total;
            const operand_23 = ((state_1).left).total;
            const operand_24 = (state_1).previous;
            const operand_25 = (state_1).index;
            const operand_26 = ((state_1).right).total;
            const operand_27 = (in).values;

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_28).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_22, .total = operand_23, .previous = operand_24, .steps = operand_25, .other = operand_26, .values = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_13, operand_28);
            };
        };
    };
}

