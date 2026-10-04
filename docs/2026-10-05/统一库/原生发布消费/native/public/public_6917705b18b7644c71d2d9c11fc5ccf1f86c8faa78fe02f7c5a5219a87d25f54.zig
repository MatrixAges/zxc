const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1;
pub const Output = (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1) anyerror!(zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try (@import("zxc_module_f996438a9670128b29be54ba0595d588345e91f3e0865d9bc4042c45dd3214cd")).call(allocator, in));
}
