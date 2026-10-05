const std = @import("std");

const zx_type_11 = struct {
    processed: u64,
    remaining: u64,
};

const zx_type_12 = struct {
    counter: *const zx_type_11,
};

const zx_type_13 = struct {
    count: u64,
};

const zx_type_14 = struct {
    initial: *const zx_type_12,
    result: *const zx_type_12,
};

pub const Input = *const zx_type_13;
pub const Counter = *const zx_type_11;
pub const State = *const zx_type_12;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .processed = zx_shape_5, .remaining = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .counter = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .initial = zx_shape_12, .result = zx_shape_12, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_14;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_12) anyerror!*const zx_type_11 {
    @setRuntimeSafety(true);

    return (if ((((in).counter).remaining > @as(u64, 0))) block_5: {
        const operand_1 = (((in).counter).remaining - @as(u64, 1));
        const operand_2 = (((in).counter).processed + @as(u64, 1));

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_11));

            (operand_3).* = @as(zx_type_11, zx_type_11{ .remaining = operand_1, .processed = operand_2, });

            break :block_4 @as(*const zx_type_11, operand_3);
        };
    } else (in).counter);
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const zx_type_12) anyerror!zx_type_11 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((((in).counter).remaining > @as(u64, 0))) block_8: {
        const operand_6 = (((in).counter).remaining - @as(u64, 1));
        const operand_7 = (((in).counter).processed + @as(u64, 1));

        break :block_8 zx_type_11{ .remaining = operand_6, .processed = operand_7, };
    } else ((in).counter).*);
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_13) anyerror!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_12 = block_32: {
        const operand_24 = block_29: {
            const operand_25 = (in).count;
            const operand_26 = @as(u64, 0);

            break :block_29 block_28: {
                const operand_27 = (try (allocator).create(zx_type_11));

                (operand_27).* = @as(zx_type_11, zx_type_11{ .remaining = operand_25, .processed = operand_26, });

                break :block_28 @as(*const zx_type_11, operand_27);
            };
        };

        break :block_32 block_31: {
            const operand_30 = (try (allocator).create(zx_type_12));

            (operand_30).* = @as(zx_type_12, zx_type_12{ .counter = operand_24, });

            break :block_31 @as(*const zx_type_12, operand_30);
        };
    };

    const value_8: *const zx_type_12 = block_23: {
        const operand_7 = value_1;

        const state_type_9 = struct {
            processed: u64,
            remaining: u64,
        };
        const state_type_10 = struct {
            counter: state_type_9,
        };

        var state_6: state_type_10 = state_type_10{ .counter = state_type_9{ .processed = ((operand_7).counter).processed, .remaining = ((operand_7).counter).remaining, }, };
        var state_changed_8 = false;

        while (true) {
            state_6 = block_18: {
                const value_4: state_type_10 = state_6;

                _ = (value_4).counter;

                const value_6: state_type_9 = block_17: {
                    const operand_12 = state_6;
                    const operand_13 = zx_type_11{ .processed = ((operand_12).counter).processed, .remaining = ((operand_12).counter).remaining, };
                    const operand_14 = zx_type_12{ .counter = (&operand_13), };

                    const operand_16 = block_15: {
                        break :block_15 (try function_0_value(allocator, (&operand_14)));
                    };

                    break :block_17 state_type_9{ .processed = (operand_16).processed, .remaining = (operand_16).remaining, };
                };
                const value_7: state_type_10 = block_11: {
                    break :block_11 state_type_10{ .counter = value_6, };
                };

                break :block_18 value_7;
            };

            state_changed_8 = true;

            if ((!(((state_6).counter).remaining > @as(u64, 0)))) {
                break;
            }
        }

        break :block_23 (if (state_changed_8) block_22: {
            const operand_21 = (try (allocator).create(zx_type_12));

            (operand_21).* = @as(zx_type_12, zx_type_12{ .counter = block_20: {
                const operand_19 = (try (allocator).create(zx_type_11));

                (operand_19).* = @as(zx_type_11, zx_type_11{ .processed = ((state_6).counter).processed, .remaining = ((state_6).counter).remaining, });

                break :block_20 @as(*const zx_type_11, operand_19);
            }, });

            break :block_22 @as(*const zx_type_12, operand_21);
        } else operand_7);
    };

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_8;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_14));

            (operand_3).* = @as(zx_type_14, zx_type_14{ .initial = operand_1, .result = operand_2, });

            break :block_4 @as(*const zx_type_14, operand_3);
        };
    };
}
