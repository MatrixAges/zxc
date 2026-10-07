const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591;
pub const Output = *const (zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591) anyerror!*const (zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: *const (zx_abi).zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908 = (try (@import("zxc_module_019cce8c2413c70b8c68c92018a04bce7375f6333727a7d9abcff60613b1d188")).call(allocator, in));

    return value_1;
}

