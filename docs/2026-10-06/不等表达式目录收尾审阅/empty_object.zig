const std = @import("std");

const zx_type_11 = struct {
};

const zx_type_13 = struct {
    left_different: bool,
    right_different: bool,
};

const value_zx_type_11_e34de937d711af43720ea9ad54cdc1a0281de003740a2e422c580f1945a76528 = struct {
    zx_origin: ?*const zx_type_11 = null,
};

const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left_different: bool,
    right_different: bool,
    zx_origin: ?*const zx_type_13 = null,
};

pub const Value = *const zx_type_11;
pub const Input = ?*const zx_type_11;
pub const Output = *const zx_type_13;
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
const zx_shape_12 = .{ .kind = .optional, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .left_different = zx_shape_1, .right_different = zx_shape_1, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: ?*const zx_type_11) error{ OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_5: {
        const operand_1 = (null != in);
        const operand_2 = (in != null);

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_13));
            (operand_3).* = @as(zx_type_13, zx_type_13{ .left_different = operand_1, .right_different = operand_2, });

            break :block_4 @as(*const zx_type_13, operand_3);
        };
    };
}

