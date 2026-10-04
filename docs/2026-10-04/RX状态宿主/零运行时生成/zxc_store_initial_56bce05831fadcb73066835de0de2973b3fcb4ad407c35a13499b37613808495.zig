const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = *const (zx_abi).zx_type_e4b7294bb00837f0ccc8f9e2e805afb4a133eacda3ddac3a720edd9b52763183;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) anyerror!*const (zx_abi).zx_type_e4b7294bb00837f0ccc8f9e2e805afb4a133eacda3ddac3a720edd9b52763183 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_4: {
        const operand_1 = @as([]const u8, "ready");

        break :block_4 block_3: {
            const operand_2 = (try (allocator).create((zx_abi).zx_type_e4b7294bb00837f0ccc8f9e2e805afb4a133eacda3ddac3a720edd9b52763183));

            (operand_2).* = @as((zx_abi).zx_type_e4b7294bb00837f0ccc8f9e2e805afb4a133eacda3ddac3a720edd9b52763183, (zx_abi).zx_type_e4b7294bb00837f0ccc8f9e2e805afb4a133eacda3ddac3a720edd9b52763183{ .label = operand_1, });

            break :block_3 @as(*const (zx_abi).zx_type_e4b7294bb00837f0ccc8f9e2e805afb4a133eacda3ddac3a720edd9b52763183, operand_2);
        };
    };
}

