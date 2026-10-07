const std = @import("std");

const zx_type_12 = struct {
    count: u64,
    enabled: bool,
    values: []const i64,
};

const zx_type_13 = struct {
    original: []const i64,
    seen: i64,
    values: []const i64,
};

pub const Input = *const zx_type_12;
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
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_7, };
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enabled = zx_shape_1, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .seen = zx_shape_7, .values = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_8: []const i64 = block_21: {
        var state_items_8: []i64 = undefined;
        var state_items_started_9 = false;
        var state_7: []const i64 = (in).values;

        while ((block_12: {
            const operand_10 = state_7;
            const operand_11 = @as(u64, 0);

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        } < @as(i64, 64))) {
            state_7 = block_20: {
                const value_3: []const i64 = state_7;
                const value_4: u64 = @as(u64, 0);

                const value_5: i64 = block_19: {
                    const operand_17 = value_3;
                    const operand_18 = value_4;

                    if ((operand_18 >= (operand_17).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_19 (operand_17)[@intCast(operand_18)];
                };

                const value_6: i64 = @as(i64, 1);

                const value_7: []const i64 = block_16: {
                    const operand_13 = value_3;
                    const operand_14 = value_4;
                    const operand_15 = (value_5 + value_6);

                    if ((operand_14 >= (operand_13).len)) {
                        return error.IndexOutOfBounds;
                    }

                    if ((!state_items_started_9)) {
                        state_items_8 = (try (allocator).dupe(i64, operand_13));
                        state_items_started_9 = true;
                    }

                    (state_items_8)[@intCast(operand_14)] = operand_15;

                    break :block_16 state_items_8;
                };

                break :block_20 value_7;
            };
        }

        break :block_21 state_7;
    };

    return block_6: {
        const operand_1 = (in).values;
        const operand_2 = value_8;
        const operand_3 = @as(i64, 0);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_13));

            (operand_4).* = @as(zx_type_13, zx_type_13{ .original = operand_1, .values = operand_2, .seen = operand_3, });

            break :block_5 @as(*const zx_type_13, operand_4);
        };
    };
}

