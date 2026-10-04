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
pub const Output = *const zx_type_12;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_10: {
        const operand_1 = @as(u64, 0);
        const operand_2 = @as([]const u8, "ready");

        const operand_3 = block_7: {
            const operand_4 = @as(u64, 1);
            const operand_5 = @as(u64, 2);
            const operand_6 = @as(u64, 3);

            break :block_7 (try (allocator).dupe(u64, (&[_]u64{operand_4, operand_5, operand_6, })));
        };

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create(zx_type_12));

            (operand_8).* = @as(zx_type_12, zx_type_12{ .cursor = operand_1, .label = operand_2, .history = operand_3, });

            break :block_9 @as(*const zx_type_12, operand_8);
        };
    };
}

