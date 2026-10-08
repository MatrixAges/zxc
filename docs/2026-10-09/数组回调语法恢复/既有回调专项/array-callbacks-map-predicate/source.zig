const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const i64;
pub const Output = []const bool;
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
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_1, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_12, .source = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_12;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const bool {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_26: {
        const value_2: []const i64 = in;

        break :block_26 block_25: {
            const operand_7 = block_6: {
                const operand_2 = value_2;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(bool, (&[_]bool{})));
                };

                break :block_6 (zx_abi).zx_type_13{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_8: (std).ArrayList(bool) = .empty;
            var state_capacity_started_9 = false;

            defer (state_capacity_8).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_7).index, .result = (operand_7).result, .source = (operand_7).source, .zx_origin = (&operand_7), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_23: {
                    const value_5: i64 = block_22: {
                        const operand_20 = (state_1).source;
                        const operand_21 = (state_1).index;

                        if ((operand_21 >= (operand_20).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_22 (operand_20)[@intCast(operand_21)];
                    };
                    const value_1: i64 = block_19: {
                        break :block_19 value_5;
                    };
                    const value_6: bool = (block_18: {
                        break :block_18 value_1;
                    } > @as(i64, 10));

                    break :block_23 block_17: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));

                        const operand_12 = (block_16: {
                            const operand_13 = (state_1).result;

                            const operand_15 = block_14: {
                                break :block_14 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_13).len, 1));

                            if ((!state_capacity_started_9)) {
                                (try (state_capacity_8).appendSlice(allocator, operand_13));

                                state_capacity_started_9 = true;
                            } else {
                                ((state_capacity_8).items).len = (operand_13).len;
                            }

                            (try (state_capacity_8).append(allocator, operand_15));

                            break :block_16 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_8).items, {}, null, });
                        }).@"0";

                        break :block_17 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };
            }

            var state_owned_24: []const bool = (&[_]bool{});

            errdefer (allocator).free(state_owned_24);

            if (state_capacity_started_9) {
                ((state_capacity_8).items).len = ((state_1).result).len;
                state_owned_24 = (try (state_capacity_8).toOwnedSlice(allocator));
            }

            if (state_capacity_started_9) {
                state_1 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_1).index, .result = state_owned_24, .source = (state_1).source, };
            }

            break :block_25 (state_1).result;
        };
    };
}

