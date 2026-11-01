const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320 = block_17: {
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

            break :block_16 @as((zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5, (zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5{ .value = operand_14, .diagnostic = operand_15, });
        };
    }

    const value_2: (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d = block_9: {
        break :block_9 (try (@import("zxc_module_dfbaf7d9cab8997a34bd26274d2a2c77ed5bf0e460542234d9a1d4d2e538539b.zig")).callValue(allocator, in));
    };

    const value_3: (zx_abi).value_09f7c290d805a336be62ce78628c37e968709dcb036001e1f3ced5ffc9dd1e9d = block_8: {
        break :block_8 (try (@import("zxc_module_64840f53fc21e07f0106f83be83b50b765088ccb973cf083d03fc1b1ca99a2fc.zig")).callValue(allocator, block_7: {
            const operand_5 = in;
            const operand_6 = value_2;

            break :block_7 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .input = operand_5, .cursor = operand_6, });
        }));
    };

    const value_4: (zx_abi).value_3b2eff0839984b5ede6f18cc5949e5eb192d2442d4fdf47b18e0cb04d07508b5 = block_4: {
        break :block_4 (try (@import("zxc_module_c709420870c82d067b2b4c8408c414dc027a163ee60d396eb9223efcb3abeeb5.zig")).callValue(allocator, block_3: {
            const operand_1 = in;
            const operand_2 = value_3;

            break :block_3 @as((zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676, (zx_abi).value_dab118846854d78405efd78f2f4ea55a248887f42f904be7baaa13f179cd1676{ .input = operand_1, .cursor = operand_2, });
        }));
    };

    return value_4;
}

