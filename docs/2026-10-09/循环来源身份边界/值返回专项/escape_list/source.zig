const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Cell = *const (zx_abi).zx_type_11;
pub const Bundle = *const (zx_abi).zx_type_13;
pub const Input = []const u64;
pub const Output = []const *const (zx_abi).zx_type_13;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_11, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .argument = zx_shape_12, .local = zx_shape_12, }, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_15 = .{ .kind = .list, .child = zx_shape_13, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_14, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_15, .source = zx_shape_14, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_15, .@"1" = zx_shape_0, }, };
pub const input_shape = zx_shape_14;
pub const output_shape = zx_shape_15;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: u64 = (in).value;

    const value_2: *const (zx_abi).zx_type_11 = block_13: {
        const operand_10 = (value_1 + @as(u64, 1));

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_11));

            (operand_11).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_11, operand_11);
        };
    };

    return block_9: {
        const operand_1 = block_3: {
            const operand_2 = in;

            break :block_3 (try (allocator).dupe(*const (zx_abi).zx_type_11, (&[_]*const (zx_abi).zx_type_11{operand_2, })));
        };
        const operand_4 = block_6: {
            const operand_5 = value_2;

            break :block_6 (try (allocator).dupe(*const (zx_abi).zx_type_11, (&[_]*const (zx_abi).zx_type_11{operand_5, })));
        };

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .argument = operand_1, .local = operand_4, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_11) error{ OutOfMemory, }!(zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: u64 = (in).value;

    const value_2: *const (zx_abi).zx_type_11 = block_24: {
        const operand_21 = (value_1 + @as(u64, 1));

        break :block_24 block_23: {
            const operand_22 = (try (allocator).create((zx_abi).zx_type_11));

            (operand_22).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = operand_21, });

            break :block_23 @as(*const (zx_abi).zx_type_11, operand_22);
        };
    };

    return block_20: {
        const operand_14 = block_16: {
            const operand_15 = in;

            break :block_16 (try (allocator).dupe(*const (zx_abi).zx_type_11, (&[_]*const (zx_abi).zx_type_11{operand_15, })));
        };

        const operand_17 = block_19: {
            const operand_18 = value_2;

            break :block_19 (try (allocator).dupe(*const (zx_abi).zx_type_11, (&[_]*const (zx_abi).zx_type_11{operand_18, })));
        };

        break :block_20 (zx_abi).zx_type_13{ .argument = operand_14, .local = operand_17, };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) error{ IndexOutOfBounds, OutOfMemory, Overflow, }![]const *const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_68: {
        const value_10: []const u64 = in;

        break :block_68 block_67: {
            const operand_7 = block_6: {
                const operand_2 = value_10;
                const operand_3 = @as(u64, 0);

                const operand_4 = block_5: {
                    break :block_5 (try (allocator).dupe(*const (zx_abi).zx_type_13, (&[_]*const (zx_abi).zx_type_13{})));
                };

                break :block_6 (zx_abi).zx_type_17{ .index = operand_3, .result = operand_4, .source = operand_2, };
            };

            var state_capacity_8: (std).ArrayList(*const (zx_abi).zx_type_13) = .empty;
            var state_capacity_started_9 = false;

            defer (state_capacity_8).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_7).index, .result = (operand_7).result, .source = (operand_7).source, .zx_origin = (&operand_7), };

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_65: {
                    const value_13: u64 = block_64: {
                        const operand_62 = (state_1).source;
                        const operand_63 = (state_1).index;

                        if ((operand_63 >= (operand_62).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_64 (operand_62)[@intCast(operand_63)];
                    };
                    const value_1: u64 = block_61: {
                        break :block_61 value_13;
                    };
                    const value_14: *const (zx_abi).zx_type_13 = block_60: {
                        const value_4: []const u64 = block_59: {
                            const operand_58 = block_57: {
                                break :block_57 value_1;
                            };

                            break :block_59 (try (allocator).dupe(u64, (&[_]u64{operand_58, })));
                        };
                        const value_9: (zx_abi).value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_56: {
                            const operand_33 = block_32: {
                                const operand_19 = block_20: {
                                    break :block_20 value_4;
                                };
                                const operand_21 = @as(u64, 0);

                                const operand_22 = block_31: {
                                    const operand_27 = block_26: {
                                        const operand_23 = @as(u64, 0);

                                        break :block_26 block_25: {
                                            const operand_24 = (try (allocator).create((zx_abi).zx_type_11));

                                            (operand_24).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = operand_23, });

                                            break :block_25 @as(*const (zx_abi).zx_type_11, operand_24);
                                        };
                                    };

                                    const operand_28 = (try function_0_value(allocator, operand_27));

                                    break :block_31 block_30: {
                                        const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                                        (operand_29).* = @as((zx_abi).zx_type_13, operand_28);

                                        break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
                                    };
                                };

                                break :block_32 @as((zx_abi).value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_21, .result = operand_22, .source = operand_19, });
                            };

                            var state_18: (zx_abi).value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_33;
                            var state_changed_34 = false;

                            while (((state_18).index < @as(u64, ((state_18).source).len))) {
                                state_18 = block_54: {
                                    const value_7: u64 = block_53: {
                                        const operand_51 = (state_18).source;
                                        const operand_52 = (state_18).index;

                                        if ((operand_52 >= (operand_51).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_53 (operand_51)[@intCast(operand_52)];
                                    };

                                    _ = (state_18).result;

                                    const value_3: u64 = block_50: {
                                        break :block_50 value_7;
                                    };
                                    const value_8: *const (zx_abi).zx_type_13 = block_49: {
                                        const operand_45 = block_44: {
                                            const operand_40 = block_41: {
                                                break :block_41 value_3;
                                            };
                                            break :block_44 block_43: {
                                                const operand_42 = (try (allocator).create((zx_abi).zx_type_11));

                                                (operand_42).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = operand_40, });

                                                break :block_43 @as(*const (zx_abi).zx_type_11, operand_42);
                                            };
                                        };

                                        const operand_46 = (try function_0_value(allocator, operand_45));

                                        break :block_49 block_48: {
                                            const operand_47 = (try (allocator).create((zx_abi).zx_type_13));

                                            (operand_47).* = @as((zx_abi).zx_type_13, operand_46);

                                            break :block_48 @as(*const (zx_abi).zx_type_13, operand_47);
                                        };
                                    };
                                    break :block_54 block_39: {
                                        const operand_35 = (state_18).source;
                                        const operand_36 = ((state_18).index + @as(u64, 1));

                                        const operand_37 = block_38: {
                                            break :block_38 value_8;
                                        };

                                        break :block_39 @as((zx_abi).value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_36, .result = operand_37, .source = operand_35, });
                                    };
                                };

                                state_changed_34 = true;
                            }

                            break :block_56 (if (state_changed_34) state_18 else operand_33);
                        };

                        break :block_60 (value_9).result;
                    };

                    break :block_65 block_17: {
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

                            break :block_16 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_8).items, {}, null, });
                        }).@"0";

                        break :block_17 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };
            }

            var state_owned_66: []const *const (zx_abi).zx_type_13 = (&[_]*const (zx_abi).zx_type_13{});

            errdefer (allocator).free(state_owned_66);

            if (state_capacity_started_9) {
                ((state_capacity_8).items).len = ((state_1).result).len;
                state_owned_66 = (try (state_capacity_8).toOwnedSlice(allocator));
            }

            if (state_capacity_started_9) {
                state_1 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_1).index, .result = state_owned_66, .source = (state_1).source, };
            }

            break :block_67 (state_1).result;
        };
    };
}

