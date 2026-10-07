const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856;
pub const Output = *const (zx_abi).zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84;
pub const consumes_input = false;
pub const requires_io = true;
pub const requires_process = false;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_b5d35b4f5d0162d59ea62215be867c9492b7d8319f02a8a76527a1ecb419b856, io: (std).Io) anyerror!*const (zx_abi).zx_type_6271bbdace13c011cd76f816f966ba9415ef49a086a67b55b8ba6dc71859bb84 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try (@import("zxc_module_de3be42391d2428b4bac9f50059a1ce5ef5f60d721c5a1b208e32543e85caeda")).call(allocator, in, io));
}

