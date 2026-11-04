const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de = block_17: {
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

            break :block_16 @as((zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191, (zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191{ .value = operand_14, .diagnostic = operand_15, });
        };
    }

    const value_2: (zx_abi).value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000 = block_9: {
        break :block_9 (try (@import("zxc_module_dfbaf7d9cab8997a34bd26274d2a2c77ed5bf0e460542234d9a1d4d2e538539b.zig")).callValue(allocator, in));
    };

    const value_3: (zx_abi).value_bd11c8488411fc79a29bc272672f2513199013382497c34c01c8f5f18e855000 = block_8: {
        break :block_8 (try (@import("zxc_module_64840f53fc21e07f0106f83be83b50b765088ccb973cf083d03fc1b1ca99a2fc.zig")).callValue(allocator, block_7: {
            const operand_5 = in;
            const operand_6 = value_2;

            break :block_7 @as((zx_abi).value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1, (zx_abi).value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1{ .input = operand_5, .cursor = operand_6, });
        }));
    };

    const value_4: (zx_abi).value_642c6ad863927e4f01ec99e8a4e02008d0ac0c89888e087dcaa80fb66a73b191 = block_4: {
        break :block_4 (try (@import("zxc_module_c709420870c82d067b2b4c8408c414dc027a163ee60d396eb9223efcb3abeeb5.zig")).callValue(allocator, block_3: {
            const operand_1 = in;
            const operand_2 = value_3;

            break :block_3 @as((zx_abi).value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1, (zx_abi).value_8001ec109b97ef5381b57c1004550f1b1fccb410092a55c2918813d207399fb1{ .input = operand_1, .cursor = operand_2, });
        }));
    };

    return value_4;
}

