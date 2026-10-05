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

    const value_1: []const u64 = block_27: {
        break :block_27 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_2: *const zx_type_12 = block_26: {
        const operand_22 = @as(u64, 0);
        const operand_23 = value_1;

        break :block_26 block_25: {
            const operand_24 = (try (allocator).create(zx_type_12));

            (operand_24).* = @as(zx_type_12, zx_type_12{ .count = operand_22, .values = operand_23, });

            break :block_25 @as(*const zx_type_12, operand_24);
        };
    };

    return block_21: {
        const operand_1 = in;
        const operand_2 = value_2;
        var value_3: zx_type_12 = (operand_2).*;
        var state_changed_3 = false;

        for (operand_1) |value_4| {
            value_3 = block_18: {
                const operand_4 = block_15: {
                    const operand_5 = (value_3).count;

                    const operand_6 = (block_12: {
                        const operand_7 = (value_3).values;
                        const operand_8 = value_4;
                        const operand_9 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_7).len, 1))));

                        @memcpy((operand_9)[0..(operand_7).len], operand_7);

                        (operand_9)[(operand_7).len] = operand_8;

                        break :block_12 block_11: {
                            const operand_10 = (try (allocator).create(zx_type_13));

                            (operand_10).* = @as(zx_type_13, .{ operand_9, {}, });

                            break :block_11 @as(*const zx_type_13, operand_10);
                        };
                    }).@"0";

                    break :block_15 block_14: {
                        const operand_13 = (try (allocator).create(zx_type_12));

                        (operand_13).* = @as(zx_type_12, zx_type_12{ .count = operand_5, .values = operand_6, });

                        break :block_14 @as(*const zx_type_12, operand_13);
                    };
                };
                const operand_16 = block_17: {
                    break :block_17 (try (allocator).dupe(u64, (&[_]u64{})));
                };

                break :block_18 zx_type_12{ .count = (operand_4).count, .values = operand_16, };
            };

            state_changed_3 = true;
        }

        break :block_21 (if (state_changed_3) block_20: {
            const operand_19 = (try (allocator).create(zx_type_12));

            (operand_19).* = @as(zx_type_12, value_3);

            break :block_20 @as(*const zx_type_12, operand_19);
        } else operand_2);
    };
}

