const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try (@import("zxc_module_a9b849d56ca2ae1cb70de4959687bca979b9469987cad10f199e142d15e4e4e8")).call(allocator, in));
    const value_2: u64 = (try (@import("zxc_module_8e9c90e7d865f087c5f76c3f8113084bced47ed27d563e2facdaabe742755018")).call(allocator, value_1));

    return value_2;
}
