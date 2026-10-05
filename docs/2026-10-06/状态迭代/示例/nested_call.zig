const std = @import("std");

const zx_type_12 = struct {
    total: i64,
    values: []const i64,
};

const zx_type_13 = struct {
    batch: *const zx_type_12,
    index: u64,
};

const zx_type_14 = struct {
    increment: i64,
    values: []const i64,
};

const zx_type_15 = struct {
    batch: *const zx_type_12,
    increment: i64,
    index: u64,
};

const zx_type_16 = struct {
    batch: *const zx_type_12,
    original: []const i64,
};

pub const Input = *const zx_type_14;
pub const Batch = *const zx_type_12;
pub const State = *const zx_type_15;
pub const Output = *const zx_type_16;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .batch = zx_shape_12, .index = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .increment = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .batch = zx_shape_12, .increment = zx_shape_7, .index = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .batch = zx_shape_12, .original = zx_shape_11, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_16;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_13) anyerror!i64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (((in).batch).total + block_3: {
        const operand_1 = ((in).batch).values;
        const operand_2 = (in).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    });
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_14) anyerror!*const zx_type_16 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_15 = block_50: {
        const operand_40 = block_45: {
            const operand_41 = (in).values;
            const operand_42 = @as(i64, 0);

            break :block_45 block_44: {
                const operand_43 = (try (allocator).create(zx_type_12));

                (operand_43).* = @as(zx_type_12, zx_type_12{ .values = operand_41, .total = operand_42, });

                break :block_44 @as(*const zx_type_12, operand_43);
            };
        };

        const operand_46 = (in).increment;
        const operand_47 = @as(u64, 0);

        break :block_50 block_49: {
            const operand_48 = (try (allocator).create(zx_type_15));

            (operand_48).* = @as(zx_type_15, zx_type_15{ .batch = operand_40, .increment = operand_46, .index = operand_47, });

            break :block_49 @as(*const zx_type_15, operand_48);
        };
    };

    const value_20: *const zx_type_15 = block_39: {
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
        const state_type_16 = struct {
            batch: state_type_11,
            index: u64,
        };

        var state_6: state_type_12 = state_type_12{ .batch = state_type_11{ .total = ((operand_7).batch).total, .values = ((operand_7).batch).values, }, .increment = (operand_7).increment, .index = (operand_7).index, };
        var state_changed_8 = false;

        while (((state_6).index < @as(u64, (((state_6).batch).values).len))) {
            state_6 = block_34: {
                const value_4: state_type_12 = state_6;
                const value_5: state_type_11 = (value_4).batch;
                const value_6: []const i64 = (value_5).values;
                const value_7: u64 = (state_6).index;
                const value_8: i64 = block_33: {
                    const operand_31 = value_6;
                    const operand_32 = value_7;

                    if ((operand_32 >= (operand_31).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_33 (operand_31)[@intCast(operand_32)];
                };

                const value_9: i64 = (state_6).increment;

                const value_10: state_type_12 = block_30: {
                    break :block_30 state_type_12{ .batch = block_29: {
                        break :block_29 state_type_11{ .total = (value_5).total, .values = block_28: {
                            const operand_25 = value_6;
                            const operand_26 = value_7;
                            const operand_27 = (value_8 + value_9);

                            if ((operand_26 >= (operand_25).len)) {
                                return error.IndexOutOfBounds;
                            }

                            if ((!state_items_started_10)) {
                                state_items_9 = (try (allocator).dupe(i64, operand_25));
                                state_items_started_10 = true;
                            }

                            (state_items_9)[@intCast(operand_26)] = operand_27;

                            break :block_28 state_items_9;
                        }, };
                    }, .increment = (value_4).increment, .index = (value_4).index, };
                };

                const value_11: state_type_12 = value_10;
                const value_12: state_type_11 = (value_11).batch;
                _ = (value_12).total;

                const value_14: i64 = block_24: {
                    const operand_20 = block_19: {
                        const operand_17 = (value_10).batch;
                        const operand_18 = (value_10).index;

                        break :block_19 state_type_16{ .batch = operand_17, .index = operand_18, };
                    };

                    const operand_21 = zx_type_12{ .total = ((operand_20).batch).total, .values = ((operand_20).batch).values, };
                    const operand_22 = zx_type_13{ .batch = (&operand_21), .index = (operand_20).index, };
                    const operand_23 = (try function_0(allocator, (&operand_22)));

                    break :block_24 operand_23;
                };

                const value_15: state_type_12 = block_15: {
                    break :block_15 state_type_12{ .batch = block_14: {
                        break :block_14 state_type_11{ .total = value_14, .values = (value_12).values, };
                    }, .increment = (value_11).increment, .index = (value_11).index, };
                };
                const value_16: state_type_12 = value_15;
                const value_17: u64 = (value_16).index;
                const value_18: u64 = @as(u64, 1);

                const value_19: state_type_12 = block_13: {
                    break :block_13 state_type_12{ .batch = (value_16).batch, .increment = (value_16).increment, .index = (value_17 + value_18), };
                };

                break :block_34 value_19;
            };

            state_changed_8 = true;
        }

        break :block_39 (if (state_changed_8) block_38: {
            const operand_37 = (try (allocator).create(zx_type_15));

            (operand_37).* = @as(zx_type_15, zx_type_15{ .batch = block_36: {
                const operand_35 = (try (allocator).create(zx_type_12));

                (operand_35).* = @as(zx_type_12, zx_type_12{ .total = ((state_6).batch).total, .values = ((state_6).batch).values, });

                break :block_36 @as(*const zx_type_12, operand_35);
            }, .increment = (state_6).increment, .index = (state_6).index, });

            break :block_38 @as(*const zx_type_15, operand_37);
        } else operand_7);
    };

    return block_5: {
        const operand_1 = (in).values;
        const operand_2 = (value_20).batch;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_16));
            (operand_3).* = @as(zx_type_16, zx_type_16{ .original = operand_1, .batch = operand_2, });

            break :block_4 @as(*const zx_type_16, operand_3);
        };
    };
}
