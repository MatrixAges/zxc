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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .items = zx_shape_11, .limit = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .calls = zx_shape_5, .limit = zx_shape_5, .result = zx_shape_1, .visited = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_11, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_13 = block_45: {
        const operand_38 = true;
        const operand_39 = @as(u64, 0);

        const operand_40 = block_41: {
            break :block_41 (try (allocator).dupe(i64, (&[_]i64{})));
        };

        const operand_42 = (in).limit;

        break :block_45 block_44: {
            const operand_43 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_43).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .result = operand_38, .calls = operand_39, .visited = operand_40, .limit = operand_42, });

            break :block_44 @as(*const (zx_abi).zx_type_13, operand_43);
        };
    };

    return block_37: {
        const value_4: []const i64 = (in).items;

        const value_9: *const (zx_abi).zx_type_15 = block_36: {
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

            var state_1: (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((operand_8).result).calls, .limit = ((operand_8).result).limit, .result = ((operand_8).result).result, .visited = ((operand_8).result).visited, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_29: {
                    const value_7: i64 = block_28: {
                        const operand_26 = (state_1).source;
                        const operand_27 = (state_1).index;

                        if ((operand_27 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_28 (operand_26)[@intCast(operand_27)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (state_1).result;

                    const value_3: i64 = block_25: {
                        break :block_25 value_7;
                    };

                    const value_8: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (if ((value_2).result) block_24: {
                        const operand_16 = ((value_2).calls <= (value_2).limit);
                        const operand_17 = ((value_2).calls + @as(u64, 1));

                        const operand_18 = (block_22: {
                            const operand_19 = (value_2).visited;

                            const operand_21 = block_20: {
                                break :block_20 value_3;
                            };

                            _ = (try ((std).math).add(usize, (operand_19).len, 1));

                            if ((!state_capacity_started_11)) {
                                (try (state_capacity_10).appendSlice(allocator, operand_19));
                                state_capacity_started_11 = true;
                            } else {
                                ((state_capacity_10).items).len = (operand_19).len;
                            }

                            (try (state_capacity_10).append(allocator, operand_21));

                            break :block_22 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_10).items, {}, null, });
                        }).@"0";

                        const operand_23 = (value_2).limit;

                        break :block_24 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_16, .calls = operand_17, .visited = operand_18, .limit = operand_23, });
                    } else value_2);

                    break :block_29 block_15: {
                        const operand_12 = (state_1).source;
                        const operand_13 = ((state_1).index + @as(u64, 1));
                        const operand_14 = value_8;

                        break :block_15 @as((zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_13, .result = operand_14, .source = operand_12, });
                    };
                };

                state_changed_9 = true;
            }

            var state_owned_30: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_30);

            if (state_capacity_started_11) {
                ((state_capacity_10).items).len = (((state_1).result).visited).len;
                state_owned_30 = (try (state_capacity_10).toOwnedSlice(allocator));
            }

            if (state_capacity_started_11) {
                state_1 = (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (state_1).index, .result = @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((state_1).result).calls, .limit = ((state_1).result).limit, .result = ((state_1).result).result, .visited = state_owned_30, }), .source = (state_1).source, };
            }

            break :block_36 (if (state_changed_9) block_35: {
                break :block_35 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_34: {
                    const operand_33 = (try (allocator).create((zx_abi).zx_type_15));

                    (operand_33).* = (zx_abi).zx_type_15{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_32: {
                        const operand_31 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_31).* = (zx_abi).zx_type_13{ .calls = ((state_1).result).calls, .limit = ((state_1).result).limit, .result = ((state_1).result).result, .visited = ((state_1).result).visited, };

                        break :block_32 @as(*const (zx_abi).zx_type_13, operand_31);
                    }), .source = (state_1).source, };

                    break :block_34 @as(*const (zx_abi).zx_type_15, operand_33);
                });
            } else operand_8);
        };

        break :block_37 (value_9).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = block_83: {
        const operand_78 = true;
        const operand_79 = @as(u64, 0);

        const operand_80 = block_81: {
            break :block_81 (try (allocator).dupe(i64, (&[_]i64{})));
        };

        const operand_82 = (in).limit;

        break :block_83 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_78, .calls = operand_79, .visited = operand_80, .limit = operand_82, });
    };

    return block_77: {
        const value_4: []const i64 = (in).items;

        const value_9: (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = block_76: {
            const operand_52 = block_51: {
                const operand_47 = block_48: {
                    break :block_48 value_4;
                };

                const operand_49 = @as(u64, 0);
                const operand_50 = value_1;

                break :block_51 @as((zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_49, .result = operand_50, .source = operand_47, });
            };

            var state_capacity_54: (std).ArrayList(i64) = .empty;
            var state_capacity_started_55 = false;

            defer (state_capacity_54).deinit(allocator);

            var state_46: (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = operand_52;
            var state_changed_53 = false;

            while (((state_46).index < @as(u64, ((state_46).source).len))) {
                state_46 = block_73: {
                    const value_7: i64 = block_72: {
                        const operand_70 = (state_46).source;
                        const operand_71 = (state_46).index;

                        if ((operand_71 >= (operand_70).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_72 (operand_70)[@intCast(operand_71)];
                    };

                    const value_2: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (state_46).result;

                    const value_3: i64 = block_69: {
                        break :block_69 value_7;
                    };

                    const value_8: (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = (if ((value_2).result) block_68: {
                        const operand_60 = ((value_2).calls <= (value_2).limit);
                        const operand_61 = ((value_2).calls + @as(u64, 1));

                        const operand_62 = (block_66: {
                            const operand_63 = (value_2).visited;

                            const operand_65 = block_64: {
                                break :block_64 value_3;
                            };

                            _ = (try ((std).math).add(usize, (operand_63).len, 1));

                            if ((!state_capacity_started_55)) {
                                (try (state_capacity_54).appendSlice(allocator, operand_63));

                                state_capacity_started_55 = true;
                            } else {
                                ((state_capacity_54).items).len = (operand_63).len;
                            }

                            (try (state_capacity_54).append(allocator, operand_65));

                            break :block_66 @as((zx_abi).value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_54).items, {}, null, });
                        }).@"0";

                        const operand_67 = (value_2).limit;

                        break :block_68 @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .result = operand_60, .calls = operand_61, .visited = operand_62, .limit = operand_67, });
                    } else value_2);

                    break :block_73 block_59: {
                        const operand_56 = (state_46).source;
                        const operand_57 = ((state_46).index + @as(u64, 1));
                        const operand_58 = value_8;

                        break :block_59 @as((zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb, (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = operand_57, .result = operand_58, .source = operand_56, });
                    };
                };

                state_changed_53 = true;
            }

            var state_owned_74: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_74);

            if (state_capacity_started_55) {
                ((state_capacity_54).items).len = (((state_46).result).visited).len;
                state_owned_74 = (try (state_capacity_54).toOwnedSlice(allocator));
            }

            if (state_capacity_started_55) {
                state_46 = (zx_abi).value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb{ .index = (state_46).index, .result = @as((zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, (zx_abi).value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165{ .calls = ((state_46).result).calls, .limit = ((state_46).result).limit, .result = ((state_46).result).result, .visited = state_owned_74, }), .source = (state_46).source, };
            }

            break :block_76 (if (state_changed_53) state_46 else operand_52);
        };

        break :block_77 (value_9).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_5: {
        const operand_1 = in;
        const operand_2 = (try function_0_value(allocator, (zx_abi).value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .items = (operand_1).items, .limit = (operand_1).limit, .zx_origin = operand_1, }));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_3).* = (zx_abi).zx_type_13{ .calls = (operand_2).calls, .limit = (operand_2).limit, .result = (operand_2).result, .visited = (operand_2).visited, };

            break :block_4 @as(*const (zx_abi).zx_type_13, operand_3);
        });
    };
}

