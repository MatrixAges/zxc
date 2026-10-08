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
                state_9 = block_31: {
                    const value_5: i64 = block_30: {
                        const operand_28 = (state_9).source;
                        const operand_29 = (state_9).index;

                        if ((operand_29 >= (operand_28).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_30 (operand_28)[@intCast(operand_29)];
                    };
                    const value_1: i64 = block_27: {
                        break :block_27 value_5;
                    };
                    const value_6: i64 = (block_26: {
                        break :block_26 value_1;
                    } + @as(i64, 1));

                    break :block_31 block_25: {
                        const operand_18 = (state_9).source;
                        const operand_19 = ((state_9).index + @as(u64, 1));

                        const operand_20 = (block_24: {
                            const operand_21 = (state_9).result;
                            const operand_23 = block_22: {
                                break :block_22 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_21).len, 1));

                            if ((!state_capacity_started_17)) {
                                (try (state_capacity_16).appendSlice(allocator, operand_21));

                                state_capacity_started_17 = true;
                            } else {
                                ((state_capacity_16).items).len = (operand_21).len;
                            }

                            (try (state_capacity_16).append(allocator, operand_23));

                            break :block_24 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_16).items, {}, null, });
                        }).@"0";

                        break :block_25 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_19, .result = operand_20, .source = operand_18, });
                    };
                };
            }

            var state_owned_32: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_32);

            if (state_capacity_started_17) {
                ((state_capacity_16).items).len = ((state_9).result).len;
                state_owned_32 = (try (state_capacity_16).toOwnedSlice(allocator));
            }

            if (state_capacity_started_17) {
                state_9 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_9).index, .result = state_owned_32, .source = (state_9).source, };
            }

            break :block_33 (state_9).result;
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

    const value_8: []const i64 = block_70: {
        const value_2: []const i64 = in;

        break :block_70 block_69: {
            const operand_51 = block_50: {
                const operand_45 = block_46: {
                    break :block_46 value_2;
                };

                const operand_47 = @as(u64, 0);

                const operand_48 = block_49: {
                    break :block_49 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_50 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_47, .result = operand_48, .source = operand_45, });
            };

            var state_capacity_52: (std).ArrayList(i64) = .empty;
            var state_capacity_started_53 = false;

            defer (state_capacity_52).deinit(allocator);

            var state_44: (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_51;

            while (((state_44).index < @as(u64, ((state_44).source).len))) {
                state_44 = block_67: {
                    const value_5: i64 = block_66: {
                        const operand_64 = (state_44).source;
                        const operand_65 = (state_44).index;

                        if ((operand_65 >= (operand_64).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_66 (operand_64)[@intCast(operand_65)];
                    };
                    const value_1: i64 = block_63: {
                        break :block_63 value_5;
                    };
                    const value_6: i64 = (block_62: {
                        break :block_62 value_1;
                    } + @as(i64, 1));

                    break :block_67 block_61: {
                        const operand_54 = (state_44).source;
                        const operand_55 = ((state_44).index + @as(u64, 1));

                        const operand_56 = (block_60: {
                            const operand_57 = (state_44).result;

                            const operand_59 = block_58: {
                                break :block_58 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_57).len, 1));

                            if ((!state_capacity_started_53)) {
                                (try (state_capacity_52).appendSlice(allocator, operand_57));

                                state_capacity_started_53 = true;
                            } else {
                                ((state_capacity_52).items).len = (operand_57).len;
                            }

                            (try (state_capacity_52).append(allocator, operand_59));

                            break :block_60 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_52).items, {}, null, });
                        }).@"0";

                        break :block_61 @as((zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_55, .result = operand_56, .source = operand_54, });
                    };
                };
            }

            var state_owned_68: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_68);

            if (state_capacity_started_53) {
                ((state_capacity_52).items).len = ((state_44).result).len;
                state_owned_68 = (try (state_capacity_52).toOwnedSlice(allocator));
            }

            if (state_capacity_started_53) {
                state_44 = (zx_abi).value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_44).index, .result = state_owned_68, .source = (state_44).source, };
            }

            break :block_69 (state_44).result;
        };
    };

    const value_9: []const i64 = (block_43: {
        const operand_41 = block_40: {
            break :block_40 value_8;
        };

        const operand_42 = (try (allocator).alloc(i64, (operand_41).len));

        @memcpy(operand_42, operand_41);
        ((std).mem).reverse(i64, operand_42);

        break :block_43 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_42, {}, null, });
    }).@"0";

    return block_39: {
        const operand_35 = block_36: {
            break :block_36 value_8;
        };

        const operand_37 = block_38: {
            break :block_38 value_9;
        };

        break :block_39 @as((zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .original = operand_35, .reversed = operand_37, });
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

