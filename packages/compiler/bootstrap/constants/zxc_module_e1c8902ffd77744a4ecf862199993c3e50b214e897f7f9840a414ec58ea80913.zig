const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_6896a6f6ff06025aa0a5b1bbd683e697aaec890757fbb83719139c018dd0273e) error{ OutOfMemory, }!(zx_abi).value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738 {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u32 = ((in).expected orelse (if ((in).floating) @as(u32, 9) else (if ((in).negative) @as(u32, 7) else @as(u32, 5))));

    return block_14: {
        const operand_1 = block_2: {
            break :block_2 value_1;
        };

        const operand_3 = ((block_4: {
            break :block_4 value_1;
        } == @as(u32, 8)) or (block_5: {
            break :block_5 value_1;
        } == @as(u32, 9)));

        const operand_6 = (block_7: {
            break :block_7 value_1;
        } == @as(u32, 8));

        const operand_8 = ((block_9: {
            break :block_9 value_1;
        } >= @as(u32, 2)) and (block_10: {
            break :block_10 value_1;
        } <= @as(u32, 7)));

        const operand_11 = ((block_12: {
            break :block_12 value_1;
        } == @as(u32, 6)) or (block_13: {
            break :block_13 value_1;
        } == @as(u32, 7)));

        break :block_14 @as((zx_abi).value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738, (zx_abi).value_89be0176f46a3ab196b7afa44a5ed891de3ef16b544d78aa8130f9efa84ee738{ .id = operand_1, .floating = operand_3, .single = operand_6, .integer = operand_8, .signed = operand_11, });
    };
}
