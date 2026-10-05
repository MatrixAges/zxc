const std = @import("std");
const zx_type_13 = struct { []const u64, void, };
pub const Input = []const []const u64;
pub const Output = []const u64;
pub const requires_io = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const []const u64) anyerror![]const u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: []const u64 = block_12: {
        break :block_12 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const value_4: []const u64 = block_11: {
        const operand_6 = in;
        const operand_7 = value_1;
        var append_items_8: (std).ArrayList(u64) = .empty;
        var append_started_9 = false;

        defer (append_items_8).deinit(allocator);

        for (operand_6) |value_3| {
            const operand_10 = value_3;

            _ = (try ((std).math).add(usize, ((if (append_started_9) (append_items_8).items else operand_7)).len, (operand_10).len));

            if ((!append_started_9)) {
                (try (append_items_8).appendSlice(allocator, operand_7));

                append_started_9 = true;
            }

            (try (append_items_8).appendSlice(allocator, operand_10));
        }

        break :block_11 (if (append_started_9) (try (append_items_8).toOwnedSlice(allocator)) else operand_7);
    };

    const tuple_1 = block_5: {
        const operand_2 = value_4;

        ((std).mem).reverse(u64, @constCast(operand_2));

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_13));

            (operand_3).* = @as(zx_type_13, .{ operand_2, {}, });

            break :block_4 @as(*const zx_type_13, operand_3);
        };
    };

    const value_5 = (tuple_1).@"0";

    return value_5;
}
