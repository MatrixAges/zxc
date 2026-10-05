const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const f64;
pub const Output = []const f64;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_9, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_11;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const f64) anyerror![]const f64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_9: {
        const operand_1 = in;
        const operand_2 = (try (allocator).alloc(f64, (operand_1).len));
        const operand_3 = (comptime (((std).simd).suggestVectorLength(f64) orelse 1));
        const operand_4 = ((operand_1).len / operand_3);

        for (0..operand_4) |chunk_5| {
            const operand_6 = (chunk_5 * operand_3);

            (((operand_2)[operand_6..])[0..operand_3]).* = ((@as(@Vector(operand_3, f64), (((operand_1)[operand_6..])[0..operand_3]).*) * @as(@Vector(operand_3, f64), (((operand_1)[operand_6..])[0..operand_3]).*)) + @as(@Vector(operand_3, f64), (((operand_1)[operand_6..])[0..operand_3]).*));
        }

        const operand_7 = (operand_4 * operand_3);

        for ((operand_1)[operand_7..], 0..) |value_1, index_8| {
            (operand_2)[(operand_7 + index_8)] = ((value_1 * value_1) + value_1);
        }

        break :block_9 operand_2;
    };
}

