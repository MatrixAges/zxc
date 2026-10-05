const std = @import("std");

const zx_type_11 = struct {
    remaining: u64,
};

const zx_type_12 = struct {
    processed: u64,
    remaining: u64,
};

const zx_type_13 = struct {
    initial: *const zx_type_12,
    result: *const zx_type_12,
};

pub const Input = *const zx_type_11;
pub const State = *const zx_type_12;
pub const Output = *const zx_type_13;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .processed = zx_shape_5, .remaining = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .initial = zx_shape_12, .result = zx_shape_12, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_13;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11) anyerror!*const zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_12 = block_19: {
        const operand_15 = (in).remaining;
        const operand_16 = @as(u64, 0);

        break :block_19 block_18: {
            const operand_17 = (try (allocator).create(zx_type_12));

            (operand_17).* = @as(zx_type_12, zx_type_12{ .remaining = operand_15, .processed = operand_16, });

            break :block_18 @as(*const zx_type_12, operand_17);
        };
    };

    const value_13: *const zx_type_12 = block_14: {
        const operand_7 = value_1;
        var state_6: zx_type_12 = (operand_7).*;
        var state_changed_8 = false;

        while ((((&state_6)).remaining > @as(u64, 0))) {
            state_6 = block_11: {
                const value_4: zx_type_12 = ((&state_6)).*;
                const value_5: zx_type_12 = ((&state_6)).*;
                const value_6: u64 = ((&value_5)).remaining;
                const value_7: u64 = @as(u64, 1);
                const value_8: zx_type_12 = block_10: {
                    break :block_10 zx_type_12{ .processed = ((&value_5)).processed, .remaining = (value_6 - value_7), };
                };

                const value_9: zx_type_12 = ((&value_8)).*;

                _ = ((&value_9)).processed;

                const value_11: u64 = (((&value_4)).processed + @as(u64, 1));

                const value_12: zx_type_12 = block_9: {
                    break :block_9 zx_type_12{ .processed = value_11, .remaining = ((&value_9)).remaining, };
                };

                break :block_11 ((&value_12)).*;
            };

            state_changed_8 = true;
        }

        break :block_14 (if (state_changed_8) block_13: {
            const operand_12 = (try (allocator).create(zx_type_12));

            (operand_12).* = @as(zx_type_12, state_6);

            break :block_13 @as(*const zx_type_12, operand_12);
        } else operand_7);
    };

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_13;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_13));

            (operand_3).* = @as(zx_type_13, zx_type_13{ .initial = operand_1, .result = operand_2, });

            break :block_4 @as(*const zx_type_13, operand_3);
        };
    };
}
