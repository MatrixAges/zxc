const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    count: u64,
    index: u64,
    left: []const i64,
    right: []const i64,
};

const zx_type_14 = struct {
    original: []const i64,
    seen: i64,
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enabled = zx_shape_1, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .index = zx_shape_5, .left = zx_shape_11, .right = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_44: {
        const operand_38 = (in).values;
        const operand_39 = (in).values;
        const operand_40 = (in).count;
        const operand_41 = @as(u64, 0);

        break :block_44 block_43: {
            const operand_42 = (try (allocator).create(zx_type_13));
            (operand_42).* = @as(zx_type_13, zx_type_13{ .left = operand_38, .right = operand_39, .count = operand_40, .index = operand_41, });

            break :block_43 @as(*const zx_type_13, operand_42);
        };
    };

    const value_20: *const zx_type_13 = block_37: {
        const operand_11 = value_1;
        var state_items_13: []i64 = undefined;
        var state_items_started_14 = false;
        var state_items_15: []i64 = undefined;
        var state_items_started_16 = false;
        var state_10: zx_type_13 = (operand_11).*;
        var state_changed_12 = false;

        while ((((&state_10)).index < ((&state_10)).count)) {
            state_10 = block_34: {
                const value_4: zx_type_13 = ((&state_10)).*;
                const value_5: []const i64 = ((&value_4)).left;
                const value_6: u64 = @as(u64, 0);
                const value_7: i64 = block_33: {
                    const operand_31 = value_5;
                    const operand_32 = value_6;

                    if ((operand_32 >= (operand_31).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_33 (operand_31)[@intCast(operand_32)];
                };
                const value_8: i64 = @as(i64, 1);

                const value_9: zx_type_13 = block_30: {
                    break :block_30 zx_type_13{ .count = ((&value_4)).count, .index = ((&value_4)).index, .left = block_29: {
                        const operand_26 = value_5;
                        const operand_27 = value_6;
                        const operand_28 = (value_7 + value_8);

                        if ((operand_27 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        if ((!state_items_started_14)) {
                            state_items_13 = (try (allocator).dupe(i64, operand_26));
                            state_items_started_14 = true;
                        }

                        (state_items_13)[@intCast(operand_27)] = operand_28;

                        break :block_29 state_items_13;
                    }, .right = ((&value_4)).right, };
                };

                const value_10: zx_type_13 = ((&value_9)).*;
                const value_11: []const i64 = ((&value_10)).right;
                const value_12: u64 = @as(u64, 1);
                const value_13: i64 = block_25: {
                    const operand_23 = value_11;
                    const operand_24 = value_12;

                    if ((operand_24 >= (operand_23).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_25 (operand_23)[@intCast(operand_24)];
                };

                const value_14: i64 = @as(i64, 2);

                const value_15: zx_type_13 = block_22: {
                    break :block_22 zx_type_13{ .count = ((&value_10)).count, .index = ((&value_10)).index, .left = ((&value_10)).left, .right = block_21: {
                        const operand_18 = value_11;
                        const operand_19 = value_12;
                        const operand_20 = (value_13 + value_14);

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        if ((!state_items_started_16)) {
                            state_items_15 = (try (allocator).dupe(i64, operand_18));
                            state_items_started_16 = true;
                        }

                        (state_items_15)[@intCast(operand_19)] = operand_20;

                        break :block_21 state_items_15;
                    }, };
                };

                const value_16: zx_type_13 = ((&value_15)).*;
                const value_17: u64 = ((&value_16)).index;
                const value_18: u64 = @as(u64, 1);

                const value_19: zx_type_13 = block_17: {
                    break :block_17 zx_type_13{ .count = ((&value_16)).count, .index = (value_17 + value_18), .left = ((&value_16)).left, .right = ((&value_16)).right, };
                };

                break :block_34 ((&value_19)).*;
            };

            state_changed_12 = true;
        }

        break :block_37 (if (state_changed_12) block_36: {
            const operand_35 = (try (allocator).create(zx_type_13));

            (operand_35).* = @as(zx_type_13, state_10);

            break :block_36 @as(*const zx_type_13, operand_35);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (in).values;
        const operand_2 = (value_20).left;

        const operand_3 = block_6: {
            const operand_4 = (value_20).right;
            const operand_5 = @as(u64, 1);

            if ((operand_5 >= (operand_4).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_6 (operand_4)[@intCast(operand_5)];
        };

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create(zx_type_14));

            (operand_7).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_8 @as(*const zx_type_14, operand_7);
        };
    };
}

