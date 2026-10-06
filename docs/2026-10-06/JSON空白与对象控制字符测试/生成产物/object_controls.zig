const std = @import("std");

const zx_type_11 = struct {
    name: []const u8,
};

const value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    name: []const u8,
    zx_origin: ?*const zx_type_11 = null,
};

pub const Input = *const zx_type_11;
pub const Output = *const zx_type_11;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .name = zx_shape_10, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_11;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11) error{ }!*const zx_type_11 {
    @setRuntimeSafety(true);

    _ = arena;

    return in;
}

