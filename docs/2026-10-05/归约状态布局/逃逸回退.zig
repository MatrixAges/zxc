const std = @import("std");

const zx_type_11 = struct {
    count: u64,
    total: u64,
};

pub const Input = []const u64;
pub const State = *const zx_type_11;
pub const Output = *const zx_type_11;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_11) anyerror!*const zx_type_11 {
    @setRuntimeSafety(true);

    return block_5: {
        const operand_1 = ((in).count + @as(u64, 1));
        const operand_2 = ((in).total + @as(u64, 1));

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_11));

            (operand_3).* = @as(zx_type_11, zx_type_11{ .count = operand_1, .total = operand_2, });

            break :block_4 @as(*const zx_type_11, operand_3);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const zx_type_11 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const zx_type_11 = block_12: {
        const operand_8 = @as(u64, 0);
        const operand_9 = @as(u64, 0);

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create(zx_type_11));

            (operand_10).* = @as(zx_type_11, zx_type_11{ .count = operand_8, .total = operand_9, });

            break :block_11 @as(*const zx_type_11, operand_10);
        };
    };

    return block_7: {
        const operand_1 = in;
        var value_2: *const zx_type_11 = value_1;

        for (operand_1) |value_3| {
            value_2 = block_6: {
                const operand_2 = (try function_0(allocator, value_2));
                const operand_3 = value_3;

                break :block_6 block_5: {
                    const operand_4 = (try (allocator).create(zx_type_11));

                    (operand_4).* = @as(zx_type_11, zx_type_11{ .count = (operand_2).count, .total = operand_3, });

                    break :block_5 @as(*const zx_type_11, operand_4);
                };
            };
        }

        break :block_7 value_2;
    };
}

