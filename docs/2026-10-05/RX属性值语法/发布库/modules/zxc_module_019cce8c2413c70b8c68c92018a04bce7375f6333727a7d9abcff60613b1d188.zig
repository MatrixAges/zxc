const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591) anyerror!*const (zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908 {
    @setRuntimeSafety(true);

    const value_1: []const u8 = (try (@import("zxc_module_b92420b2446b24cbc3123de59d39b63e2d07ce678a6fc2172eb718d4180eff42")).call(allocator, @as([]const u8, "literal $in & ctx.value")));

    const value_2: u64 = (try (@import("zxc_module_c9271cf49a5d5cea6855ac657ca347e6c171b25086575ff47f19840c1d0f783e")).call(allocator, block_18: {
        const operand_14 = (in).count;
        const operand_15 = @as(u64, 5);

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_ba25d6b49cead92d6b9fb85ed4307d538f9aa4a6f619925feefc783dbf0d547c));

            (operand_16).* = @as((zx_abi).zx_type_ba25d6b49cead92d6b9fb85ed4307d538f9aa4a6f619925feefc783dbf0d547c, (zx_abi).zx_type_ba25d6b49cead92d6b9fb85ed4307d538f9aa4a6f619925feefc783dbf0d547c{ .count = operand_14, .limit = operand_15, });

            break :block_17 @as(*const (zx_abi).zx_type_ba25d6b49cead92d6b9fb85ed4307d538f9aa4a6f619925feefc783dbf0d547c, operand_16);
        };
    }));

    return block_13: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = (((in).count < @as(u64, 10)) and true);

        const operand_4 = block_10: {
            const operand_5 = @as([]const u8, "value=");
            const operand_6 = value_2;
            const operand_7 = @as([]const u8, "; nested=");
            const operand_8 = @as([]const u8, "}");
            const operand_9 = @as([]const u8, "");

            break :block_10 (try ((std).mem).concat(allocator, u8, (&[_][]const u8{operand_5, (try ((std).fmt).allocPrint(allocator, "{d}", .{ operand_6, })), operand_7, operand_8, operand_9, })));
        };

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908));

            (operand_11).* = @as((zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908, (zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908{ .literal = operand_1, .value = operand_2, .small = operand_3, .text = operand_4, });

            break :block_12 @as(*const (zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908, operand_11);
        };
    };
}

