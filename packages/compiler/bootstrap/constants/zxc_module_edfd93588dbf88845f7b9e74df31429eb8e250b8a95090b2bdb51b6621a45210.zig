const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808 = block_17: {
        break :block_17 (try (@import("zxc_module_486d7d9579c4ea063532bce0cb7bc0eb3011a0db52b368e45c99ad500bde7de4.zig")).callValue(allocator, in));
    };

    const switch_10 = (!block_13: {
        const operand_11 = (value_1).message;
        const operand_12 = @as([]const u8, "");

        break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
    });

    if ((switch_10 == true)) {
        return block_16: {
            const operand_14 = @as(?*const (zx_abi).zx_type_308af60039628ab4f4c6af8f1a9f436729424c0f23744dd60fe8973cd7a15dc6, null);
            const operand_15 = value_1;

            break :block_16 @as((zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4, (zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4{ .value = operand_14, .diagnostic = operand_15, });
        };
    }

    const value_2: (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3 = block_9: {
        break :block_9 (try (@import("zxc_module_dfbaf7d9cab8997a34bd26274d2a2c77ed5bf0e460542234d9a1d4d2e538539b.zig")).callValue(allocator, in));
    };

    const value_3: (zx_abi).value_3faf35ca62c26491ff01a804e4a5bb6666a95c6a1e7033348a49b71c2c1463d3 = block_8: {
        break :block_8 (try (@import("zxc_module_64840f53fc21e07f0106f83be83b50b765088ccb973cf083d03fc1b1ca99a2fc.zig")).callValue(allocator, block_7: {
            const operand_5 = in;
            const operand_6 = value_2;

            break :block_7 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .input = operand_5, .cursor = operand_6, });
        }));
    };

    const value_4: (zx_abi).value_9f547a5bcbd2d2a08dcff17874a209d6ef606146a771bf27bd95cae4331964c4 = block_4: {
        break :block_4 (try (@import("zxc_module_c709420870c82d067b2b4c8408c414dc027a163ee60d396eb9223efcb3abeeb5.zig")).callValue(allocator, block_3: {
            const operand_1 = in;
            const operand_2 = value_3;

            break :block_3 @as((zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7, (zx_abi).value_be3438cd8468068650625c09491e54db28baf0251ba1d37f3c00a8e8d2f371a7{ .input = operand_1, .cursor = operand_2, });
        }));
    };

    return value_4;
}

