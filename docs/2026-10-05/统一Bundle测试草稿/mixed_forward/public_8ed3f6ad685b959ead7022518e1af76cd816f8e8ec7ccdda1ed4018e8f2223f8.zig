const std = @import("std");

const zx_abi = @import("zxc_abi");

pub const Input = *const (zx_abi).zx_type_bcc2278c84fb72dec155bb98112a73003c148de208e4ff877b335efc051a603f;

pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_bcc2278c84fb72dec155bb98112a73003c148de208e4ff877b335efc051a603f) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u64 = (try (@import("zxc_module_8e4615ae224e6af04b37e583323791ded21de2ba6a32a7a20782eb4fa4e61532")).call(allocator, in));

    return value_1;
}

