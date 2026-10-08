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

fn function_0_value(allocator: ((std).mem).Allocator, in: []const i64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_72: {
        const value_2: []const i64 = in;

        break :block_72 block_71: {
            const operand_52 = block_51: {
                const operand_46 = block_47: {
                    break :block_47 value_2;
                };

                const operand_48 = @as(u64, 0);

                const operand_49 = block_50: {
                    break :block_50 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_51 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_48, .result = operand_49, .source = operand_46, });
            };

            var state_capacity_53: (std).ArrayList(i64) = .empty;
            var state_capacity_started_54 = false;

            defer (state_capacity_53).deinit(allocator);

            var state_45: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_52;

            while (((state_45).index < @as(u64, ((state_45).source).len))) {
                state_45 = block_69: {
                    const value_5: i64 = block_68: {
                        const operand_66 = (state_45).source;
                        const operand_67 = (state_45).index;

                        if ((operand_67 >= (operand_66).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_68 (operand_66)[@intCast(operand_67)];
                    };
                    const value_1: i64 = block_65: {
                        break :block_65 value_5;
                    };

                    const value_6: bool = (block_64: {
                        break :block_64 value_1;
                    } > @as(i64, 0));

                    break :block_69 block_63: {
                        const operand_55 = (state_45).source;
                        const operand_56 = ((state_45).index + @as(u64, 1));

                        const operand_57 = (if (block_58: {
                            break :block_58 value_6;
                        }) (block_62: {
                            const operand_59 = (state_45).result;

                            const operand_61 = block_60: {
                                break :block_60 value_5;
                            };

                            _ = (try ((std).math).add(usize, (operand_59).len, 1));

                            if ((!state_capacity_started_54)) {
                                (try (state_capacity_53).appendSlice(allocator, operand_59));

                                state_capacity_started_54 = true;
                            } else {
                                ((state_capacity_53).items).len = (operand_59).len;
                            }

                            (try (state_capacity_53).append(allocator, operand_61));

                            break :block_62 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_53).items, {}, null, });
                        }).@"0" else (state_45).result);

                        break :block_63 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_56, .result = operand_57, .source = operand_55, });
                    };
                };
            }

            var state_owned_70: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_70);

            if (state_capacity_started_54) {
                ((state_capacity_53).items).len = ((state_45).result).len;
                state_owned_70 = (try (state_capacity_53).toOwnedSlice(allocator));
            }

            if (state_capacity_started_54) {
                state_45 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_45).index, .result = state_owned_70, .source = (state_45).source, };
            }

            break :block_71 (state_45).result;
        };
    };

    const value_9: []const i64 = (block_44: {
        const operand_42 = block_41: {
            break :block_41 value_8;
        };

        const operand_43 = (try (allocator).alloc(i64, (operand_42).len));

        @memcpy(operand_43, operand_42);
        ((std).mem).reverse(i64, operand_43);

        break :block_44 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_43, {}, null, });
    }).@"0";

    return block_40: {
        const operand_36 = block_37: {
            break :block_37 value_8;
        };
        const operand_38 = block_39: {
            break :block_39 value_9;
        };

        break :block_40 @as((zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .original = operand_36, .reversed = operand_38, });
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

