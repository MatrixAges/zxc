const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: (zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1) anyerror!(zx_abi).zx_type_aa0a3a2a836a7fdeff89f375361b152a8e53771229cd93af6f04ec3aab6155d1 {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_3757bf87093fc7ec87a65d5c6178e5a5bedab4c62bcf9e123da641dbb23ad166")).call(allocator, (try (@import("zxc_module_3df6ecb9677ce57eb190f81407d33e7580251a6d8dc98d991a252fcab18d34cc")).call(allocator, in))));
}
