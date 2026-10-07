const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    count: u64,
    index: u64,
    seen: i64,
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .index = zx_shape_5, .seen = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_34: {
        const operand_28 = (in).values;
        const operand_29 = (in).count;
        const operand_30 = @as(u64, 0);
        const operand_31 = @as(i64, 0);

        break :block_34 block_33: {
            const operand_32 = (try (allocator).create(zx_type_13));

            (operand_32).* = @as(zx_type_13, zx_type_13{ .values = operand_28, .count = operand_29, .index = operand_30, .seen = operand_31, });

            break :block_33 @as(*const zx_type_13, operand_32);
        };
    };

    const value_19: *const zx_type_13 = block_27: {
        const operand_8 = value_1;
        var state_7: zx_type_13 = (operand_8).*;
        var state_changed_9 = false;

        while ((((&state_7)).index < ((&state_7)).count)) {
            state_7 = block_24: {
                const value_4: []const i64 = ((&state_7)).values;
                const value_5: zx_type_13 = ((&state_7)).*;
                const value_6: []const i64 = ((&value_5)).values;
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

                const value_10: zx_type_13 = block_20: {
                    break :block_20 zx_type_13{ .count = ((&value_5)).count, .index = ((&value_5)).index, .seen = ((&value_5)).seen, .values = block_19: {
                        const operand_15 = value_6;
                        const operand_16 = value_7;
                        const operand_17 = (value_8 + value_9);

                        if ((operand_16 >= (operand_15).len)) {
                            return error.IndexOutOfBounds;
                        }

                        const operand_18 = (try (allocator).dupe(i64, operand_15));

                        (operand_18)[@intCast(operand_16)] = operand_17;

                        break :block_19 operand_18;
                    }, };
                };

                const value_11: zx_type_13 = ((&value_10)).*;
                const value_12: i64 = ((&value_11)).seen;

                const value_13: i64 = block_14: {
                    const operand_12 = value_4;
                    const operand_13 = @as(u64, 0);

                    if ((operand_13 >= (operand_12).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_14 (operand_12)[@intCast(operand_13)];
                };
                const value_14: zx_type_13 = block_11: {
                    break :block_11 zx_type_13{ .count = ((&value_11)).count, .index = ((&value_11)).index, .seen = (value_12 + value_13), .values = ((&value_11)).values, };
                };

                const value_15: zx_type_13 = ((&value_14)).*;
                const value_16: u64 = ((&value_15)).index;
                const value_17: u64 = @as(u64, 1);

                const value_18: zx_type_13 = block_10: {
                    break :block_10 zx_type_13{ .count = ((&value_15)).count, .index = (value_16 + value_17), .seen = ((&value_15)).seen, .values = ((&value_15)).values, };
                };

                break :block_24 ((&value_18)).*;
            };

            state_changed_9 = true;
        }

        break :block_27 (if (state_changed_9) block_26: {
            const operand_25 = (try (allocator).create(zx_type_13));

            (operand_25).* = @as(zx_type_13, state_7);

            break :block_26 @as(*const zx_type_13, operand_25);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = (value_19).values;
        const operand_3 = (value_19).seen;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}

