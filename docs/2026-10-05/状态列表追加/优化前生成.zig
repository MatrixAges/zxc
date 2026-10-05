const std = @import("std");

const zx_type_12 = struct {
    count: u64,
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

    const value_1: []const u64 = block_21: {
        break :block_21 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_2: *const zx_type_12 = block_20: {
        const operand_16 = @as(u64, 0);
        const operand_17 = value_1;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create(zx_type_12));

            (operand_18).* = @as(zx_type_12, zx_type_12{ .count = operand_16, .values = operand_17, });

            break :block_19 @as(*const zx_type_12, operand_18);
        };
    };

    return block_15: {
        const operand_1 = in;
        const operand_2 = value_2;
        var value_3: zx_type_12 = (operand_2).*;
        var state_changed_3 = false;

        for (operand_1) |value_4| {
            value_3 = block_12: {
                const operand_4 = ((value_3).count + @as(u64, 1));

                const operand_5 = (block_11: {
                    const operand_6 = (value_3).values;
                    const operand_7 = value_4;
                    const operand_8 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_6).len, 1))));

                    @memcpy((operand_8)[0..(operand_6).len], operand_6);

                    (operand_8)[(operand_6).len] = operand_7;

                    break :block_11 block_10: {
                        const operand_9 = (try (allocator).create(zx_type_13));

                        (operand_9).* = @as(zx_type_13, .{ operand_8, {}, });

                        break :block_10 @as(*const zx_type_13, operand_9);
                    };
                }).@"0";

                break :block_12 zx_type_12{ .count = operand_4, .values = operand_5, };
            };

            state_changed_3 = true;
        }

        break :block_15 (if (state_changed_3) block_14: {
            const operand_13 = (try (allocator).create(zx_type_12));

            (operand_13).* = @as(zx_type_12, value_3);

            break :block_14 @as(*const zx_type_12, operand_13);
        } else operand_2);
    };
}

