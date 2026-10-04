const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = *const (zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void) anyerror!*const (zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    return block_4: {
        const operand_1 = @as(u64, 41);

        break :block_4 block_3: {
            const operand_2 = (try (allocator).create((zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be));

            (operand_2).* = @as((zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be, (zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be{ .value = operand_1, });

            break :block_3 @as(*const (zx_abi).zx_type_0878b70cf59049d641c11484287eed72f49a6a7e77bfa891b8d48dacd6b320be, operand_2);
        };
    };
}

