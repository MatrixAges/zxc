const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;
pub const Output = *const (zx_abi).zx_type_1cedc4c1a5238eebf4e2d159a0c783898b30c94e7e0b2fd716e9be5f5a37e159;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3) anyerror!*const (zx_abi).zx_type_1cedc4c1a5238eebf4e2d159a0c783898b30c94e7e0b2fd716e9be5f5a37e159 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_5: {
        const operand_1 = (try (@import("zxc_module_7e011b0a6525d536552951d85193598426f9cf891aadc63eb59e0ef4b0b68224")).call(allocator, in));
        const operand_2 = (try (@import("zxc_module_85d43cc1a2631b01c906fc1f34d643d7d592b7429f984c368ec43b1efd6fb967")).call(allocator, in));

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_1cedc4c1a5238eebf4e2d159a0c783898b30c94e7e0b2fd716e9be5f5a37e159));

            (operand_3).* = @as((zx_abi).zx_type_1cedc4c1a5238eebf4e2d159a0c783898b30c94e7e0b2fd716e9be5f5a37e159, (zx_abi).zx_type_1cedc4c1a5238eebf4e2d159a0c783898b30c94e7e0b2fd716e9be5f5a37e159{ .selected = operand_1, .original = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_1cedc4c1a5238eebf4e2d159a0c783898b30c94e7e0b2fd716e9be5f5a37e159, operand_3);
        };
    };
}
