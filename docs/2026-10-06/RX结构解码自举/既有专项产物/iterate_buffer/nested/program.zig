const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    values: []const i64,
};

const zx_type_14 = struct {
    box: *const zx_type_13,
    count: u64,
    index: u64,
};

const zx_type_15 = struct {
    original: []const i64,
    seen: i64,
    values: []const i64,
};

pub const Input = *const zx_type_12;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enabled = zx_shape_1, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .box = zx_shape_13, .count = zx_shape_5, .index = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_15;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_15 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_14 = block_39: {
        const operand_30 = block_34: {
            const operand_31 = (in).values;

            break :block_34 block_33: {
                const operand_32 = (try (allocator).create(zx_type_13));

                (operand_32).* = @as(zx_type_13, zx_type_13{ .values = operand_31, });

                break :block_33 @as(*const zx_type_13, operand_32);
            };
        };

        const operand_35 = (in).count;
        const operand_36 = @as(u64, 0);

        break :block_39 block_38: {
            const operand_37 = (try (allocator).create(zx_type_14));

            (operand_37).* = @as(zx_type_14, zx_type_14{ .box = operand_30, .count = operand_35, .index = operand_36, });

            break :block_38 @as(*const zx_type_14, operand_37);
        };
    };

    const value_15: *const zx_type_14 = block_29: {
        const operand_8 = value_1;
        var state_items_10: []i64 = undefined;
        var state_items_started_11 = false;

        const state_type_12 = struct {
            values: []const i64,
        };
        const state_type_13 = struct {
            box: state_type_12,
            count: u64,
            index: u64,
        };

        var state_7: state_type_13 = state_type_13{ .box = state_type_12{ .values = ((operand_8).box).values, }, .count = (operand_8).count, .index = (operand_8).index, };
        var state_changed_9 = false;

        while (((state_7).index < (state_7).count)) {
            state_7 = block_24: {
                const value_4: state_type_13 = state_7;
                const value_5: state_type_12 = (value_4).box;
                const value_6: []const i64 = (value_5).values;
                const value_7: u64 = @as(u64, 0);
                const value_8: i64 = block_23: {
                    const operand_21 = value_6;
                    const operand_22 = value_7;

                    if ((operand_22 >= (operand_21).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_23 (operand_21)[@intCast(operand_22)];
                };

                const value_9: i64 = @as(i64, 1);

                const value_10: state_type_13 = block_20: {
                    break :block_20 state_type_13{ .box = block_19: {
                        break :block_19 state_type_12{ .values = block_18: {
                            const operand_15 = value_6;
                            const operand_16 = value_7;
                            const operand_17 = (value_8 + value_9);

                            if ((operand_16 >= (operand_15).len)) {
                                return error.IndexOutOfBounds;
                            }

                            if ((!state_items_started_11)) {
                                state_items_10 = (try (allocator).dupe(i64, operand_15));
                                state_items_started_11 = true;
                            }

                            (state_items_10)[@intCast(operand_16)] = operand_17;

                            break :block_18 state_items_10;
                        }, };
                    }, .count = (value_4).count, .index = (value_4).index, };
                };
                const value_11: state_type_13 = value_10;
                const value_12: u64 = (value_11).index;
                const value_13: u64 = @as(u64, 1);

                const value_14: state_type_13 = block_14: {
                    break :block_14 state_type_13{ .box = (value_11).box, .count = (value_11).count, .index = (value_12 + value_13), };
                };

                break :block_24 value_14;
            };

            state_changed_9 = true;
        }

        break :block_29 (if (state_changed_9) block_28: {
            const operand_27 = (try (allocator).create(zx_type_14));

            (operand_27).* = @as(zx_type_14, zx_type_14{ .box = block_26: {
                const operand_25 = (try (allocator).create(zx_type_13));

                (operand_25).* = @as(zx_type_13, zx_type_13{ .values = ((state_7).box).values, });

                break :block_26 @as(*const zx_type_13, operand_25);
            }, .count = (state_7).count, .index = (state_7).index, });

            break :block_28 @as(*const zx_type_14, operand_27);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = ((value_15).box).values;
        const operand_3 = @as(i64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_15));

            (operand_4).* = @as(zx_type_15, zx_type_15{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_15, operand_4);
        };
    };
}

