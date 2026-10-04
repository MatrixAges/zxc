const std = @import("std");

const zx_type_11 = struct {
    amount: u64,
    discount: u64,
    enabled: bool,
    factor: f32,
};

const zx_type_12 = struct {
    amount: u64,
    factor: f32,
};

pub const Input = *const zx_type_11;
pub const Output = *const zx_type_12;

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_11) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const value_1: f32 = ((in).factor * @as(f32, @as(f64, @bitCast(@as(u64, 4602678819172646912)))));

    if (((!(in).enabled) or ((in).discount > (in).amount))) {
        return block_10: {
            const operand_6 = (in).amount;
            const operand_7 = value_1;

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create(zx_type_12));

                (operand_8).* = @as(zx_type_12, zx_type_12{ .amount = operand_6, .factor = operand_7, });

                break :block_9 @as(*const zx_type_12, operand_8);
            };
        };
    }

    return block_5: {
        const operand_1 = ((in).amount - (in).discount);
        const operand_2 = value_1;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_12));

            (operand_3).* = @as(zx_type_12, zx_type_12{ .amount = operand_1, .factor = operand_2, });

            break :block_4 @as(*const zx_type_12, operand_3);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try function_0(allocator, in));
}
