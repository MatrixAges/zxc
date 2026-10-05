const std = @import("std");

const zx_type_11 = struct {
    remaining: u64,
};

const zx_type_13 = struct {
    cursor: ?*const zx_type_11,
    processed: u64,
};

const zx_type_14 = struct {
    count: u64,
};

const zx_type_15 = struct {
    initial: *const zx_type_13,
    result: *const zx_type_13,
};

pub const Input = *const zx_type_14;
pub const Cursor = *const zx_type_11;
pub const State = *const zx_type_13;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .remaining = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .optional, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .cursor = zx_shape_12, .processed = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .initial = zx_shape_13, .result = zx_shape_13, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_15;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_13) anyerror!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    return ((in).cursor != null);
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_14) anyerror!*const zx_type_15 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_13 = block_36: {
        const operand_28 = (if (((in).count > @as(u64, 0))) @as(?*const zx_type_11, block_32: {
            const operand_29 = (in).count;

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create(zx_type_11));

                (operand_30).* = @as(zx_type_11, zx_type_11{ .remaining = operand_29, });

                break :block_31 @as(*const zx_type_11, operand_30);
            };
        }) else @as(?*const zx_type_11, null));

        const operand_33 = @as(u64, 0);

        break :block_36 block_35: {
            const operand_34 = (try (allocator).create(zx_type_13));

            (operand_34).* = @as(zx_type_13, zx_type_13{ .cursor = operand_28, .processed = operand_33, });

            break :block_35 @as(*const zx_type_13, operand_34);
        };
    };

    const value_13: *const zx_type_13 = block_27: {
        const operand_7 = value_1;

        const state_type_14 = struct {
            remaining: u64,
        };
        const state_type_15 = struct {
            cursor: ?state_type_14,
            processed: u64,
        };

        var state_6: state_type_15 = state_type_15{ .cursor = @as(?state_type_14, (if (((operand_7).cursor != null)) state_type_14{ .remaining = ((operand_7).cursor.?).remaining, } else null)), .processed = (operand_7).processed, };
        var state_changed_8 = false;

        while (block_13: {
            const operand_9 = state_6;
            const operand_10 = (if (((operand_9).cursor != null)) zx_type_11{ .remaining = ((operand_9).cursor.?).remaining, } else undefined);
            const operand_11 = zx_type_13{ .cursor = @as(?*const zx_type_11, (if (((operand_9).cursor != null)) (&operand_10) else null)), .processed = (operand_9).processed, };
            const operand_12 = (try function_0(allocator, (&operand_11)));

            break :block_13 operand_12;
        }) {
            state_6 = block_22: {
                const value_4: state_type_14 = ((state_6).cursor orelse block_21: {
                    const operand_20 = @as(u64, 0);

                    break :block_21 state_type_14{ .remaining = operand_20, };
                });

                const value_5: state_type_15 = state_6;

                _ = (value_5).cursor;

                const value_7: ?state_type_14 = (if (((value_4).remaining > @as(u64, 1))) @as(?state_type_14, block_19: {
                    const operand_18 = ((value_4).remaining - @as(u64, 1));

                    break :block_19 state_type_14{ .remaining = operand_18, };
                }) else @as(?state_type_14, null));

                const value_8: state_type_15 = block_17: {
                    break :block_17 state_type_15{ .cursor = value_7, .processed = (value_5).processed, };
                };
                const value_9: state_type_15 = value_8;
                const value_10: u64 = (value_9).processed;
                const value_11: u64 = @as(u64, 1);

                const value_12: state_type_15 = block_16: {
                    break :block_16 state_type_15{ .cursor = (value_9).cursor, .processed = (value_10 + value_11), };
                };

                break :block_22 value_12;
            };

            state_changed_8 = true;
        }

        break :block_27 (if (state_changed_8) block_26: {
            const operand_25 = (try (allocator).create(zx_type_13));

            (operand_25).* = @as(zx_type_13, zx_type_13{ .cursor = @as(?*const zx_type_11, (if (((state_6).cursor != null)) block_24: {
                const operand_23 = (try (allocator).create(zx_type_11));

                (operand_23).* = @as(zx_type_11, zx_type_11{ .remaining = ((state_6).cursor.?).remaining, });

                break :block_24 @as(*const zx_type_11, operand_23);
            } else null)), .processed = (state_6).processed, });

            break :block_26 @as(*const zx_type_13, operand_25);
        } else operand_7);
    };

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_13;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_15));

            (operand_3).* = @as(zx_type_15, zx_type_15{ .initial = operand_1, .result = operand_2, });

            break :block_4 @as(*const zx_type_15, operand_3);
        };
    };
}
