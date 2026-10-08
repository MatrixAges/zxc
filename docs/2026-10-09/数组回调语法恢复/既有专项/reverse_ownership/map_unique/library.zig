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

fn function_0(allocator: ((std).mem).Allocator, in: []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_33: {
        const value_2: []const i64 = in;

        break :block_33 block_32: {
            const operand_14 = block_13: {
                const operand_9 = value_2;
                const operand_10 = @as(u64, 0);

                const operand_11 = block_12: {
                    break :block_12 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_13 (zx_abi).zx_type_13{ .index = operand_10, .result = operand_11, .source = operand_9, };
            };

            var state_capacity_15: (std).ArrayList(i64) = .empty;
            var state_capacity_started_16 = false;

            defer (state_capacity_15).deinit(allocator);

            var state_8: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_14).index, .result = (operand_14).result, .source = (operand_14).source, .zx_origin = (&operand_14), };

            while (((state_8).index < @as(u64, ((state_8).source).len))) {
                state_8 = block_30: {
                    const value_5: i64 = block_29: {
                        const operand_27 = (state_8).source;
                        const operand_28 = (state_8).index;

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    };
                    const value_1: i64 = block_26: {
                        break :block_26 value_5;
                    };
                    const value_6: i64 = (block_25: {
                        break :block_25 value_1;
                    } + @as(i64, 1));

                    break :block_30 block_24: {
                        const operand_17 = (state_8).source;
                        const operand_18 = ((state_8).index + @as(u64, 1));

                        const operand_19 = (block_23: {
                            const operand_20 = (state_8).result;

                            const operand_22 = block_21: {
                                break :block_21 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_20).len, 1));

                            if ((!state_capacity_started_16)) {
                                (try (state_capacity_15).appendSlice(allocator, operand_20));
                                state_capacity_started_16 = true;
                            } else {
                                ((state_capacity_15).items).len = (operand_20).len;
                            }

                            (try (state_capacity_15).append(allocator, operand_22));

                            break :block_23 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_15).items, {}, null, });
                        }).@"0";

                        break :block_24 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_18, .result = operand_19, .source = operand_17, });
                    };
                };
            }

            var state_owned_31: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_31);

            if (state_capacity_started_16) {
                ((state_capacity_15).items).len = ((state_8).result).len;
                state_owned_31 = (try (state_capacity_15).toOwnedSlice(allocator));
            }

            if (state_capacity_started_16) {
                state_8 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_8).index, .result = state_owned_31, .source = (state_8).source, };
            }

            break :block_32 (state_8).result;
        };
    };

    return block_7: {
        const operand_1 = in;

        const operand_2 = (block_4: {
            const operand_3 = value_8;

            ((std).mem).reverse(i64, @constCast(operand_3));

            break :block_4 @as((zx_abi).zx_type_14, .{ @constCast(operand_3), {}, });
        }).@"0";

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_5).* = @as((zx_abi).zx_type_12, (zx_abi).zx_type_12{ .original = operand_1, .reversed = operand_2, });

            break :block_6 @as(*const (zx_abi).zx_type_12, operand_5);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_66: {
        const value_2: []const i64 = in;

        break :block_66 block_65: {
            const operand_47 = block_46: {
                const operand_41 = block_42: {
                    break :block_42 value_2;
                };

                const operand_43 = @as(u64, 0);

                const operand_44 = block_45: {
                    break :block_45 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_46 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_43, .result = operand_44, .source = operand_41, });
            };

            var state_capacity_48: (std).ArrayList(i64) = .empty;
            var state_capacity_started_49 = false;

            defer (state_capacity_48).deinit(allocator);

            var state_40: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_47;

            while (((state_40).index < @as(u64, ((state_40).source).len))) {
                state_40 = block_63: {
                    const value_5: i64 = block_62: {
                        const operand_60 = (state_40).source;
                        const operand_61 = (state_40).index;

                        if ((operand_61 >= (operand_60).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_62 (operand_60)[@intCast(operand_61)];
                    };
                    const value_1: i64 = block_59: {
                        break :block_59 value_5;
                    };
                    const value_6: i64 = (block_58: {
                        break :block_58 value_1;
                    } + @as(i64, 1));

                    break :block_63 block_57: {
                        const operand_50 = (state_40).source;
                        const operand_51 = ((state_40).index + @as(u64, 1));

                        const operand_52 = (block_56: {
                            const operand_53 = (state_40).result;

                            const operand_55 = block_54: {
                                break :block_54 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_53).len, 1));

                            if ((!state_capacity_started_49)) {
                                (try (state_capacity_48).appendSlice(allocator, operand_53));

                                state_capacity_started_49 = true;
                            } else {
                                ((state_capacity_48).items).len = (operand_53).len;
                            }

                            (try (state_capacity_48).append(allocator, operand_55));

                            break :block_56 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_48).items, {}, null, });
                        }).@"0";

                        break :block_57 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_51, .result = operand_52, .source = operand_50, });
                    };
                };
            }

            var state_owned_64: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_64);

            if (state_capacity_started_49) {
                ((state_capacity_48).items).len = ((state_40).result).len;
                state_owned_64 = (try (state_capacity_48).toOwnedSlice(allocator));
            }

            if (state_capacity_started_49) {
                state_40 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_40).index, .result = state_owned_64, .source = (state_40).source, };
            }

            break :block_65 (state_40).result;
        };
    };

    return block_39: {
        const operand_34 = in;

        const operand_35 = (block_38: {
            const operand_37 = block_36: {
                break :block_36 value_8;
            };

            ((std).mem).reverse(i64, @constCast(operand_37));

            break :block_38 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ @constCast(operand_37), {}, null, });
        }).@"0";

        break :block_39 @as((zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .original = operand_34, .reversed = operand_35, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_5: {
        const operand_1 = in;
        const operand_2 = (try function_0_value(allocator, operand_1));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_3).* = (zx_abi).zx_type_12{ .original = (operand_2).original, .reversed = (operand_2).reversed, };

            break :block_4 @as(*const (zx_abi).zx_type_12, operand_3);
        });
    };
}

