const std = @import("std");

const zx_type_12 = struct {
    increment: i64,
    values: []const i64,
};

const zx_type_13 = struct {
    total: i64,
    values: []const i64,
};

const zx_type_14 = struct {
    batch: *const zx_type_13,
    increment: i64,
    index: u64,
};

const zx_type_15 = struct {
    batch: *const zx_type_13,
    original: []const i64,
};

pub const Input = *const zx_type_12;
pub const Batch = *const zx_type_13;
pub const State = *const zx_type_14;
pub const Output = *const zx_type_15;
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .batch = zx_shape_13, .increment = zx_shape_7, .index = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .batch = zx_shape_13, .original = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_15;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) anyerror!*const zx_type_15 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_14 = block_44: {
        const operand_34 = block_39: {
            const operand_35 = (in).values;
            const operand_36 = @as(i64, 0);

            break :block_39 block_38: {
                const operand_37 = (try (allocator).create(zx_type_13));

                (operand_37).* = @as(zx_type_13, zx_type_13{ .values = operand_35, .total = operand_36, });

                break :block_38 @as(*const zx_type_13, operand_37);
            };
        };

        const operand_40 = (in).increment;
        const operand_41 = @as(u64, 0);

        break :block_44 block_43: {
            const operand_42 = (try (allocator).create(zx_type_14));

            (operand_42).* = @as(zx_type_14, zx_type_14{ .batch = operand_34, .increment = operand_40, .index = operand_41, });

            break :block_43 @as(*const zx_type_14, operand_42);
        };
    };

    const value_20: *const zx_type_14 = block_33: {
        const operand_7 = value_1;
        var state_items_9: []i64 = undefined;
        var state_items_started_10 = false;

        const state_type_11 = struct {
            total: i64,
            values: []const i64,
        };
        const state_type_12 = struct {
            batch: state_type_11,
            increment: i64,
            index: u64,
        };

        var state_6: state_type_12 = state_type_12{ .batch = state_type_11{ .total = ((operand_7).batch).total, .values = ((operand_7).batch).values, }, .increment = (operand_7).increment, .index = (operand_7).index, };
        var state_changed_8 = false;

        while (((state_6).index < @as(u64, (((state_6).batch).values).len))) {
            state_6 = block_28: {
                const value_4: state_type_12 = state_6;
                const value_5: state_type_11 = (value_4).batch;
                const value_6: []const i64 = (value_5).values;
                const value_7: u64 = (state_6).index;
                const value_8: i64 = block_27: {
                    const operand_25 = value_6;
                    const operand_26 = value_7;

                    if ((operand_26 >= (operand_25).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_27 (operand_25)[@intCast(operand_26)];
                };

                const value_9: i64 = (state_6).increment;

                const value_10: state_type_12 = block_24: {
                    break :block_24 state_type_12{ .batch = block_23: {
                        break :block_23 state_type_11{ .total = (value_5).total, .values = block_22: {
                            const operand_19 = value_6;
                            const operand_20 = value_7;
                            const operand_21 = (value_8 + value_9);

                            if ((operand_20 >= (operand_19).len)) {
                                return error.IndexOutOfBounds;
                            }

                            if ((!state_items_started_10)) {
                                state_items_9 = (try (allocator).dupe(i64, operand_19));
                                state_items_started_10 = true;
                            }

                            (state_items_9)[@intCast(operand_20)] = operand_21;

                            break :block_22 state_items_9;
                        }, };
                    }, .increment = (value_4).increment, .index = (value_4).index, };
                };

                const value_11: state_type_12 = value_10;
                const value_12: state_type_11 = (value_11).batch;
                const value_13: i64 = (value_12).total;

                const value_14: i64 = block_18: {
                    const operand_16 = ((value_10).batch).values;
                    const operand_17 = (value_10).index;

                    if ((operand_17 >= (operand_16).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_18 (operand_16)[@intCast(operand_17)];
                };

                const value_15: state_type_12 = block_15: {
                    break :block_15 state_type_12{ .batch = block_14: {
                        break :block_14 state_type_11{ .total = (value_13 + value_14), .values = (value_12).values, };
                    }, .increment = (value_11).increment, .index = (value_11).index, };
                };
                const value_16: state_type_12 = value_15;
                const value_17: u64 = (value_16).index;
                const value_18: u64 = @as(u64, 1);

                const value_19: state_type_12 = block_13: {
                    break :block_13 state_type_12{ .batch = (value_16).batch, .increment = (value_16).increment, .index = (value_17 + value_18), };
                };

                break :block_28 value_19;
            };

            state_changed_8 = true;
        }

        break :block_33 (if (state_changed_8) block_32: {
            const operand_31 = (try (allocator).create(zx_type_14));

            (operand_31).* = @as(zx_type_14, zx_type_14{ .batch = block_30: {
                const operand_29 = (try (allocator).create(zx_type_13));

                (operand_29).* = @as(zx_type_13, zx_type_13{ .total = ((state_6).batch).total, .values = ((state_6).batch).values, });

                break :block_30 @as(*const zx_type_13, operand_29);
            }, .increment = (state_6).increment, .index = (state_6).index, });

            break :block_32 @as(*const zx_type_14, operand_31);
        } else operand_7);
    };

    return block_5: {
        const operand_1 = (in).values;
        const operand_2 = (value_20).batch;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_15));
            (operand_3).* = @as(zx_type_15, zx_type_15{ .original = operand_1, .batch = operand_2, });

            break :block_4 @as(*const zx_type_15, operand_3);
        };
    };
}
