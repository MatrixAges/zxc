const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_c1c800954997726f4ca3de2b3e16cff16b5469a4c35d4e8a5fbc2a1f82cafd79) error{ }!(zx_abi).zx_type_be89fb2b411515188d522f46aa8e8421d3fb4c8bcc6fb127b0fb70e1a64f402e {
    @setRuntimeSafety(true);

    return (try (@import("zxc_module_95cbeec76a97291d65f33889795ab6606b1ed785867a8e05643f6a2e92135a87")).call(allocator, (try (@import("zxc_module_a9b705cba4ccfbc708476a1e82b8520cc22e737ef551a3e19489e429698328e0")).call(allocator, in))));
}

