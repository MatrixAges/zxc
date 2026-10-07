const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    count: u64,
    enabled: bool,
    index: u64,
    values: []const i64,
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enabled = zx_shape_1, .index = zx_shape_5, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_32: {
        const operand_26 = (in).values;
        const operand_27 = (in).count;
        const operand_28 = @as(u64, 0);
        const operand_29 = (in).enabled;

        break :block_32 block_31: {
            const operand_30 = (try (allocator).create(zx_type_13));

            (operand_30).* = @as(zx_type_13, zx_type_13{ .values = operand_26, .count = operand_27, .index = operand_28, .enabled = operand_29, });

            break :block_31 @as(*const zx_type_13, operand_30);
        };
    };

    const value_15: *const zx_type_13 = block_25: {
        const operand_8 = value_1;
        var state_items_10: []i64 = undefined;
        var state_items_started_11 = false;
        var state_7: zx_type_13 = (operand_8).*;
        var state_changed_9 = false;

        while ((((&state_7)).index < ((&state_7)).count)) {
            state_7 = block_22: {
                const value_10: zx_type_13 = (if ((((&state_7)).enabled and (((&state_7)).index >= @as(u64, 3)))) block_21: {
                    const value_4: zx_type_13 = ((&state_7)).*;
                    const value_5: []const i64 = ((&value_4)).values;
                    const value_6: u64 = @as(u64, 0);
                    const value_7: i64 = block_20: {
                        const operand_18 = value_5;
                        const operand_19 = value_6;

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };
                    const value_8: i64 = @as(i64, 1);

                    const value_9: zx_type_13 = block_17: {
                        break :block_17 zx_type_13{ .count = ((&value_4)).count, .enabled = ((&value_4)).enabled, .index = ((&value_4)).index, .values = block_16: {
                            const operand_13 = value_5;
                            const operand_14 = value_6;
                            const operand_15 = (value_7 + value_8);

                            if ((operand_14 >= (operand_13).len)) {
                                return error.IndexOutOfBounds;
                            }

                            if ((!state_items_started_11)) {
                                state_items_10 = (try (allocator).dupe(i64, operand_13));
                                state_items_started_11 = true;
                            }

                            (state_items_10)[@intCast(operand_14)] = operand_15;

                            break :block_16 state_items_10;
                        }, };
                    };

                    break :block_21 ((&value_9)).*;
                } else ((&state_7)).*);

                const value_11: zx_type_13 = ((&value_10)).*;
                const value_12: u64 = ((&value_11)).index;
                const value_13: u64 = @as(u64, 1);
                const value_14: zx_type_13 = block_12: {
                    break :block_12 zx_type_13{ .count = ((&value_11)).count, .enabled = ((&value_11)).enabled, .index = (value_12 + value_13), .values = ((&value_11)).values, };
                };

                break :block_22 ((&value_14)).*;
            };

            state_changed_9 = true;
        }

        break :block_25 (if (state_changed_9) block_24: {
            const operand_23 = (try (allocator).create(zx_type_13));

            (operand_23).* = @as(zx_type_13, state_7);

            break :block_24 @as(*const zx_type_13, operand_23);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = (value_15).values;
        const operand_3 = @as(i64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}

