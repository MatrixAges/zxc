const std = @import("std");

const zx_type_11 = struct {
    count: u64,
    start: u64,
};

const zx_type_12 = struct {
    index: u64,
    limit: u64,
    previous: u64,
    total: u64,
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .start = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .limit = zx_shape_5, .previous = zx_shape_5, .total = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .initial = zx_shape_12, .result = zx_shape_12, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_13;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_12 = block_34: {
        const operand_28 = (in).count;
        const operand_29 = @as(u64, 0);
        const operand_30 = (in).start;
        const operand_31 = (in).start;

        break :block_34 block_33: {
            const operand_32 = (try (allocator).create(zx_type_12));

            (operand_32).* = @as(zx_type_12, zx_type_12{ .limit = operand_28, .index = operand_29, .total = operand_30, .previous = operand_31, });

            break :block_33 @as(*const zx_type_12, operand_32);
        };
    };

    const value_39: *const zx_type_12 = block_27: {
        const operand_7 = value_1;
        var state_6: zx_type_12 = (operand_7).*;
        var state_changed_8 = false;

        while ((((&state_6)).index < ((&state_6)).limit)) {
            state_6 = block_24: {
                const value_4: zx_type_12 = ((&state_6)).*;
                const value_5: zx_type_12 = ((&state_6)).*;
                const value_6: u64 = ((&value_5)).index;
                const value_7: u64 = @as(u64, 1);
                const value_8: zx_type_12 = block_23: {
                    break :block_23 zx_type_12{ .index = (value_6 + value_7), .limit = ((&value_5)).limit, .previous = ((&value_5)).previous, .total = ((&value_5)).total, };
                };

                const value_9: zx_type_12 = ((&value_8)).*;
                const value_10: u64 = ((&value_9)).total;
                const value_11: u64 = ((&value_8)).index;

                const value_12: zx_type_12 = block_22: {
                    break :block_22 zx_type_12{ .index = ((&value_9)).index, .limit = ((&value_9)).limit, .previous = ((&value_9)).previous, .total = (value_10 + value_11), };
                };

                const value_13: zx_type_12 = ((&value_12)).*;

                _ = ((&value_13)).previous;

                const value_15: u64 = ((&value_4)).total;

                const value_16: zx_type_12 = block_21: {
                    break :block_21 zx_type_12{ .index = ((&value_13)).index, .limit = ((&value_13)).limit, .previous = value_15, .total = ((&value_13)).total, };
                };

                const value_25: zx_type_12 = (if ((@rem(((&value_16)).index, @as(u64, 2)) == @as(u64, 0))) block_18: {
                    const value_17: zx_type_12 = ((&value_16)).*;
                    const value_18: u64 = ((&value_17)).total;
                    const value_19: u64 = @as(u64, 2);
                    const value_20: zx_type_12 = block_17: {
                        break :block_17 zx_type_12{ .index = ((&value_17)).index, .limit = ((&value_17)).limit, .previous = ((&value_17)).previous, .total = (value_18 + value_19), };
                    };

                    break :block_18 ((&value_20)).*;
                } else block_20: {
                    const value_21: zx_type_12 = ((&value_16)).*;
                    const value_22: u64 = ((&value_21)).total;
                    const value_23: u64 = @as(u64, 1);

                    const value_24: zx_type_12 = block_19: {
                        break :block_19 zx_type_12{ .index = ((&value_21)).index, .limit = ((&value_21)).limit, .previous = ((&value_21)).previous, .total = (value_22 + value_23), };
                    };

                    break :block_20 ((&value_24)).*;
                });
                const value_38: zx_type_12 = block_16: {
                    const operand_9 = @rem(((&value_25)).index, @as(u64, 3));

                    break :block_16 (if ((operand_9 == @as(u64, 0))) block_15: {
                        const value_26: zx_type_12 = ((&value_25)).*;
                        const value_27: u64 = ((&value_26)).total;
                        const value_28: u64 = @as(u64, 3);

                        const value_29: zx_type_12 = block_14: {
                            break :block_14 zx_type_12{ .index = ((&value_26)).index, .limit = ((&value_26)).limit, .previous = ((&value_26)).previous, .total = (value_27 + value_28), };
                        };

                        break :block_15 ((&value_29)).*;
                    } else (if ((operand_9 == @as(u64, 1))) block_13: {
                        const value_30: zx_type_12 = ((&value_25)).*;
                        const value_31: u64 = ((&value_30)).total;
                        const value_32: u64 = @as(u64, 4);
                        const value_33: zx_type_12 = block_12: {
                            break :block_12 zx_type_12{ .index = ((&value_30)).index, .limit = ((&value_30)).limit, .previous = ((&value_30)).previous, .total = (value_31 + value_32), };
                        };

                        break :block_13 ((&value_33)).*;
                    } else block_11: {
                        const value_34: zx_type_12 = ((&value_25)).*;
                        const value_35: u64 = ((&value_34)).total;
                        const value_36: u64 = @as(u64, 5);
                        const value_37: zx_type_12 = block_10: {
                            break :block_10 zx_type_12{ .index = ((&value_34)).index, .limit = ((&value_34)).limit, .previous = ((&value_34)).previous, .total = (value_35 + value_36), };
                        };

                        break :block_11 ((&value_37)).*;
                    }));
                };

                break :block_24 ((&value_38)).*;
            };

            state_changed_8 = true;
        }

        break :block_27 (if (state_changed_8) block_26: {
            const operand_25 = (try (allocator).create(zx_type_12));

            (operand_25).* = @as(zx_type_12, state_6);

            break :block_26 @as(*const zx_type_12, operand_25);
        } else operand_7);
    };

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_39;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_13));

            (operand_3).* = @as(zx_type_13, zx_type_13{ .initial = operand_1, .result = operand_2, });

            break :block_4 @as(*const zx_type_13, operand_3);
        };
    };
}

