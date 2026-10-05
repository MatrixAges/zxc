const std = @import("std");

const zx_type_12 = struct {
    previous: u64,
    values: []const u64,
};

const zx_type_13 = struct { []const u64, void, };
pub const Input = []const u64;
pub const State = *const zx_type_12;
pub const Output = *const zx_type_12;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const u64 = block_25: {
        const operand_24 = @as(u64, 7);

        break :block_25 (try (allocator).dupe(u64, (&[_]u64{operand_24, })));
    };

    const value_2: *const zx_type_12 = block_23: {
        const operand_19 = @as(u64, 0);
        const operand_20 = value_1;

        break :block_23 block_22: {
            const operand_21 = (try (allocator).create(zx_type_12));

            (operand_21).* = @as(zx_type_12, zx_type_12{ .previous = operand_19, .values = operand_20, });

            break :block_22 @as(*const zx_type_12, operand_21);
        };
    };

    return block_18: {
        const operand_1 = in;
        const operand_2 = value_2;
        var value_3: zx_type_12 = (operand_2).*;
        var state_changed_3 = false;

        for (operand_1) |value_4| {
            value_3 = block_15: {
                const operand_4 = block_7: {
                    const operand_5 = (value_3).values;
                    const operand_6 = @as(u64, 0);

                    if ((operand_6 >= (operand_5).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_7 (operand_5)[@intCast(operand_6)];
                };
                const operand_8 = (block_14: {
                    const operand_9 = (value_3).values;
                    const operand_10 = value_4;
                    const operand_11 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_9).len, 1))));

                    @memcpy((operand_11)[0..(operand_9).len], operand_9);

                    (operand_11)[(operand_9).len] = operand_10;

                    break :block_14 block_13: {
                        const operand_12 = (try (allocator).create(zx_type_13));

                        (operand_12).* = @as(zx_type_13, .{ operand_11, {}, });

                        break :block_13 @as(*const zx_type_13, operand_12);
                    };
                }).@"0";

                break :block_15 zx_type_12{ .previous = operand_4, .values = operand_8, };
            };

            state_changed_3 = true;
        }

        break :block_18 (if (state_changed_3) block_17: {
            const operand_16 = (try (allocator).create(zx_type_12));

            (operand_16).* = @as(zx_type_12, value_3);

            break :block_17 @as(*const zx_type_12, operand_16);
        } else operand_2);
    };
}

