const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const []const i64;
pub const Output = []const i64;
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_7, .source = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_12, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_11;

fn function_0(allocator: ((std).mem).Allocator, in: []const []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const i64 {
    @setRuntimeSafety(true);

    return block_51: {
        const value_10: []const []const i64 = in;

        break :block_51 block_50: {
            const operand_7 = block_6: {
                const operand_2 = value_10;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_6 (zx_abi).zx_type_14{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_8: (std).ArrayList(i64) = .empty;
            var state_capacity_started_9 = false;

            defer (state_capacity_8).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_7).index, .result = (operand_7).result, .source = (operand_7).source, .zx_origin = (&operand_7), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_48: {
                    const value_13: []const i64 = block_47: {
                        const operand_45 = (state_1).source;
                        const operand_46 = (state_1).index;

                        if ((operand_46 >= (operand_45).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_47 (operand_45)[@intCast(operand_46)];
                    };
                    const value_1: []const i64 = block_44: {
                        break :block_44 value_13;
                    };
                    const value_14: i64 = (block_39: {
                        const value_4: []const i64 = block_38: {
                            break :block_38 value_1;
                        };
                        break :block_39 block_37: {
                            const operand_24 = block_23: {
                                const operand_19 = block_20: {
                                    break :block_20 value_4;
                                };
                                const operand_21 = @as(u64, 0);
                                const operand_22 = @as(i64, 0);

                                break :block_23 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_21, .result = operand_22, .source = operand_19, });
                            };

                            var state_18: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_24;

                            while (((state_18).index < @as(u64, ((state_18).source).len))) {
                                state_18 = block_36: {
                                    const value_7: i64 = block_35: {
                                        const operand_33 = (state_18).source;
                                        const operand_34 = (state_18).index;

                                        if ((operand_34 >= (operand_33).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_35 (operand_33)[@intCast(operand_34)];
                                    };

                                    const value_2: i64 = (state_18).result;

                                    const value_3: i64 = block_32: {
                                        break :block_32 value_7;
                                    };
                                    const value_8: i64 = (block_30: {
                                        break :block_30 value_2;
                                    } + block_31: {
                                        break :block_31 value_3;
                                    });

                                    break :block_36 block_29: {
                                        const operand_25 = (state_18).source;
                                        const operand_26 = ((state_18).index + @as(u64, 1));

                                        const operand_27 = block_28: {
                                            break :block_28 value_8;
                                        };

                                        break :block_29 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_26, .result = operand_27, .source = operand_25, });
                                    };
                                };
                            }

                            break :block_37 (state_18).result;
                        };
                    } + block_43: {
                        const operand_41 = block_40: {
                            break :block_40 value_1;
                        };

                        const operand_42 = @as(u64, 0);

                        if ((operand_42 >= (operand_41).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_43 (operand_41)[@intCast(operand_42)];
                    });

                    break :block_48 block_17: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));

                        const operand_12 = (block_16: {
                            const operand_13 = (state_1).result;

                            const operand_15 = block_14: {
                                break :block_14 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_13).len, 1));

                            if ((!state_capacity_started_9)) {
                                (try (state_capacity_8).ensureTotalCapacityPrecise(allocator, ((operand_7).source).len));
                                (try (state_capacity_8).appendSlice(allocator, operand_13));

                                state_capacity_started_9 = true;
                            } else {
                                ((state_capacity_8).items).len = (operand_13).len;
                            }

                            (try (state_capacity_8).append(allocator, operand_15));

                            break :block_16 @as((zx_abi).value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_8).items, {}, null, });
                        }).@"0";

                        break :block_17 @as((zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };
            }

            var state_owned_49: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_49);

            if (state_capacity_started_9) {
                ((state_capacity_8).items).len = ((state_1).result).len;
                state_owned_49 = (try (state_capacity_8).toOwnedSlice(allocator));
            }

            if (state_capacity_started_9) {
                state_1 = (zx_abi).value_zx_type_14_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_1).index, .result = state_owned_49, .source = (state_1).source, };
            }

            break :block_50 (state_1).result;
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try function_0(allocator, in));
}

