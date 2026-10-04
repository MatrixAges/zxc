const std = @import("std");

const zx_type_12 = struct {
    cursor: u64,
    history: []const u64,
    label: []const u8,
};

const zx_type_13 = struct {
    enabled: bool,
    limit: u32,
};

const zx_type_14 = struct {
    limits: *const zx_type_13,
};

pub const Input = void;
pub const Output = *const zx_type_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) anyerror!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_9: {
        const operand_1 = block_6: {
            const operand_2 = true;
            const operand_3 = @as(u32, 8);

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create(zx_type_13));

                (operand_4).* = @as(zx_type_13, zx_type_13{ .enabled = operand_2, .limit = operand_3, });

                break :block_5 @as(*const zx_type_13, operand_4);
            };
        };

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create(zx_type_14));

            (operand_7).* = @as(zx_type_14, zx_type_14{ .limits = operand_1, });

            break :block_8 @as(*const zx_type_14, operand_7);
        };
    };
}

