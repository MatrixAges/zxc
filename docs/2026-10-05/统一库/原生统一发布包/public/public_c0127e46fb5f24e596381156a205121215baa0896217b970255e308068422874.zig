const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1;
pub const Output = (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1) anyerror!(zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try (@import("zxc_module_3df6ecb9677ce57eb190f81407d33e7580251a6d8dc98d991a252fcab18d34cc")).call(allocator, in));
}
