const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = bool;
pub const Output = bool;
pub const consumes_input = false;
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
pub const input_shape = zx_shape_1;
pub const output_shape = zx_shape_1;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: bool) error{ }!bool {
    @setRuntimeSafety(true);

    _ = arena;

    return (!in);
}
