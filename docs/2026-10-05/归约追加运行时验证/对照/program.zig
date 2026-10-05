const std = @import("std");

const zx_type_12 = struct {
    enabled: bool,
    value: u64,
    values: []const u64,
};

const zx_type_14 = struct {
    seed: []const u64,
    steps: []const *const zx_type_12,
};

const zx_type_15 = struct {
    []const u64,
    void,
};

pub const Input = *const zx_type_14;
pub const Output = []const u64;
pub const consumes_input = false;
pub const requires_io = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_14) anyerror![]const u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_2: []const u64 = block_17: {
        const operand_15 = (in).seed;
        var items_16: (std).ArrayList(u64) = .empty;

        for (operand_15) |value_1| {
            (try (items_16).append(allocator, value_1));
        }

        break :block_17 (try (items_16).toOwnedSlice(allocator));
    };

    return block_14: {
        const operand_1 = (in).steps;
        var value_3: []const u64 = value_2;

        for (operand_1) |value_4| {
            value_3 = (if ((@as(u64, (value_3).len) == @as(u64, 0))) (block_7: {
                const operand_2 = value_3;
                const operand_3 = (value_4).value;
                const operand_4 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_2).len, 1))));

                @memcpy((operand_4)[0..(operand_2).len], operand_2);

                (operand_4)[(operand_2).len] = operand_3;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create(zx_type_15));

                    (operand_5).* = @as(zx_type_15, .{
                        operand_4,
                        {},
                    });

                    break :block_6 @as(*const zx_type_15, operand_5);
                };
            }).@"0" else (block_13: {
                const operand_8 = value_3;
                const operand_9 = (value_4).value;
                const operand_10 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_8).len, 1))));

                @memcpy((operand_10)[0..(operand_8).len], operand_8);

                (operand_10)[(operand_8).len] = operand_9;

                break :block_13 block_12: {
                    const operand_11 = (try (allocator).create(zx_type_15));

                    (operand_11).* = @as(zx_type_15, .{
                        operand_10,
                        {},
                    });

                    break :block_12 @as(*const zx_type_15, operand_11);
                };
            }).@"0");
        }

        break :block_14 value_3;
    };
}
