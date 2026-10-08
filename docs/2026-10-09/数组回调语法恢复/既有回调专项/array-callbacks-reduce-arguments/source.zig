const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_12;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .items = zx_shape_11, .seed = zx_shape_7, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_7, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_7;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!i64 {
    @setRuntimeSafety(true);

    _ = arena;

    return block_20: {
        const value_3: []const i64 = (in).items;

        break :block_20 block_19: {
            const operand_6 = block_5: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_5 (zx_abi).zx_type_13{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_6).index, .result = (operand_6).result, .source = (operand_6).source, .zx_origin = (&operand_6), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_18: {
                    const value_6: i64 = block_17: {
                        const operand_15 = (state_1).source;
                        const operand_16 = (state_1).index;

                        if ((operand_16 >= (operand_15).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_17 (operand_15)[@intCast(operand_16)];
                    };

                    const value_1: i64 = (state_1).result;

                    const value_2: i64 = block_14: {
                        break :block_14 value_6;
                    };
                    const value_7: i64 = (if (((block_12: {
                        break :block_12 value_2;
                    } > @as(i64, 10)) and (block_13: {
                        break :block_13 value_1;
                    } == @as(i64, 1)))) @as(i64, 2) else @as(i64, 0));

                    break :block_18 block_11: {
                        const operand_7 = (state_1).source;
                        const operand_8 = ((state_1).index + @as(u64, 1));

                        const operand_9 = block_10: {
                            break :block_10 value_7;
                        };

                        break :block_11 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_8, .result = operand_9, .source = operand_7, });
                    };
                };
            }

            break :block_19 (state_1).result;
        };
    };
}

