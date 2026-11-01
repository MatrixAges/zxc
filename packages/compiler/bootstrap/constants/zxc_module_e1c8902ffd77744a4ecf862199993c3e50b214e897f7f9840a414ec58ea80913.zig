const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_14e4e20a7eaf52d62a05f5e3274156a4a5e995de1cbdb7488cfe2fb12943bc46) error{ OutOfMemory, }!(zx_abi).value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u32 = @as(u32, 5);
    const value_2: u32 = @as(u32, 7);
    const value_3: u32 = @as(u32, 9);

    const value_4: u32 = ((in).expected orelse (if ((in).floating) block_17: {
        break :block_17 value_3;
    } else (if ((in).negative) block_16: {
        break :block_16 value_2;
    } else block_15: {
        break :block_15 value_1;
    })));

    return block_14: {
        const operand_1 = block_2: {
            break :block_2 value_4;
        };

        const operand_3 = ((block_4: {
            break :block_4 value_4;
        } == @as(u32, 8)) or (block_5: {
            break :block_5 value_4;
        } == @as(u32, 9)));

        const operand_6 = (block_7: {
            break :block_7 value_4;
        } == @as(u32, 8));

        const operand_8 = ((block_9: {
            break :block_9 value_4;
        } >= @as(u32, 2)) and (block_10: {
            break :block_10 value_4;
        } <= @as(u32, 7)));

        const operand_11 = ((block_12: {
            break :block_12 value_4;
        } == @as(u32, 6)) or (block_13: {
            break :block_13 value_4;
        } == @as(u32, 7)));

        break :block_14 @as((zx_abi).value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb, (zx_abi).value_f6e1d61fd0de079af5f3bb4cf7ee3bfacbdf108d746eea9fc680af12c11286fb{ .id = operand_1, .floating = operand_3, .single = operand_6, .integer = operand_8, .signed = operand_11, });
    };
}

