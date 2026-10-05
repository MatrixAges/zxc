const std = @import("std");

const zx_type_11 = struct {
    stop: u64,
};

const zx_type_12 = struct {
    even: u64,
    odd: u64,
    position: u64,
    stop: u64,
};

pub const Input = *const zx_type_11;
pub const State = *const zx_type_12;
pub const Output = *const zx_type_12;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .stop = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .even = zx_shape_5, .odd = zx_shape_5, .position = zx_shape_5, .stop = zx_shape_5, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_12;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_12 = block_21: {
        const operand_15 = @as(u64, 0);
        const operand_16 = (in).stop;
        const operand_17 = @as(u64, 0);
        const operand_18 = @as(u64, 0);

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create(zx_type_12));

            (operand_19).* = @as(zx_type_12, zx_type_12{ .position = operand_15, .stop = operand_16, .even = operand_17, .odd = operand_18, });

            break :block_20 @as(*const zx_type_12, operand_19);
        };
    };

    return block_14: {
        const operand_2 = value_1;
        var state_1: zx_type_12 = (operand_2).*;
        var state_changed_3 = false;

        while (true) {
            state_1 = block_11: {
                const value_12: zx_type_12 = block_10: {
                    const operand_5 = @rem(((&state_1)).position, @as(u64, 2));

                    break :block_10 (if ((operand_5 == @as(u64, 0))) block_9: {
                        const value_4: zx_type_12 = ((&state_1)).*;
                        const value_5: u64 = ((&value_4)).even;
                        const value_6: u64 = @as(u64, 1);

                        const value_7: zx_type_12 = block_8: {
                            break :block_8 zx_type_12{ .even = (value_5 + value_6), .odd = ((&value_4)).odd, .position = ((&value_4)).position, .stop = ((&value_4)).stop, };
                        };

                        break :block_9 ((&value_7)).*;
                    } else block_7: {
                        const value_8: zx_type_12 = ((&state_1)).*;
                        const value_9: u64 = ((&value_8)).odd;
                        const value_10: u64 = @as(u64, 1);
                        const value_11: zx_type_12 = block_6: {
                            break :block_6 zx_type_12{ .even = ((&value_8)).even, .odd = (value_9 + value_10), .position = ((&value_8)).position, .stop = ((&value_8)).stop, };
                        };

                        break :block_7 ((&value_11)).*;
                    });
                };

                const value_13: zx_type_12 = ((&value_12)).*;
                const value_14: u64 = ((&value_13)).position;
                const value_15: u64 = @as(u64, 1);

                const value_16: zx_type_12 = block_4: {
                    break :block_4 zx_type_12{ .even = ((&value_13)).even, .odd = ((&value_13)).odd, .position = (value_14 + value_15), .stop = ((&value_13)).stop, };
                };

                break :block_11 ((&value_16)).*;
            };

            state_changed_3 = true;

            if ((!(((&state_1)).position < ((&state_1)).stop))) {
                break;
            }
        }

        break :block_14 (if (state_changed_3) block_13: {
            const operand_12 = (try (allocator).create(zx_type_12));

            (operand_12).* = @as(zx_type_12, state_1);

            break :block_13 @as(*const zx_type_12, operand_12);
        } else operand_2);
    };
}
