const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const u8;
pub const Output = void;
pub const consumes_input = false;
pub const requires_io = true;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u8, io: (std).Io) anyerror!void {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = (try (@import("zxc_module_2bb5f38081ced26c69680c53438a65891c7046ed50660d84961bc392964e31ea")).call(allocator, in, io));
    _ = (try (@import("zxc_module_2bb5f38081ced26c69680c53438a65891c7046ed50660d84961bc392964e31ea")).call(allocator, in, io));
    _ = (try (@import("zxc_module_d93132c09e25e34bbf9a89283296d0e7c07e1fe4b0f25356a2a986c6b2b5efc0")).call(allocator, in, io));

    return;
}

