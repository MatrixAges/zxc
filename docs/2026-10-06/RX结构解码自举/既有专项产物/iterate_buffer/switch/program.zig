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

    const value_1: *const zx_type_13 = block_45: {
        const operand_39 = (in).values;
        const operand_40 = (in).count;
        const operand_41 = @as(u64, 0);
        const operand_42 = (in).enabled;

        break :block_45 block_44: {
            const operand_43 = (try (allocator).create(zx_type_13));

            (operand_43).* = @as(zx_type_13, zx_type_13{ .values = operand_39, .count = operand_40, .index = operand_41, .enabled = operand_42, });

            break :block_44 @as(*const zx_type_13, operand_43);
        };
    };

    const value_25: *const zx_type_13 = block_38: {
        const operand_8 = value_1;
        var state_items_10: []i64 = undefined;
        var state_items_started_11 = false;
        var state_7: zx_type_13 = (operand_8).*;
        var state_changed_9 = false;

        while ((((&state_7)).index < ((&state_7)).count)) {
            state_7 = block_35: {
                const value_20: zx_type_13 = block_34: {
                    const operand_13 = @rem(((&state_7)).index, @as(u64, 3));

                    break :block_34 (if ((operand_13 == @as(u64, 0))) block_33: {
                        const value_4: zx_type_13 = ((&state_7)).*;
                        const value_5: []const i64 = ((&value_4)).values;
                        const value_6: u64 = @as(u64, 0);
                        const value_7: i64 = block_32: {
                            const operand_30 = value_5;
                            const operand_31 = value_6;

                            if ((operand_31 >= (operand_30).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_32 (operand_30)[@intCast(operand_31)];
                        };
                        const value_8: i64 = @as(i64, 1);

                        const value_9: zx_type_13 = block_29: {
                            break :block_29 zx_type_13{ .count = ((&value_4)).count, .enabled = ((&value_4)).enabled, .index = ((&value_4)).index, .values = block_28: {
                                const operand_25 = value_5;
                                const operand_26 = value_6;
                                const operand_27 = (value_7 + value_8);

                                if ((operand_26 >= (operand_25).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_11)) {
                                    state_items_10 = (try (allocator).dupe(i64, operand_25));
                                    state_items_started_11 = true;
                                }

                                (state_items_10)[@intCast(operand_26)] = operand_27;

                                break :block_28 state_items_10;
                            }, };
                        };

                        break :block_33 ((&value_9)).*;
                    } else (if ((operand_13 == @as(u64, 1))) block_24: {
                        const value_10: zx_type_13 = ((&state_7)).*;
                        const value_11: []const i64 = ((&value_10)).values;
                        const value_12: u64 = @as(u64, 0);
                        const value_13: i64 = block_23: {
                            const operand_21 = value_11;
                            const operand_22 = value_12;

                            if ((operand_22 >= (operand_21).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_23 (operand_21)[@intCast(operand_22)];
                        };
                        const value_14: i64 = @as(i64, 2);

                        const value_15: zx_type_13 = block_20: {
                            break :block_20 zx_type_13{ .count = ((&value_10)).count, .enabled = ((&value_10)).enabled, .index = ((&value_10)).index, .values = block_19: {
                                const operand_16 = value_11;
                                const operand_17 = value_12;
                                const operand_18 = (value_13 + value_14);

                                if ((operand_17 >= (operand_16).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                if ((!state_items_started_11)) {
                                    state_items_10 = (try (allocator).dupe(i64, operand_16));
                                    state_items_started_11 = true;
                                }

                                (state_items_10)[@intCast(operand_17)] = operand_18;

                                break :block_19 state_items_10;
                            }, };
                        };

                        break :block_24 ((&value_15)).*;
                    } else block_15: {
                        const value_16: zx_type_13 = ((&state_7)).*;
                        const value_17: u64 = ((&value_16)).index;
                        const value_18: u64 = @as(u64, 0);
                        const value_19: zx_type_13 = block_14: {
                            break :block_14 zx_type_13{ .count = ((&value_16)).count, .enabled = ((&value_16)).enabled, .index = (value_17 + value_18), .values = ((&value_16)).values, };
                        };

                        break :block_15 ((&value_19)).*;
                    }));
                };

                const value_21: zx_type_13 = ((&value_20)).*;
                const value_22: u64 = ((&value_21)).index;
                const value_23: u64 = @as(u64, 1);

                const value_24: zx_type_13 = block_12: {
                    break :block_12 zx_type_13{ .count = ((&value_21)).count, .enabled = ((&value_21)).enabled, .index = (value_22 + value_23), .values = ((&value_21)).values, };
                };

                break :block_35 ((&value_24)).*;
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
        const operand_2 = (value_25).values;
        const operand_3 = @as(i64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}

