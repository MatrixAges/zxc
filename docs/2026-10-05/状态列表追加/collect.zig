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

    const value_1: []const u64 = block_20: {
        break :block_20 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_2: *const zx_type_12 = block_19: {
        const operand_15 = @as(u64, 0);
        const operand_16 = value_1;

        break :block_19 block_18: {
            const operand_17 = (try (allocator).create(zx_type_12));

            (operand_17).* = @as(zx_type_12, zx_type_12{ .count = operand_15, .values = operand_16, });

            break :block_18 @as(*const zx_type_12, operand_17);
        };
    };

    return block_14: {
        const operand_1 = in;
        const operand_2 = value_2;
        var value_3: zx_type_12 = (operand_2).*;
        var state_changed_3 = false;
        var field_items_4: (std).ArrayList(u64) = .empty;
        var field_started_5 = false;

        defer (field_items_4).deinit(allocator);

        for (operand_1) |value_4| {
            value_3 = block_11: {
                const operand_6 = ((value_3).count + @as(u64, 1));

                const operand_7 = block_10: {
                    const operand_8 = (value_3).values;
                    const operand_9 = value_4;

                    _ = (try ((std).math).add(usize, (operand_8).len, 1));

                    if ((!field_started_5)) {
                        (try (field_items_4).appendSlice(allocator, operand_8));
                        field_started_5 = true;
                    }

                    (try (field_items_4).append(allocator, operand_9));

                    break :block_10 (field_items_4).items;
                };

                break :block_11 zx_type_12{ .count = operand_6, .values = operand_7, };
            };

            state_changed_3 = true;
        }

        if (field_started_5) {
            (value_3).values = (try (field_items_4).toOwnedSlice(allocator));
        }

        break :block_14 (if (state_changed_3) block_13: {
            const operand_12 = (try (allocator).create(zx_type_12));

            (operand_12).* = @as(zx_type_12, value_3);

            break :block_13 @as(*const zx_type_12, operand_12);
        } else operand_2);
    };
}

