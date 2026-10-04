const std = @import("std");

pub const Input = u64;

pub const Output = []const u8;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror![]const u8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_2: {
        const operand_1 = @as([]const u8, "A\rB");

        break :block_2 (try ((std).mem).concat(allocator, u8, (&[_][]const u8{operand_1, })));
    };
}

