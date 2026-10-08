const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const []const i64;
pub const Output = []const []const i64;
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
const zx_shape_13 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_12, .source = zx_shape_12, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_12;

fn function_0(allocator: ((std).mem).Allocator, in: []const []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const []const i64 {
    @setRuntimeSafety(true);

    return block_51: {
        const value_9: []const []const i64 = in;

        break :block_51 block_50: {
            const operand_7 = block_6: {
                const operand_2 = value_9;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe([]const i64, (&[_][]const i64{})));
                };

                break :block_6 (zx_abi).zx_type_15{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_7).index, .result = (operand_7).result, .source = (operand_7).source, .zx_origin = (&operand_7), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_49: {
                    const value_12: []const i64 = block_48: {
                        const operand_46 = (state_1).source;
                        const operand_47 = (state_1).index;

                        if ((operand_47 >= (operand_46).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_48 (operand_46)[@intCast(operand_47)];
                    };
                    const value_1: []const i64 = block_45: {
                        break :block_45 value_12;
                    };
                    const value_13: []const i64 = block_44: {
                        const value_3: []const i64 = block_43: {
                            break :block_43 value_1;
                        };

                        break :block_44 block_42: {
                            const operand_24 = block_23: {
                                const operand_18 = block_19: {
                                    break :block_19 value_3;
                                };
                                const operand_20 = @as(u64, 0);

                                const operand_21 = block_22: {
                                    break :block_22 (try (allocator).dupe(i64, (&[_]i64{})));
                                };

                                break :block_23 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_20, .result = operand_21, .source = operand_18, });
                            };

                            var state_capacity_25: (std).ArrayList(i64) = .empty;
                            var state_capacity_started_26 = false;

                            defer (state_capacity_25).deinit(allocator);

                            var state_17: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_24;

                            while (((state_17).index < @as(u64, ((state_17).source).len))) {
                                state_17 = block_40: {
                                    const value_6: i64 = block_39: {
                                        const operand_37 = (state_17).source;
                                        const operand_38 = (state_17).index;

                                        if ((operand_38 >= (operand_37).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_39 (operand_37)[@intCast(operand_38)];
                                    };
                                    const value_2: i64 = block_36: {
                                        break :block_36 value_6;
                                    };
                                    const value_7: i64 = (block_35: {
                                        break :block_35 value_2;
                                    } + @as(i64, 1));
                                    break :block_40 block_34: {
                                        const operand_27 = (state_17).source;
                                        const operand_28 = ((state_17).index + @as(u64, 1));

                                        const operand_29 = (block_33: {
                                            const operand_30 = (state_17).result;

                                            const operand_32 = block_31: {
                                                break :block_31 value_7;
                                            };

                                            _ = (try ((std).math).add(usize, (operand_30).len, 1));

                                            if ((!state_capacity_started_26)) {
                                                (try (state_capacity_25).appendSlice(allocator, operand_30));

                                                state_capacity_started_26 = true;
                                            } else {
                                                ((state_capacity_25).items).len = (operand_30).len;
                                            }

                                            (try (state_capacity_25).append(allocator, operand_32));

                                            break :block_33 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_25).items, {}, null, });
                                        }).@"0";

                                        break :block_34 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_28, .result = operand_29, .source = operand_27, });
                                    };
                                };
                            }

                            var state_owned_41: []const i64 = (&[_]i64{});

                            errdefer (allocator).free(state_owned_41);

                            if (state_capacity_started_26) {
                                ((state_capacity_25).items).len = ((state_17).result).len;
                                state_owned_41 = (try (state_capacity_25).toOwnedSlice(allocator));
                            }

                            if (state_capacity_started_26) {
                                state_17 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_17).index, .result = state_owned_41, .source = (state_17).source, };
                            }

                            break :block_42 (state_17).result;
                        };
                    };

                    break :block_49 block_16: {
                        const operand_8 = (state_1).source;
                        const operand_9 = ((state_1).index + @as(u64, 1));

                        const operand_10 = (block_15: {
                            const operand_11 = (state_1).result;

                            const operand_13 = block_12: {
                                break :block_12 value_13;
                            };

                            const operand_14 = (try (allocator).alloc([]const i64, (try ((std).math).add(usize, (operand_11).len, 1))));

                            @memcpy((operand_14)[0..(operand_11).len], operand_11);

                            (operand_14)[(operand_11).len] = operand_13;

                            break :block_15 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_14, {}, null, });
                        }).@"0";

                        break :block_16 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_9, .result = operand_10, .source = operand_8, });
                    };
                };
            }

            break :block_50 (state_1).result;
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const []const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try function_0(allocator, in));
}

