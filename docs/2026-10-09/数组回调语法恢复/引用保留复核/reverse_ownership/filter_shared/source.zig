const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const i64;
pub const Output = *const (zx_abi).zx_type_12;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .original = zx_shape_11, .reversed = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_11;
pub const output_shape = zx_shape_12;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_8: []const i64 = block_35: {
        const value_2: []const i64 = in;

        break :block_35 block_34: {
            const operand_15 = block_14: {
                const operand_10 = value_2;
                const operand_11 = @as(u64, 0);

                const operand_12 = block_13: {
                    break :block_13 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_14 (zx_abi).zx_type_13{ .index = operand_11, .result = operand_12, .source = operand_10, };
            };

            var state_capacity_16: (std).ArrayList(i64) = .empty;
            var state_capacity_started_17 = false;

            defer (state_capacity_16).deinit(allocator);

            var state_9: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_15).index, .result = (operand_15).result, .source = (operand_15).source, .zx_origin = (&operand_15), };

            while (((state_9).index < @as(u64, ((state_9).source).len))) {
                state_9 = block_32: {
                    const value_5: i64 = block_31: {
                        const operand_29 = (state_9).source;
                        const operand_30 = (state_9).index;

                        if ((operand_30 >= (operand_29).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_31 (operand_29)[@intCast(operand_30)];
                    };
                    const value_1: i64 = block_28: {
                        break :block_28 value_5;
                    };

                    const value_6: bool = (block_27: {
                        break :block_27 value_1;
                    } > @as(i64, 0));

                    break :block_32 block_26: {
                        const operand_18 = (state_9).source;
                        const operand_19 = ((state_9).index + @as(u64, 1));

                        const operand_20 = (if (block_21: {
                            break :block_21 value_6;
                        }) (block_25: {
                            const operand_22 = (state_9).result;

                            const operand_24 = block_23: {
                                break :block_23 value_5;
                            };

                            _ = (try ((std).math).add(usize, (operand_22).len, 1));

                            if ((!state_capacity_started_17)) {
                                (try (state_capacity_16).appendSlice(allocator, operand_22));

                                state_capacity_started_17 = true;
                            } else {
                                ((state_capacity_16).items).len = (operand_22).len;
                            }

                            (try (state_capacity_16).append(allocator, operand_24));

                            break :block_25 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_16).items, {}, null, });
                        }).@"0" else (state_9).result);

                        break :block_26 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_19, .result = operand_20, .source = operand_18, });
                    };
                };
            }

            var state_owned_33: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_33);

            if (state_capacity_started_17) {
                ((state_capacity_16).items).len = ((state_9).result).len;
                state_owned_33 = (try (state_capacity_16).toOwnedSlice(allocator));
            }

            if (state_capacity_started_17) {
                state_9 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_9).index, .result = state_owned_33, .source = (state_9).source, };
            }

            break :block_34 (state_9).result;
        };
    };

    const value_9: []const i64 = (block_8: {
        const operand_6 = value_8;
        const operand_7 = (try (allocator).alloc(i64, (operand_6).len));

        @memcpy(operand_7, operand_6);

        ((std).mem).reverse(i64, operand_7);

        break :block_8 @as((zx_abi).zx_type_14, .{ operand_7, {}, });
    }).@"0";

    return block_5: {
        const operand_1 = value_8;
        const operand_2 = value_9;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_3).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .original = operand_1, .reversed = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_12, operand_3);
        };
    };
}

