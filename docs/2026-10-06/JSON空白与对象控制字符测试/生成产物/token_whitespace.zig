const std = @import("std");

const zx_type_11 = struct {
};

const zx_type_13 = struct { bool, ?bool, f64, };

const zx_type_14 = struct {
    prop2: *const zx_type_13,
    property: *const zx_type_11,
};

const value_zx_type_11_e34de937d711af43720ea9ad54cdc1a0281de003740a2e422c580f1945a76528 = struct {
    zx_origin: ?*const zx_type_11 = null,
};

const value_zx_type_13_5dbc07934ac83e2d569db25381bd4985c9c9a705f335a8a6fc414c51bd0c6d10 = struct { bool, ?bool, f64, ?*const zx_type_13, };

const value_zx_type_14_afa1e21f91fc5f195e059ec44d56336745dfc3564b5472fdc71786dfabb0fde1 = struct {
    prop2: value_zx_type_13_5dbc07934ac83e2d569db25381bd4985c9c9a705f335a8a6fc414c51bd0c6d10,
    property: value_zx_type_11_e34de937d711af43720ea9ad54cdc1a0281de003740a2e422c580f1945a76528,
    zx_origin: ?*const zx_type_14 = null,
};

pub const Input = *const zx_type_14;
pub const Output = *const zx_type_14;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ }, };
const zx_shape_12 = .{ .kind = .optional, .child = zx_shape_1, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_1, .@"1" = zx_shape_12, .@"2" = zx_shape_9, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .prop2 = zx_shape_13, .property = zx_shape_11, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_14;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_14) error{ }!*const zx_type_14 {
    @setRuntimeSafety(true);

    _ = arena;

    return in;
}

