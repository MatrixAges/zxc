const std = @import("std");
const zx_abi = @import("zxc_abi");

pub inline fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_0855fc0e73cc445eae5fb13ad2d0cd33dcc2ed453b67b1c6a0482cc0e669a8d3) error{ }!u64 {
    @setRuntimeSafety(true);

    return block_2: {
        const operand_1 = (in).id;

        break :block_2 switch (operand_1) { @as(u32, 2) => (try (@import("zxc_module_eae3d87550a3f0ff33ec76ee1c397a2ab37d97a66e3ff765088ca867dca70ef9.zig")).call(allocator, @as(u8, 255))), @as(u32, 3) => (try (@import("zxc_module_eeb3cdef09dce77260327a10017ea6f6959671d48c3fe8c2977db6f16976cce1.zig")).call(allocator, @as(u16, 65535))), @as(u32, 4) => (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, @as(u32, 4294967295))), @as(u32, 6) => (if ((in).negative) @as(u64, 2147483648) else @as(u64, 2147483647)), else => (if ((operand_1 == @as(u32, 7))) (if ((in).negative) @as(u64, 9223372036854775808) else @as(u64, 9223372036854775807)) else @as(u64, 18446744073709551615)), };
    };
}

