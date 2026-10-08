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

    const value_8: []const i64 = block_34: {
        const value_2: []const i64 = in;

        break :block_34 block_33: {
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
                state_8 = block_31: {
                    const value_5: i64 = block_30: {
                        const operand_28 = (state_8).source;
                        const operand_29 = (state_8).index;

                        if ((operand_29 >= (operand_28).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_30 (operand_28)[@intCast(operand_29)];
                    };
                    const value_1: i64 = block_27: {
                        break :block_27 value_5;
                    };
                    const value_6: bool = (block_26: {
                        break :block_26 value_1;
                    } > @as(i64, 0));

                    break :block_31 block_25: {
                        const operand_17 = (state_8).source;
                        const operand_18 = ((state_8).index + @as(u64, 1));

                        const operand_19 = (if (block_20: {
                            break :block_20 value_6;
                        }) (block_24: {
                            const operand_21 = (state_8).result;

                            const operand_23 = block_22: {
                                break :block_22 value_5;
                            };

                            _ = (try ((std).math).add(usize, (operand_21).len, 1));

                            if ((!state_capacity_started_16)) {
                                (try (state_capacity_15).appendSlice(allocator, operand_21));
                                state_capacity_started_16 = true;
                            } else {
                                ((state_capacity_15).items).len = (operand_21).len;
                            }

                            (try (state_capacity_15).append(allocator, operand_23));

                            break :block_24 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_15).items, {}, null, });
                        }).@"0" else (state_8).result);

                        break :block_25 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_18, .result = operand_19, .source = operand_17, });
                    };
                };
            }

            var state_owned_32: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_32);

            if (state_capacity_started_16) {
                ((state_capacity_15).items).len = ((state_8).result).len;
                state_owned_32 = (try (state_capacity_15).toOwnedSlice(allocator));
            }

            if (state_capacity_started_16) {
                state_8 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_8).index, .result = state_owned_32, .source = (state_8).source, };
            }

            break :block_33 (state_8).result;
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

    const value_8: []const i64 = block_68: {
        const value_2: []const i64 = in;

        break :block_68 block_67: {
            const operand_48 = block_47: {
                const operand_42 = block_43: {
                    break :block_43 value_2;
                };

                const operand_44 = @as(u64, 0);

                const operand_45 = block_46: {
                    break :block_46 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_47 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_44, .result = operand_45, .source = operand_42, });
            };

            var state_capacity_49: (std).ArrayList(i64) = .empty;
            var state_capacity_started_50 = false;

            defer (state_capacity_49).deinit(allocator);

            var state_41: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_48;

            while (((state_41).index < @as(u64, ((state_41).source).len))) {
                state_41 = block_65: {
                    const value_5: i64 = block_64: {
                        const operand_62 = (state_41).source;
                        const operand_63 = (state_41).index;

                        if ((operand_63 >= (operand_62).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_64 (operand_62)[@intCast(operand_63)];
                    };
                    const value_1: i64 = block_61: {
                        break :block_61 value_5;
                    };
                    const value_6: bool = (block_60: {
                        break :block_60 value_1;
                    } > @as(i64, 0));

                    break :block_65 block_59: {
                        const operand_51 = (state_41).source;
                        const operand_52 = ((state_41).index + @as(u64, 1));

                        const operand_53 = (if (block_54: {
                            break :block_54 value_6;
                        }) (block_58: {
                            const operand_55 = (state_41).result;

                            const operand_57 = block_56: {
                                break :block_56 value_5;
                            };

                            _ = (try ((std).math).add(usize, (operand_55).len, 1));

                            if ((!state_capacity_started_50)) {
                                (try (state_capacity_49).appendSlice(allocator, operand_55));

                                state_capacity_started_50 = true;
                            } else {
                                ((state_capacity_49).items).len = (operand_55).len;
                            }

                            (try (state_capacity_49).append(allocator, operand_57));

                            break :block_58 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_49).items, {}, null, });
                        }).@"0" else (state_41).result);

                        break :block_59 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_52, .result = operand_53, .source = operand_51, });
                    };
                };
            }

            var state_owned_66: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_66);

            if (state_capacity_started_50) {
                ((state_capacity_49).items).len = ((state_41).result).len;
                state_owned_66 = (try (state_capacity_49).toOwnedSlice(allocator));
            }

            if (state_capacity_started_50) {
                state_41 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_41).index, .result = state_owned_66, .source = (state_41).source, };
            }

            break :block_67 (state_41).result;
        };
    };

    return block_40: {
        const operand_35 = in;

        const operand_36 = (block_39: {
            const operand_38 = block_37: {
                break :block_37 value_8;
            };

            ((std).mem).reverse(i64, @constCast(operand_38));

            break :block_39 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ @constCast(operand_38), {}, null, });
        }).@"0";

        break :block_40 @as((zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .original = operand_35, .reversed = operand_36, });
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

