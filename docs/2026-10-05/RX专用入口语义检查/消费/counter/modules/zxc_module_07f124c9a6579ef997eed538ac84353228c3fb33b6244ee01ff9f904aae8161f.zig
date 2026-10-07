const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending = zx_pending{ .store_0 = null, };

    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = block_10: {
        const operand_2 = (in).state;
        const operand_3 = (((in).state).value + (in).increment);

        const operand_4 = block_7: {
            const operand_5 = ((in).state).history;
            var items_6: (std).ArrayList(u64) = .empty;

            for (operand_5) |value_1| {
                (try (items_6).append(allocator, (value_1 + @as(u64, 1))));
            }

            break :block_7 (try (items_6).toOwnedSlice(allocator));
        };

        _ = operand_2;

        break :block_10 block_9: {
            const operand_8 = (try (allocator).create((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75));

            (operand_8).* = @as((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75{ .history = operand_4, .value = operand_3, });

            break :block_9 @as(*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, operand_8);
        };
    };

    (pending).store_0 = value_2;
    const output_1 = (value_2).value;

    (try (context).commit(pending));

    return output_1;
}

