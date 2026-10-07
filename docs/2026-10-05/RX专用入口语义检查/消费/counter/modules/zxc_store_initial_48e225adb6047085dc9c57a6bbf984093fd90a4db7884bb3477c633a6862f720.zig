const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;
pub const Input = void;
pub const Output = *const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) anyerror!*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_7: {
        const operand_1 = @as(u64, 3);

        const operand_2 = block_4: {
            const operand_3 = @as(u64, 8);

            break :block_4 (try (allocator).dupe(u64, (&[_]u64{operand_3, })));
        };

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75));

            (operand_5).* = @as((zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75{ .value = operand_1, .history = operand_2, });

            break :block_6 @as(*const (zx_abi).zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75, operand_5);
        };
    };
}

