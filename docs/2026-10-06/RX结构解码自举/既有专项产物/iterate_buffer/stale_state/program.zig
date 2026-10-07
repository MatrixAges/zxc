const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    count: u64,
    history: []const i64,
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .history = zx_shape_11, .index = zx_shape_5, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_34: {
        const operand_28 = (in).values;
        const operand_29 = (in).values;
        const operand_30 = (in).count;
        const operand_31 = @as(u64, 0);

        break :block_34 block_33: {
            const operand_32 = (try (allocator).create(zx_type_13));

            (operand_32).* = @as(zx_type_13, zx_type_13{ .values = operand_28, .history = operand_29, .count = operand_30, .index = operand_31, });

            break :block_33 @as(*const zx_type_13, operand_32);
        };
    };

    const value_18: *const zx_type_13 = block_27: {
        const operand_11 = value_1;
        var state_10: zx_type_13 = (operand_11).*;
        var state_changed_12 = false;

        while ((((&state_10)).index < ((&state_10)).count)) {
            state_10 = block_24: {
                const value_4: zx_type_13 = ((&state_10)).*;

                _ = ((&value_4)).history;

                const value_6: []const i64 = ((&state_10)).values;

                const value_7: zx_type_13 = block_23: {
                    break :block_23 zx_type_13{ .count = ((&value_4)).count, .history = value_6, .index = ((&value_4)).index, .values = ((&value_4)).values, };
                };

                const value_8: zx_type_13 = ((&value_7)).*;
                const value_9: []const i64 = ((&value_8)).values;
                const value_10: u64 = @as(u64, 0);
                const value_11: i64 = block_22: {
                    const operand_20 = value_9;
                    const operand_21 = value_10;

                    if ((operand_21 >= (operand_20).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_22 (operand_20)[@intCast(operand_21)];
                };

                const value_12: i64 = @as(i64, 1);

                const value_13: zx_type_13 = block_19: {
                    break :block_19 zx_type_13{ .count = ((&value_8)).count, .history = ((&value_8)).history, .index = ((&value_8)).index, .values = block_18: {
                        const operand_14 = value_9;
                        const operand_15 = value_10;
                        const operand_16 = (value_11 + value_12);

                        if ((operand_15 >= (operand_14).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_17 = (try (allocator).dupe(i64, operand_14));

                        (operand_17)[@intCast(operand_15)] = operand_16;

                        break :block_18 operand_17;
                    }, };
                };

                const value_14: zx_type_13 = ((&value_13)).*;
                const value_15: u64 = ((&value_14)).index;
                const value_16: u64 = @as(u64, 1);

                const value_17: zx_type_13 = block_13: {
                    break :block_13 zx_type_13{ .count = ((&value_14)).count, .history = ((&value_14)).history, .index = (value_15 + value_16), .values = ((&value_14)).values, };
                };

                break :block_24 ((&value_17)).*;
            };

            state_changed_12 = true;
        }

        break :block_27 (if (state_changed_12) block_26: {
            const operand_25 = (try (allocator).create(zx_type_13));

            (operand_25).* = @as(zx_type_13, state_10);

            break :block_26 @as(*const zx_type_13, operand_25);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (in).values;
        const operand_2 = (value_18).values;

        const operand_3 = block_6: {
            const operand_4 = (value_18).history;
            const operand_5 = @as(u64, 0);

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

