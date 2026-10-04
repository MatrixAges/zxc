const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const zx_pending = struct {
    store_0: ?*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75,
};

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_67bc92ed327fc0c823c4ea742da3bee0276b90de507bd92451d79b40ca26e049, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending = zx_pending{ .store_0 = null, };

    const value_1: *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 = block_8: {
        const operand_2 = ((in).first + (in).increment);
        const operand_3 = block_5: {
            const operand_4 = (in).second;

            break :block_5 (try (allocator).dupe(u64, (&[_]u64{operand_4, })));
        };

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75));

            (operand_6).* = @as((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75{ .value = operand_2, .history = operand_3, });

            break :block_7 @as(*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, operand_6);
        };
    };

    (pending).store_0 = value_1;

    const output_1 = (value_1).value;

    (try (context).commit(pending));

    return output_1;
}

