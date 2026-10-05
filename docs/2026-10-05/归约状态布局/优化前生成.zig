const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    total: u64,
};

pub const Input = []const u64;
pub const State = *const zx_type_12;
pub const Output = *const zx_type_12;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_12 = block_12: {
        const operand_8 = @as(u64, 0);
        const operand_9 = @as(u64, 0);

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create(zx_type_12));

            (operand_10).* = @as(zx_type_12, zx_type_12{ .count = operand_8, .total = operand_9, });

            break :block_11 @as(*const zx_type_12, operand_10);
        };
    };

    return block_7: {
        const operand_1 = in;
        var value_2: *const zx_type_12 = value_1;

        for (operand_1) |value_3| {
            value_2 = block_6: {
                const operand_2 = ((value_2).count + @as(u64, 1));
                const operand_3 = ((value_2).total + value_3);

                break :block_6 block_5: {
                    const operand_4 = (try (allocator).create(zx_type_12));

                    (operand_4).* = @as(zx_type_12, zx_type_12{ .count = operand_2, .total = operand_3, });

                    break :block_5 @as(*const zx_type_12, operand_4);
                };
            };
        }

        break :block_7 value_2;
    };
}

