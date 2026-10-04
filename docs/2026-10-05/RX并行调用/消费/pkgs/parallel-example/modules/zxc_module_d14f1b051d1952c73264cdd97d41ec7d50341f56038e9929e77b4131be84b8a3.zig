const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: []const u64) anyerror![]const u64 {
    @setRuntimeSafety(true);

    return block_3: {
        const operand_1 = in;
        var items_2: (std).ArrayList(u64) = .empty;

        for (operand_1) |value_1| {
            (try (items_2).append(allocator, (value_1 + @as(u64, 1))));
        }

        break :block_3 (try (items_2).toOwnedSlice(allocator));
    };
}
