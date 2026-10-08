const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_13;
pub const Output = i64;
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
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .items = zx_shape_12, .seed = zx_shape_7, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_7, .source = zx_shape_12, }, };
pub const input_shape = zx_shape_13;
pub const output_shape = zx_shape_7;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_13) error{ IndexOutOfBounds, OutOfMemory, }!i64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_23: {
        const value_3: []const []const i64 = (in).items;

        break :block_23 block_22: {
            const operand_6 = block_5: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_5 (zx_abi).zx_type_14{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_6).index, .result = (operand_6).result, .source = (operand_6).source, .zx_origin = (&operand_6), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_21: {
                    const value_6: []const i64 = block_20: {
                        const operand_18 = (state_1).source;
                        const operand_19 = (state_1).index;

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };

                    const value_1: i64 = (state_1).result;

                    const value_2: []const i64 = block_17: {
                        break :block_17 value_6;
                    };
                    const value_7: i64 = (block_12: {
                        break :block_12 value_1;
                    } + block_16: {
                        const operand_14 = block_13: {
                            break :block_13 value_2;
                        };

                        const operand_15 = @as(u64, 0);

                        if ((operand_15 >= (operand_14).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_16 (operand_14)[@intCast(operand_15)];
                    });

                    break :block_21 block_11: {
                        const operand_7 = (state_1).source;
                        const operand_8 = ((state_1).index + @as(u64, 1));

                        const operand_9 = block_10: {
                            break :block_10 value_7;
                        };

                        break :block_11 @as((zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_8, .result = operand_9, .source = operand_7, });
                    };
                };
            }

            break :block_22 (state_1).result;
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_13) error{ IndexOutOfBounds, OutOfMemory, }!i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try function_0(allocator, in));
}

