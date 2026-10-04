const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = (zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33;
pub const Output = (zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: (zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33) anyerror!(zx_abi).zx_type_1d38e4c7b5499b59c32bf0af33886ba9c55ef47b56708cb8ed3f2192a7af9f33 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try (@import("zxc_module_6b81d04a55f35d483458b3d3c7bf128e9cded3c673df9959e0f046e11f1e673d")).call(allocator, in));
}
