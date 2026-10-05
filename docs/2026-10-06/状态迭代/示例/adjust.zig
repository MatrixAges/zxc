const std = @import("std");

const zx_type_12 = struct {
    increment: i64,
    values: []const i64,
};

const zx_type_13 = struct {
    increment: i64,
    index: u64,
    total: i64,
    values: []const i64,
};

const zx_type_14 = struct {
    original: []const i64,
    total: i64,
    values: []const i64,
};

pub const Input = *const zx_type_12;
pub const State = *const zx_type_13;
pub const Output = *const zx_type_14;
pub const consumes_input = false;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .increment = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .increment = zx_shape_7, .index = zx_shape_5, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .total = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) anyerror!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_35: {
        const operand_29 = (in).values;
        const operand_30 = (in).increment;
        const operand_31 = @as(u64, 0);
        const operand_32 = @as(i64, 0);

        break :block_35 block_34: {
            const operand_33 = (try (allocator).create(zx_type_13));

            (operand_33).* = @as(zx_type_13, zx_type_13{ .values = operand_29, .increment = operand_30, .index = operand_31, .total = operand_32, });

            break :block_34 @as(*const zx_type_13, operand_33);
        };
    };

    const value_18: *const zx_type_13 = block_28: {
        const operand_8 = value_1;
        var state_items_10: []i64 = undefined;
        var state_items_started_11 = false;
        var state_7: zx_type_13 = (operand_8).*;
        var state_changed_9 = false;

        while ((((&state_7)).index < @as(u64, (((&state_7)).values).len))) {
            state_7 = block_25: {
                const value_4: zx_type_13 = ((&state_7)).*;
                const value_5: []const i64 = ((&value_4)).values;
                const value_6: u64 = ((&state_7)).index;

                const value_7: i64 = block_24: {
                    const operand_22 = value_5;
                    const operand_23 = value_6;

                    if ((operand_23 >= (operand_22).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_24 (operand_22)[@intCast(operand_23)];
                };

                const value_8: i64 = ((&state_7)).increment;

                const value_9: zx_type_13 = block_21: {
                    break :block_21 zx_type_13{ .increment = ((&value_4)).increment, .index = ((&value_4)).index, .total = ((&value_4)).total, .values = block_20: {
                        const operand_17 = value_5;
                        const operand_18 = value_6;
                        const operand_19 = (value_7 + value_8);

                        if ((operand_18 >= (operand_17).len)) {
                            return error.IndexOutOfBounds;
                        }

                        if ((!state_items_started_11)) {
                            state_items_10 = (try (allocator).dupe(i64, operand_17));
                            state_items_started_11 = true;
                        }

                        (state_items_10)[@intCast(operand_18)] = operand_19;

                        break :block_20 state_items_10;
                    }, };
                };

                const value_10: zx_type_13 = ((&value_9)).*;
                const value_11: i64 = ((&value_10)).total;

                const value_12: i64 = block_16: {
                    const operand_14 = ((&value_9)).values;
                    const operand_15 = ((&value_9)).index;

                    if ((operand_15 >= (operand_14).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_16 (operand_14)[@intCast(operand_15)];
                };
                const value_13: zx_type_13 = block_13: {
                    break :block_13 zx_type_13{ .increment = ((&value_10)).increment, .index = ((&value_10)).index, .total = (value_11 + value_12), .values = ((&value_10)).values, };
                };

                const value_14: zx_type_13 = ((&value_13)).*;
                const value_15: u64 = ((&value_14)).index;
                const value_16: u64 = @as(u64, 1);
                const value_17: zx_type_13 = block_12: {
                    break :block_12 zx_type_13{ .increment = ((&value_14)).increment, .index = (value_15 + value_16), .total = ((&value_14)).total, .values = ((&value_14)).values, };
                };

                break :block_25 ((&value_17)).*;
            };

            state_changed_9 = true;
        }

        break :block_28 (if (state_changed_9) block_27: {
            const operand_26 = (try (allocator).create(zx_type_13));

            (operand_26).* = @as(zx_type_13, state_7);

            break :block_27 @as(*const zx_type_13, operand_26);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (value_1).values;
        const operand_2 = (value_18).values;
        const operand_3 = (value_18).total;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .total = operand_3, });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}
