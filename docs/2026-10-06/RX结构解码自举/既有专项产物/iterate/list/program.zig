const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    delta: i64,
    values: []const i64,
};

const zx_type_13 = struct {
    count: u64,
    delta: i64,
    index: u64,
    previous: i64,
    total: i64,
    values: []const i64,
};

const zx_type_14 = struct {
    original: []const i64,
    previous: i64,
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .delta = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .delta = zx_shape_7, .index = zx_shape_5, .previous = zx_shape_7, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .previous = zx_shape_7, .total = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_42: {
        const operand_34 = (in).values;
        const operand_35 = (in).delta;
        const operand_36 = (in).count;
        const operand_37 = @as(u64, 0);
        const operand_38 = @as(i64, 0);
        const operand_39 = @as(i64, 0);

        break :block_42 block_41: {
            const operand_40 = (try (allocator).create(zx_type_13));

            (operand_40).* = @as(zx_type_13, zx_type_13{ .values = operand_34, .delta = operand_35, .count = operand_36, .index = operand_37, .total = operand_38, .previous = operand_39, });

            break :block_41 @as(*const zx_type_13, operand_40);
        };
    };

    const value_23: *const zx_type_13 = block_33: {
        const operand_9 = value_1;
        var state_items_11: []i64 = undefined;
        var state_items_started_12 = false;
        var state_8: zx_type_13 = (operand_9).*;
        var state_changed_10 = false;

        while ((((&state_8)).index < ((&state_8)).count)) {
            state_8 = block_30: {
                const value_4: i64 = block_29: {
                    const operand_27 = ((&state_8)).values;
                    const operand_28 = ((&state_8)).index;

                    if ((operand_28 >= (operand_27).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_29 (operand_27)[@intCast(operand_28)];
                };

                const value_5: zx_type_13 = ((&state_8)).*;
                const value_6: []const i64 = ((&value_5)).values;
                const value_7: u64 = ((&state_8)).index;

                const value_8: i64 = block_26: {
                    const operand_24 = value_6;
                    const operand_25 = value_7;

                    if ((operand_25 >= (operand_24).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_26 (operand_24)[@intCast(operand_25)];
                };

                const value_9: i64 = ((&state_8)).delta;

                const value_10: zx_type_13 = block_23: {
                    break :block_23 zx_type_13{ .count = ((&value_5)).count, .delta = ((&value_5)).delta, .index = ((&value_5)).index, .previous = ((&value_5)).previous, .total = ((&value_5)).total, .values = block_22: {
                        const operand_19 = value_6;
                        const operand_20 = value_7;
                        const operand_21 = (value_8 + value_9);

                        if ((operand_20 >= (operand_19).len)) {
                            return error.IndexOutOfBounds;
                        }

                        if ((!state_items_started_12)) {
                            state_items_11 = (try (allocator).dupe(i64, operand_19));
                            state_items_started_12 = true;
                        }

                        (state_items_11)[@intCast(operand_20)] = operand_21;

                        break :block_22 state_items_11;
                    }, };
                };

                const value_11: zx_type_13 = ((&value_10)).*;

                _ = ((&value_11)).previous;
                const value_13: i64 = value_4;
                const value_14: zx_type_13 = block_18: {
                    break :block_18 zx_type_13{ .count = ((&value_11)).count, .delta = ((&value_11)).delta, .index = ((&value_11)).index, .previous = value_13, .total = ((&value_11)).total, .values = ((&value_11)).values, };
                };

                const value_15: zx_type_13 = ((&value_14)).*;
                const value_16: i64 = ((&value_15)).total;

                const value_17: i64 = block_17: {
                    const operand_15 = ((&value_14)).values;
                    const operand_16 = ((&value_14)).index;

                    if ((operand_16 >= (operand_15).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_17 (operand_15)[@intCast(operand_16)];
                };
                const value_18: zx_type_13 = block_14: {
                    break :block_14 zx_type_13{ .count = ((&value_15)).count, .delta = ((&value_15)).delta, .index = ((&value_15)).index, .previous = ((&value_15)).previous, .total = (value_16 + value_17), .values = ((&value_15)).values, };
                };

                const value_19: zx_type_13 = ((&value_18)).*;
                const value_20: u64 = ((&value_19)).index;
                const value_21: u64 = @as(u64, 1);

                const value_22: zx_type_13 = block_13: {
                    break :block_13 zx_type_13{ .count = ((&value_19)).count, .delta = ((&value_19)).delta, .index = (value_20 + value_21), .previous = ((&value_19)).previous, .total = ((&value_19)).total, .values = ((&value_19)).values, };
                };

                break :block_30 ((&value_22)).*;
            };

            state_changed_10 = true;
        }

        break :block_33 (if (state_changed_10) block_32: {
            const operand_31 = (try (allocator).create(zx_type_13));

            (operand_31).* = @as(zx_type_13, state_8);

            break :block_32 @as(*const zx_type_13, operand_31);
        } else operand_9);
    };

    return block_7: {
        const operand_1 = (value_1).values;
        const operand_2 = (value_23).values;
        const operand_3 = (value_23).total;
        const operand_4 = (value_23).previous;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create(zx_type_14));

            (operand_5).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .total = operand_3, .previous = operand_4, });

            break :block_6 @as(*const zx_type_14, operand_5);
        };
    };
}

