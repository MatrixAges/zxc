const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_12;
pub const Output = *const (zx_abi).zx_type_13;
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .items = zx_shape_11, .threshold = zx_shape_7, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .calls = zx_shape_5, .result = zx_shape_1, .threshold = zx_shape_7, .visited = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_13 = block_46: {
        const operand_39 = true;
        const operand_40 = @as(u64, 0);

        const operand_41 = block_42: {
            break :block_42 (try (allocator).dupe(i64, (&[_]i64{})));
        };

        const operand_43 = (in).threshold;

        break :block_46 block_45: {
            const operand_44 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_44).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .result = operand_39, .calls = operand_40, .visited = operand_41, .threshold = operand_43, });

            break :block_45 @as(*const (zx_abi).zx_type_13, operand_44);
        };
    };

    return block_38: {
        const value_4: []const i64 = (in).items;

        const value_9: *const (zx_abi).zx_type_15 = block_37: {
            const operand_8 = block_7: {
                const operand_2 = value_4;
                const operand_3 = @as(u64, 0);
                const operand_4 = value_1;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_5).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_15, operand_5);
                };
            };

            var state_capacity_10: (std).ArrayList(i64) = .empty;
            var state_capacity_started_11 = false;

            defer (state_capacity_10).deinit(allocator);

            var state_1: (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((operand_8).result).calls, .result = ((operand_8).result).result, .threshold = ((operand_8).result).threshold, .visited = ((operand_8).result).visited, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_30: {
                    const value_7: i64 = block_29: {
                        const operand_27 = (state_1).source;
                        const operand_28 = (state_1).index;

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (state_1).result;

                    const value_3: i64 = block_26: {
                        break :block_26 value_7;
                    };

                    const value_8: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (if ((value_2).result) block_25: {
                        const operand_16 = (block_17: {
                            break :block_17 value_3;
                        } > (value_2).threshold);

                        const operand_18 = ((value_2).calls + @as(u64, 1));

                        const operand_19 = (block_23: {
                            const operand_20 = (value_2).visited;

                            const operand_22 = block_21: {
                                break :block_21 value_3;
                            };

                            _ = (try ((std).math).add(usize, (operand_20).len, 1));

                            if ((!state_capacity_started_11)) {
                                (try (state_capacity_10).appendSlice(allocator, operand_20));
                                state_capacity_started_11 = true;
                            } else {
                                ((state_capacity_10).items).len = (operand_20).len;
                            }

                            (try (state_capacity_10).append(allocator, operand_22));

                            break :block_23 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                        }).@"0";

                        const operand_24 = (value_2).threshold;

                        break :block_25 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_16, .calls = operand_18, .visited = operand_19, .threshold = operand_24, });
                    } else value_2);

                    break :block_30 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_8;

                        break :block_15 @as((zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_31: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_31);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).visited).len;
                state_owned_31 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((state_1).result).calls, .result = ((state_1).result).result, .threshold = ((state_1).result).threshold, .visited = state_owned_31, }), .source = (state_1).source, };
            }

            break :block_37 (if (state_changed_9) block_36: {
                break :block_36 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_35: {
                    const operand_34 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_34).* = (zx_abi).zx_type_15{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_33: {
                        const operand_32 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_32).* = (zx_abi).zx_type_13{ .calls = ((state_1).result).calls, .result = ((state_1).result).result, .threshold = ((state_1).result).threshold, .visited = ((state_1).result).visited, };

                        break :block_33 @as(*const (zx_abi).zx_type_13, operand_32);
                    }), .source = (state_1).source, };

                    break :block_35 @as(*const (zx_abi).zx_type_15, operand_34);
                });
            } else operand_8);
        };

        break :block_38 (value_9).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_85: {
        const operand_80 = true;
        const operand_81 = @as(u64, 0);

        const operand_82 = block_83: {
            break :block_83 (try (allocator).dupe(i64, (&[_]i64{})));
        };

        const operand_84 = (in).threshold;

        break :block_85 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_80, .calls = operand_81, .visited = operand_82, .threshold = operand_84, });
    };

    return block_79: {
        const value_4: []const i64 = (in).items;

        const value_9: (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = block_78: {
            const operand_53 = block_52: {
                const operand_48 = block_49: {
                    break :block_49 value_4;
                };

                const operand_50 = @as(u64, 0);
                const operand_51 = value_1;

                break :block_52 @as((zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_50, .result = operand_51, .source = operand_48, });
            };

            var state_capacity_55: (std).ArrayList(i64) = .empty;
            var state_capacity_started_56 = false;

            defer (state_capacity_55).deinit(allocator);

            var state_47: (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = operand_53;
            var state_changed_54 = false;

            while (((state_47).index < @as(u64, ((state_47).source).len))) {
                state_47 = block_75: {
                    const value_7: i64 = block_74: {
                        const operand_72 = (state_47).source;
                        const operand_73 = (state_47).index;

                        if ((operand_73 >= (operand_72).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_74 (operand_72)[@intCast(operand_73)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (state_47).result;

                    const value_3: i64 = block_71: {
                        break :block_71 value_7;
                    };

                    const value_8: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (if ((value_2).result) block_70: {
                        const operand_61 = (block_62: {
                            break :block_62 value_3;
                        } > (value_2).threshold);

                        const operand_63 = ((value_2).calls + @as(u64, 1));

                        const operand_64 = (block_68: {
                            const operand_65 = (value_2).visited;

                            const operand_67 = block_66: {
                                break :block_66 value_3;
                            };

                            _ = (try ((std).math).add(usize, (operand_65).len, 1));

                            if ((!state_capacity_started_56)) {
                                (try (state_capacity_55).appendSlice(allocator, operand_65));

                                state_capacity_started_56 = true;
                            } else {
                                ((state_capacity_55).items).len = (operand_65).len;
                            }

                            (try (state_capacity_55).append(allocator, operand_67));

                            break :block_68 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_55).items, {}, null, });
                        }).@"0";

                        const operand_69 = (value_2).threshold;

                        break :block_70 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_61, .calls = operand_63, .visited = operand_64, .threshold = operand_69, });
                    } else value_2);

                    break :block_75 block_60: {
                        const operand_57 = (state_47).source;
                        const operand_58 = ((state_47).index + @as(u64, 1));
                        const operand_59 = value_8;

                        break :block_60 @as((zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_58, .result = operand_59, .source = operand_57, });
                    };
                };

                state_changed_54 = true;
            }

            var state_owned_76: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_76);

            if (state_capacity_started_56) {
                ((state_capacity_55).items).len = (((state_47).result).visited).len;
                state_owned_76 = (try (state_capacity_55).toOwnedSlice(allocator));
            }

            if (state_capacity_started_56) {
                state_47 = (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (state_47).index, .result = @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((state_47).result).calls, .result = ((state_47).result).result, .threshold = ((state_47).result).threshold, .visited = state_owned_76, }), .source = (state_47).source, };
            }

            break :block_78 (if (state_changed_54) state_47 else operand_53);
        };

        break :block_79 (value_9).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_5: {
        const operand_1 = in;
        const operand_2 = (try function_0_value(allocator, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .items = (operand_1).items, .threshold = (operand_1).threshold, .zx_origin = operand_1, }));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_3).* = (zx_abi).zx_type_13{ .calls = (operand_2).calls, .result = (operand_2).result, .threshold = (operand_2).threshold, .visited = (operand_2).visited, };

            break :block_4 @as(*const (zx_abi).zx_type_13, operand_3);
        });
    };
}

