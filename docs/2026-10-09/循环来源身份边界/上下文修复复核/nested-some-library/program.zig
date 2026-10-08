const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521;
pub const Output = bool;
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .active = zx_shape_1, .left = zx_shape_11, .right = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_7, .@"1" = zx_shape_12, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .context = zx_shape_12, .items = zx_shape_11, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .captures = zx_shape_15, .index = zx_shape_5, .result = zx_shape_1, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_1;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_a409fb6a474bef285a9ef3f44949f8e8ae1373bd561896192b55b86135166521) error{ IndexOutOfBounds, NativeFailure, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try (@import("zxc_module_047cdcb12ed82cf199194cf206262d164431c608eb4b3f970a3ad875d7f1337d")).call(allocator, in));
}

