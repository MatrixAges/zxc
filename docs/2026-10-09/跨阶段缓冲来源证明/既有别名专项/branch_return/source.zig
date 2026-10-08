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

    const value_1: *const (zx_abi).zx_type_17 = block_54: {
        const operand_37 = block_42: {
            const operand_38 = (in).start;
            const operand_39 = (in).start;

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_40).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_38, .previous = operand_39, });

                break :block_41 @as(*const (zx_abi).zx_type_14, operand_40);
            };
        };
        const operand_43 = block_48: {
            const operand_44 = ((in).start + @as(i64, 100));
            const operand_45 = (in).start;

            break :block_48 block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_46).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_44, .previous = operand_45, });

                break :block_47 @as(*const (zx_abi).zx_type_14, operand_46);
            };
        };

        const operand_49 = @as(u64, 0);
        const operand_50 = (in).count;
        const operand_51 = (in).start;

        break :block_54 block_53: {
            const operand_52 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_52).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_37, .right = operand_43, .index = operand_49, .limit = operand_50, .previous = operand_51, });

            break :block_53 @as(*const (zx_abi).zx_type_17, operand_52);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_36: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_14 = struct {
            index: u64,
            left: state_type_13,
            limit: u64,
            previous: i64,
            right: state_type_13,
        };

        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .left = state_type_13{ .previous = ((operand_11).left).previous, .total = ((operand_11).left).total, }, .limit = (operand_11).limit, .previous = (operand_11).previous, .right = state_type_13{ .previous = ((operand_11).right).previous, .total = ((operand_11).right).total, }, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_28: {
                const value_4: state_type_13 = block_27: {
                    const operand_21 = state_10;
                    const operand_22 = (zx_abi).zx_type_14{ .previous = ((operand_21).left).previous, .total = ((operand_21).left).total, };
                    const operand_23 = (zx_abi).zx_type_14{ .previous = ((operand_21).right).previous, .total = ((operand_21).right).total, };
                    const operand_24 = (zx_abi).zx_type_17{ .index = (operand_21).index, .left = (&operand_22), .limit = (operand_21).limit, .previous = (operand_21).previous, .right = (&operand_23), };

                    const operand_26 = block_25: {
                        break :block_25 (try function_0_value(allocator, (&operand_24)));
                    };

                    break :block_27 state_type_13{ .previous = (operand_26).previous, .total = (operand_26).total, };
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).left;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_14 = block_20: {
                    break :block_20 state_type_14{ .index = (value_5).index, .left = block_19: {
                        break :block_19 state_type_13{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_14 = value_8;
                const value_10: state_type_13 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_14 = block_18: {
                    break :block_18 state_type_14{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_17: {
                        break :block_17 state_type_13{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_14 = value_12;

                const value_14: state_type_14 = block_16: {
                    break :block_16 state_type_14{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };
                const value_15: state_type_14 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_28 value_17;
            };

            state_changed_12 = true;
        }

        break :block_36 (if (state_changed_12) block_35: {
            const operand_34 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_34).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = (state_10).index, .left = block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_30).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).left).previous, .total = ((state_10).left).total, });

                break :block_31 @as(*const (zx_abi).zx_type_14, operand_30);
            }, .limit = (state_10).limit, .previous = (state_10).previous, .right = block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_32).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).right).previous, .total = ((state_10).right).total, });

                break :block_33 @as(*const (zx_abi).zx_type_14, operand_32);
            }, });

            break :block_35 @as(*const (zx_abi).zx_type_17, operand_34);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).left).total;
        const operand_2 = ((value_18).left).total;
        const operand_3 = (value_18).previous;
        const operand_4 = (value_18).index;
        const operand_5 = ((value_18).right).total;
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

