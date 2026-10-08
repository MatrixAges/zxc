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

    return block_53: {
        const value_9: []const []const i64 = in;

        break :block_53 block_52: {
            const operand_7 = block_6: {
                const operand_2 = value_9;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe([]const i64, (&[_][]const i64{})));
                };

                break :block_6 (zx_abi).zx_type_15{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_8: (std).ArrayList([]const i64) = .empty;
            var state_capacity_started_9 = false;

            defer (state_capacity_8).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_7).index, .result = (operand_7).result, .source = (operand_7).source, .zx_origin = (&operand_7), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_50: {
                    const value_12: []const i64 = block_49: {
                        const operand_47 = (state_1).source;
                        const operand_48 = (state_1).index;

                        if ((operand_48 >= (operand_47).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_49 (operand_47)[@intCast(operand_48)];
                    };
                    const value_1: []const i64 = block_46: {
                        break :block_46 value_12;
                    };
                    const value_13: []const i64 = block_45: {
                        const value_3: []const i64 = block_44: {
                            break :block_44 value_1;
                        };
                        break :block_45 block_43: {
                            const operand_25 = block_24: {
                                const operand_19 = block_20: {
                                    break :block_20 value_3;
                                };
                                const operand_21 = @as(u64, 0);

                                const operand_22 = block_23: {
                                    break :block_23 (try (allocator).dupe(i64, (&[_]i64{})));
                                };

                                break :block_24 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_21, .result = operand_22, .source = operand_19, });
                            };

                            var state_capacity_26: (std).ArrayList(i64) = .empty;
                            var state_capacity_started_27 = false;

                            defer (state_capacity_26).deinit(allocator);

                            var state_18: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_25;

                            while (((state_18).index < @as(u64, ((state_18).source).len))) {
                                state_18 = block_41: {
                                    const value_6: i64 = block_40: {
                                        const operand_38 = (state_18).source;
                                        const operand_39 = (state_18).index;

                                        if ((operand_39 >= (operand_38).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_40 (operand_38)[@intCast(operand_39)];
                                    };
                                    const value_2: i64 = block_37: {
                                        break :block_37 value_6;
                                    };
                                    const value_7: i64 = (block_36: {
                                        break :block_36 value_2;
                                    } + @as(i64, 1));
                                    break :block_41 block_35: {
                                        const operand_28 = (state_18).source;
                                        const operand_29 = ((state_18).index + @as(u64, 1));

                                        const operand_30 = (block_34: {
                                            const operand_31 = (state_18).result;

                                            const operand_33 = block_32: {
                                                break :block_32 value_7;
                                            };

                                            _ = (try ((std).math).add(usize, (operand_31).len, 1));

                                            if ((!state_capacity_started_27)) {
                                                (try (state_capacity_26).ensureTotalCapacityPrecise(allocator, ((operand_25).source).len));
                                                (try (state_capacity_26).appendSlice(allocator, operand_31));

                                                state_capacity_started_27 = true;
                                            } else {
                                                ((state_capacity_26).items).len = (operand_31).len;
                                            }

                                            (try (state_capacity_26).append(allocator, operand_33));

                                            break :block_34 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_26).items, {}, null, });
                                        }).@"0";

                                        break :block_35 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_29, .result = operand_30, .source = operand_28, });
                                    };
                                };
                            }

                            var state_owned_42: []const i64 = (&[_]i64{});

                            errdefer (allocator).free(state_owned_42);

                            if (state_capacity_started_27) {
                                ((state_capacity_26).items).len = ((state_18).result).len;
                                state_owned_42 = (try (state_capacity_26).toOwnedSlice(allocator));
                            }

                            if (state_capacity_started_27) {
                                state_18 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_18).index, .result = state_owned_42, .source = (state_18).source, };
                            }

                            break :block_43 (state_18).result;
                        };
                    };

                    break :block_50 block_17: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));

                        const operand_12 = (block_16: {
                            const operand_13 = (state_1).result;

                            const operand_15 = block_14: {
                                break :block_14 value_13;
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

                            break :block_16 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_8).items, {}, null, });
                        }).@"0";

                        break :block_17 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };
            }

            var state_owned_51: []const []const i64 = (&[_][]const i64{});

            errdefer (allocator).free(state_owned_51);

            if (state_capacity_started_9) {
                ((state_capacity_8).items).len = ((state_1).result).len;
                state_owned_51 = (try (state_capacity_8).toOwnedSlice(allocator));
            }

            if (state_capacity_started_9) {
                state_1 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_1).index, .result = state_owned_51, .source = (state_1).source, };
            }

            break :block_52 (state_1).result;
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const []const i64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return (try function_0(allocator, in));
}

