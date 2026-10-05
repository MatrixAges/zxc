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

    return block_3: {
        const operand_1 = in;
        var items_2: (std).ArrayList(f64) = .empty;

        for (operand_1) |value_1| {
            (try (items_2).append(allocator, ((value_1 * value_1) + value_1)));
        }

        break :block_3 (try (items_2).toOwnedSlice(allocator));
    };
}

