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

    const value_1: *const zx_type_13 = block_45: {
        const operand_39 = (in).values;
        const operand_40 = (in).count;
        const operand_41 = @as(u64, 0);
        const operand_42 = @as(i64, 0);

        break :block_45 block_44: {
            const operand_43 = (try (allocator).create(zx_type_13));

            (operand_43).* = @as(zx_type_13, zx_type_13{ .values = operand_39, .count = operand_40, .index = operand_41, .seen = operand_42, });

            break :block_44 @as(*const zx_type_13, operand_43);
        };
    };

    const value_26: *const zx_type_13 = block_38: {
        const operand_8 = value_1;
        var state_7: zx_type_13 = (operand_8).*;
        var state_changed_9 = false;

        while ((((&state_7)).index < ((&state_7)).count)) {
            state_7 = block_35: {
                const value_4: []const i64 = ((&state_7)).values;

                const value_17: zx_type_13 = (if ((@rem(((&state_7)).index, @as(u64, 2)) == @as(u64, 0))) block_24: {
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

                    break :block_24 ((&value_10)).*;
                } else block_34: {
                    const value_11: zx_type_13 = ((&state_7)).*;
                    const value_12: []const i64 = ((&value_11)).values;
                    const value_13: u64 = @as(u64, 0);
                    const value_14: i64 = block_33: {
                        const operand_31 = value_12;
                        const operand_32 = value_13;

                        if ((operand_32 >= (operand_31).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_33 (operand_31)[@intCast(operand_32)];
                    };

                    const value_15: i64 = @as(i64, 2);

                    const value_16: zx_type_13 = block_30: {
                        break :block_30 zx_type_13{ .count = ((&value_11)).count, .index = ((&value_11)).index, .seen = ((&value_11)).seen, .values = block_29: {
                            const operand_25 = value_12;
                            const operand_26 = value_13;
                            const operand_27 = (value_14 + value_15);

                            if ((operand_26 >= (operand_25).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_28 = (try (allocator).dupe(i64, operand_25));

                            (operand_28)[@intCast(operand_26)] = operand_27;

                            break :block_29 operand_28;
                        }, };
                    };

                    break :block_34 ((&value_16)).*;
                });

                const value_18: zx_type_13 = ((&value_17)).*;
                const value_19: i64 = ((&value_18)).seen;

                const value_20: i64 = block_14: {
                    const operand_12 = value_4;
                    const operand_13 = @as(u64, 0);

                    if ((operand_13 >= (operand_12).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_14 (operand_12)[@intCast(operand_13)];
                };
                const value_21: zx_type_13 = block_11: {
                    break :block_11 zx_type_13{ .count = ((&value_18)).count, .index = ((&value_18)).index, .seen = (value_19 + value_20), .values = ((&value_18)).values, };
                };

                const value_22: zx_type_13 = ((&value_21)).*;
                const value_23: u64 = ((&value_22)).index;
                const value_24: u64 = @as(u64, 1);

                const value_25: zx_type_13 = block_10: {
                    break :block_10 zx_type_13{ .count = ((&value_22)).count, .index = (value_23 + value_24), .seen = ((&value_22)).seen, .values = ((&value_22)).values, };
                };

                break :block_35 ((&value_25)).*;
            };

            state_changed_9 = true;
        }

        break :block_38 (if (state_changed_9) block_37: {
            const operand_36 = (try (allocator).create(zx_type_13));

            (operand_36).* = @as(zx_type_13, state_7);

            break :block_37 @as(*const zx_type_13, operand_36);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = (value_26).values;
        const operand_3 = (value_26).seen;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}

