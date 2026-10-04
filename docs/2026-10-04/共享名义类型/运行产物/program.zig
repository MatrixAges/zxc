const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = (zx_abi).zx_type_11;

pub const zx_context = struct {
    context_0: *const (zx_abi).zx_type_12,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void, context: anytype) anyerror!(zx_abi).zx_type_11 {
    @setRuntimeSafety(true);

    _ = arena;
    _ = in;

    return (@as(*const (zx_abi).zx_type_12, (context).context_0)).mode;
}
