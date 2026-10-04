const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f86e56b78eea6a0dc7898a4f94cce013b89702363b182adc92582f715440faa6, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending = zx_pending{ .store_0 = null, };

    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = block_13: {
        const operand_5 = (in).state;
        const operand_6 = (((in).state).value + (in).increment);

        const operand_7 = block_10: {
            const operand_8 = ((in).state).history;
            var items_9: (std).ArrayList(u64) = .empty;

            for (operand_8) |value_1| {
                (try (items_9).append(allocator, (value_1 + @as(u64, 1))));
            }

            break :block_10 (try (items_9).toOwnedSlice(allocator));
        };

        _ = operand_5;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75));

            (operand_11).* = @as((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75{ .history = operand_7, .value = operand_6, });

            break :block_12 @as(*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, operand_11);
        };
    };

    (pending).store_0 = value_2;

    const output_4 = block_3: {
        const operand_1 = (value_2).history;
        const operand_2 = (in).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };

    (try (context).commit(pending));

    return output_4;
}
