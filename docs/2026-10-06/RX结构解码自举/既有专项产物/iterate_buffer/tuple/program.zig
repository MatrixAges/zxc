const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct { []const i64, u64, };

const zx_type_14 = struct {
    count: u64,
    pair: *const zx_type_13,
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .pair = zx_shape_13, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_15;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_15 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_14 = block_44: {
        const operand_35 = block_40: {
            const operand_36 = (in).values;
            const operand_37 = @as(u64, 0);

            break :block_40 block_39: {
                const operand_38 = (try (allocator).create(zx_type_13));

                (operand_38).* = @as(zx_type_13, .{ operand_36, operand_37, });

                break :block_39 @as(*const zx_type_13, operand_38);
            };
        };

        const operand_41 = (in).count;

        break :block_44 block_43: {
            const operand_42 = (try (allocator).create(zx_type_14));

            (operand_42).* = @as(zx_type_14, zx_type_14{ .pair = operand_35, .count = operand_41, });

            break :block_43 @as(*const zx_type_14, operand_42);
        };
    };

    const value_16: *const zx_type_14 = block_34: {
        const operand_8 = value_1;
        var state_items_10: []i64 = undefined;
        var state_items_started_11 = false;
        const state_type_12 = struct { []const i64, u64, };

        const state_type_13 = struct {
            count: u64,
            pair: state_type_12,
        };

        var state_7: state_type_13 = state_type_13{ .count = (operand_8).count, .pair = @as(state_type_12, .{ ((operand_8).pair).@"0", ((operand_8).pair).@"1", }), };
        var state_changed_9 = false;

        while ((((state_7).pair).@"1" < (state_7).count)) {
            state_7 = block_29: {
                const value_4: state_type_13 = state_7;
                const value_5: state_type_12 = (value_4).pair;
                const value_6: []const i64 = (value_5).@"0";
                const value_7: u64 = @as(u64, 0);

                const value_8: i64 = block_28: {
                    const operand_26 = value_6;
                    const operand_27 = value_7;

                    if ((operand_27 >= (operand_26).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_28 (operand_26)[@intCast(operand_27)];
                };

                const value_9: i64 = @as(i64, 1);

                const value_10: state_type_13 = block_25: {
                    break :block_25 state_type_13{ .count = (value_4).count, .pair = block_24: {
                        const operand_22 = block_21: {
                            const operand_18 = value_6;
                            const operand_19 = value_7;
                            const operand_20 = (value_8 + value_9);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            if ((!state_items_started_11)) {
                                state_items_10 = (try (allocator).dupe(i64, operand_18));
                                state_items_started_11 = true;
                            }

                            (state_items_10)[@intCast(operand_19)] = operand_20;

                            break :block_21 state_items_10;
                        };

                        const operand_23 = (value_5).@"1";

                        break :block_24 @as(state_type_12, .{ operand_22, operand_23, });
                    }, };
                };

                const value_11: state_type_13 = value_10;
                const value_12: state_type_12 = (value_11).pair;
                const value_13: u64 = (value_12).@"1";
                const value_14: u64 = @as(u64, 1);

                const value_15: state_type_13 = block_17: {
                    break :block_17 state_type_13{ .count = (value_11).count, .pair = block_16: {
                        const operand_14 = (value_12).@"0";
                        const operand_15 = (value_13 + value_14);

                        break :block_16 @as(state_type_12, .{ operand_14, operand_15, });
                    }, };
                };

                break :block_29 value_15;
            };

            state_changed_9 = true;
        }

        break :block_34 (if (state_changed_9) block_33: {
            const operand_32 = (try (allocator).create(zx_type_14));

            (operand_32).* = @as(zx_type_14, zx_type_14{ .count = (state_7).count, .pair = block_31: {
                const operand_30 = (try (allocator).create(zx_type_13));

                (operand_30).* = @as(zx_type_13, @as(zx_type_13, .{ ((state_7).pair).@"0", ((state_7).pair).@"1", }));

                break :block_31 @as(*const zx_type_13, operand_30);
            }, });

            break :block_33 @as(*const zx_type_14, operand_32);
        } else operand_8);
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = ((value_16).pair).@"0";
        const operand_3 = @as(i64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_15));

            (operand_4).* = @as(zx_type_15, zx_type_15{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_15, operand_4);
        };
    };
}

