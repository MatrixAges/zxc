const std = @import("std");
const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_910579f19903a37694078f81c74c2225ba7dfdfaf3351126312081b3a22a44b9, context: anytype) anyerror!*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 {
    @setRuntimeSafety(true);

    var pending: zx_pending = zx_pending{ .store_0 = null, };

    const value_2: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = block_14: {
        const operand_7 = (((in).state).value + (in).increment);

        const operand_8 = block_11: {
            const operand_9 = ((in).state).history;
            var items_10: (std).ArrayList(u64) = .empty;

            for (operand_9) |value_1| {
                (try (items_10).append(allocator, (value_1 + @as(u64, 1))));
            }

            break :block_11 (try (items_10).toOwnedSlice(allocator));
        };

        break :block_14 block_13: {
            const operand_12 = (try (allocator).create((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75));

            (operand_12).* = @as((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75{ .value = operand_7, .history = operand_8, });

            break :block_13 @as(*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, operand_12);
        };
    };

    (pending).store_0 = value_2;

    const value_3: []const *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = block_6: {
        const operand_5 = value_2;

        break :block_6 (try (allocator).dupe(*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, (&[_]*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75{operand_5, })));
    };

    const output_4 = block_3: {
        const operand_1 = value_3;
        const operand_2 = (in).increment;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };

    (try (context).commit(pending));

    return output_4;
}

