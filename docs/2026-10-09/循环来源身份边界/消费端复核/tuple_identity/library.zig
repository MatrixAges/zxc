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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .start = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .initial = zx_shape_7, .other = zx_shape_7, .previous = zx_shape_7, .steps = zx_shape_5, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .previous = zx_shape_7, .total = zx_shape_7, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .leaf = zx_shape_14, .limit = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .left = zx_shape_14, .limit = zx_shape_5, .previous = zx_shape_7, .right = zx_shape_14, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .limit = zx_shape_5, .pair = zx_shape_16, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .previous = zx_shape_7, .total = zx_shape_7, .values = zx_shape_11, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .box = zx_shape_19, .index = zx_shape_5, .limit = zx_shape_5, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_18) error{ }!*const (zx_abi).zx_type_18 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ }!(zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_18 = block_60: {
        const operand_46 = block_56: {
            const operand_52 = block_51: {
                const operand_47 = (in).start;
                const operand_48 = (in).start;

                break :block_51 block_50: {
                    const operand_49 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_49).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_47, .previous = operand_48, });

                    break :block_50 @as(*const (zx_abi).zx_type_14, operand_49);
                };
            };

            const operand_53 = @as(u64, 0);

            break :block_56 block_55: {
                const operand_54 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_54).* = @as((zx_abi).zx_type_16, .{ operand_52, operand_53, });

                break :block_55 @as(*const (zx_abi).zx_type_16, operand_54);
            };
        };

        const operand_57 = (in).count;

        break :block_60 block_59: {
            const operand_58 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_58).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_46, .limit = operand_57, });

            break :block_59 @as(*const (zx_abi).zx_type_18, operand_58);
        };
    };

    return block_45: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_4 = struct { state_type_3, u64, };

        const state_type_5 = struct {
            limit: u64,
            pair: state_type_4,
        };
        const operand_7 = block_6: {
            const operand_2 = value_1;

            break :block_6 state_type_5{ .limit = (operand_2).limit, .pair = @as(state_type_4, .{ state_type_3{ .previous = (((operand_2).pair).@"0").previous, .total = (((operand_2).pair).@"0").total, }, ((operand_2).pair).@"1", }), };
        };

        var state_1: state_type_5 = operand_7;
        var state_changed_8 = false;

        while ((((state_1).pair).@"1" < (state_1).limit)) {
            state_1 = block_35: {
                const value_4: state_type_5 = block_34: {
                    const operand_23 = state_1;
                    const operand_24 = (zx_abi).zx_type_14{ .previous = (((operand_23).pair).@"0").previous, .total = (((operand_23).pair).@"0").total, };
                    const operand_25 = @as((zx_abi).zx_type_16, .{ (&operand_24), ((operand_23).pair).@"1", });
                    const operand_26 = (zx_abi).zx_type_18{ .limit = (operand_23).limit, .pair = (&operand_25), };

                    const operand_33 = block_32: {
                        const operand_27 = (&operand_26);
                        const operand_28 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_27).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_27).pair).@"0", ((operand_27).pair).@"1", (operand_27).pair, }), .zx_origin = operand_27, }));

                        break :block_32 (if (((operand_28).zx_origin != null)) ((operand_28).zx_origin.?).* else block_31: {
                            break :block_31 (zx_abi).zx_type_18{ .limit = (operand_28).limit, .pair = (if ((((operand_28).pair).@"2" != null)) ((operand_28).pair).@"2".? else block_30: {
                                const operand_29 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_29).* = @as((zx_abi).zx_type_16, .{ ((operand_28).pair).@"0", ((operand_28).pair).@"1", });
                                break :block_30 @as(*const (zx_abi).zx_type_16, operand_29);
                            }), };
                        });
                    };

                    break :block_34 state_type_5{ .limit = (operand_33).limit, .pair = @as(state_type_4, .{ state_type_3{ .previous = (((operand_33).pair).@"0").previous, .total = (((operand_33).pair).@"0").total, }, ((operand_33).pair).@"1", }), };
                };

                const value_5: state_type_5 = state_1;
                const value_6: state_type_4 = (value_5).pair;
                const value_7: state_type_3 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_5 = block_22: {
                    break :block_22 state_type_5{ .limit = (value_5).limit, .pair = block_21: {
                        const operand_19 = block_18: {
                            break :block_18 state_type_3{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_20 = (value_6).@"1";

                        break :block_21 @as(state_type_4, .{ operand_19, operand_20, });
                    }, };
                };
                const value_10: state_type_5 = value_9;
                const value_11: state_type_4 = (value_10).pair;
                const value_12: state_type_3 = (value_11).@"0";

                const value_13: state_type_5 = block_17: {
                    break :block_17 state_type_5{ .limit = (value_10).limit, .pair = block_16: {
                        const operand_14 = block_13: {
                            break :block_13 state_type_3{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_15 = (value_11).@"1";

                        break :block_16 @as(state_type_4, .{ operand_14, operand_15, });
                    }, };
                };
                const value_14: state_type_5 = value_13;
                const value_15: state_type_4 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";
                const value_17: state_type_5 = block_12: {
                    break :block_12 state_type_5{ .limit = (value_14).limit, .pair = block_11: {
                        const operand_9 = (value_15).@"0";
                        const operand_10 = (value_16 + @as(u64, 1));

                        break :block_11 @as(state_type_4, .{ operand_9, operand_10, });
                    }, };
                };

                break :block_35 value_17;
            };

            state_changed_8 = true;
        }

        break :block_45 block_44: {
            const operand_36 = (((value_1).pair).@"0").total;
            const operand_37 = (((state_1).pair).@"0").total;
            const operand_38 = (((state_1).pair).@"0").previous;
            const operand_39 = ((state_1).pair).@"1";
            const operand_40 = @as(i64, 0);
            const operand_41 = (in).values;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_42).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_36, .total = operand_37, .previous = operand_38, .steps = operand_39, .other = operand_40, .values = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_13, operand_42);
            };
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_109: {
        const operand_99 = block_107: {
            const operand_105 = block_104: {
                const operand_100 = (in).start;
                const operand_101 = (in).start;

                break :block_104 block_103: {
                    const operand_102 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_102).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_100, .previous = operand_101, });

                    break :block_103 @as(*const (zx_abi).zx_type_14, operand_102);
                };
            };

            const operand_106 = @as(u64, 0);

            break :block_107 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_105, operand_106, null, });
        };

        const operand_108 = (in).count;

        break :block_109 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .pair = operand_99, .limit = operand_108, });
    };

    const value_18: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_98: {
        const operand_70 = value_1;
        var state_69: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = operand_70;
        var state_changed_71 = false;

        while ((((state_69).pair).@"1" < (state_69).limit)) {
            state_69 = block_96: {
                const value_4: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_95: {
                    break :block_95 (try function_0_value(allocator, state_69));
                };

                const value_5: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = state_69;
                const value_6: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_5).pair;
                const value_7: (zx_abi).zx_type_14 = ((value_6).@"0").*;

                const value_8: i64 = (block_94: {
                    break :block_94 (&value_7);
                }).total;

                const value_9: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_93: {
                    break :block_93 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_5).limit, .pair = block_92: {
                        const operand_90 = block_89: {
                            break :block_89 block_88: {
                                const operand_87 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_87).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_85: {
                                    break :block_85 (&value_7);
                                }).previous, .total = (block_86: {
                                    break :block_86 value_8;
                                } + @as(i64, 1)), });

                                break :block_88 @as(*const (zx_abi).zx_type_14, operand_87);
                            };
                        };

                        const operand_91 = (value_6).@"1";

                        break :block_92 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_90, operand_91, null, });
                    }, });
                };

                const value_10: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_9;
                const value_11: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_10).pair;
                const value_12: (zx_abi).zx_type_14 = ((value_11).@"0").*;

                const value_13: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_84: {
                    break :block_84 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_10).limit, .pair = block_83: {
                        const operand_81 = block_80: {
                            break :block_80 block_79: {
                                const operand_78 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_78).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((value_4).pair).@"0").total, .total = (block_77: {
                                    break :block_77 (&value_12);
                                }).total, });

                                break :block_79 @as(*const (zx_abi).zx_type_14, operand_78);
                            };
                        };

                        const operand_82 = (value_11).@"1";

                        break :block_83 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_81, operand_82, null, });
                    }, });
                };

                const value_14: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_13;
                const value_15: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_76: {
                    break :block_76 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_14).limit, .pair = block_75: {
                        const operand_72 = (value_15).@"0";

                        const operand_74 = (block_73: {
                            break :block_73 value_16;
                        } + @as(u64, 1));

                        break :block_75 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_72, operand_74, null, });
                    }, });
                };

                break :block_96 value_17;
            };

            state_changed_71 = true;
        }

        break :block_98 (if (state_changed_71) state_69 else operand_70);
    };

    return block_68: {
        const operand_62 = (((value_1).pair).@"0").total;
        const operand_63 = (((value_18).pair).@"0").total;
        const operand_64 = (((value_18).pair).@"0").previous;
        const operand_65 = ((value_18).pair).@"1";
        const operand_66 = @as(i64, 0);
        const operand_67 = (in).values;

        break :block_68 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_62, .total = operand_63, .previous = operand_64, .steps = operand_65, .other = operand_66, .values = operand_67, });
    };
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    _ = buffers;

    const value_1: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_158: {
        const operand_148 = block_156: {
            const operand_154 = block_153: {
                const operand_149 = (in).start;
                const operand_150 = (in).start;

                break :block_153 block_152: {
                    const operand_151 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_151).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_149, .previous = operand_150, });

                    break :block_152 @as(*const (zx_abi).zx_type_14, operand_151);
                };
            };

            const operand_155 = @as(u64, 0);

            break :block_156 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_154, operand_155, null, });
        };

        const operand_157 = (in).count;

        break :block_158 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .pair = operand_148, .limit = operand_157, });
    };

    const value_18: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_147: {
        const operand_119 = value_1;
        var state_118: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = operand_119;
        var state_changed_120 = false;

        while ((((state_118).pair).@"1" < (state_118).limit)) {
            state_118 = block_145: {
                const value_4: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_144: {
                    break :block_144 (try function_0_value(allocator, state_118));
                };

                const value_5: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = state_118;
                const value_6: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_5).pair;
                const value_7: (zx_abi).zx_type_14 = ((value_6).@"0").*;

                const value_8: i64 = (block_143: {
                    break :block_143 (&value_7);
                }).total;

                const value_9: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_142: {
                    break :block_142 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_5).limit, .pair = block_141: {
                        const operand_139 = block_138: {
                            break :block_138 block_137: {
                                const operand_136 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_136).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_134: {
                                    break :block_134 (&value_7);
                                }).previous, .total = (block_135: {
                                    break :block_135 value_8;
                                } + @as(i64, 1)), });

                                break :block_137 @as(*const (zx_abi).zx_type_14, operand_136);
                            };
                        };

                        const operand_140 = (value_6).@"1";

                        break :block_141 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_139, operand_140, null, });
                    }, });
                };

                const value_10: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_9;
                const value_11: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_10).pair;
                const value_12: (zx_abi).zx_type_14 = ((value_11).@"0").*;

                const value_13: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_133: {
                    break :block_133 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_10).limit, .pair = block_132: {
                        const operand_130 = block_129: {
                            break :block_129 block_128: {
                                const operand_127 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_127).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((value_4).pair).@"0").total, .total = (block_126: {
                                    break :block_126 (&value_12);
                                }).total, });

                                break :block_128 @as(*const (zx_abi).zx_type_14, operand_127);
                            };
                        };

                        const operand_131 = (value_11).@"1";

                        break :block_132 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_130, operand_131, null, });
                    }, });
                };

                const value_14: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_13;
                const value_15: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_125: {
                    break :block_125 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_14).limit, .pair = block_124: {
                        const operand_121 = (value_15).@"0";

                        const operand_123 = (block_122: {
                            break :block_122 value_16;
                        } + @as(u64, 1));

                        break :block_124 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_121, operand_123, null, });
                    }, });
                };

                break :block_145 value_17;
            };

            state_changed_120 = true;
        }

        break :block_147 (if (state_changed_120) state_118 else operand_119);
    };

    return block_117: {
        const operand_111 = (((value_1).pair).@"0").total;
        const operand_112 = (((value_18).pair).@"0").total;
        const operand_113 = (((value_18).pair).@"0").previous;
        const operand_114 = ((value_18).pair).@"1";
        const operand_115 = @as(i64, 0);
        const operand_116 = (in).values;

        break :block_117 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_111, .total = operand_112, .previous = operand_113, .steps = operand_114, .other = operand_115, .values = operand_116, });
    };
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = buffers;

    const value_1: *const (zx_abi).zx_type_18 = block_218: {
        const operand_204 = block_214: {
            const operand_210 = block_209: {
                const operand_205 = (in).start;
                const operand_206 = (in).start;

                break :block_209 block_208: {
                    const operand_207 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_207).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_205, .previous = operand_206, });

                    break :block_208 @as(*const (zx_abi).zx_type_14, operand_207);
                };
            };

            const operand_211 = @as(u64, 0);

            break :block_214 block_213: {
                const operand_212 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_212).* = @as((zx_abi).zx_type_16, .{ operand_210, operand_211, });

                break :block_213 @as(*const (zx_abi).zx_type_16, operand_212);
            };
        };

        const operand_215 = (in).count;

        break :block_218 block_217: {
            const operand_216 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_216).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_204, .limit = operand_215, });

            break :block_217 @as(*const (zx_abi).zx_type_18, operand_216);
        };
    };

    return block_203: {
        const state_type_161 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_162 = struct { state_type_161, u64, };

        const state_type_163 = struct {
            limit: u64,
            pair: state_type_162,
        };

        const operand_165 = block_164: {
            const operand_160 = value_1;

            break :block_164 state_type_163{ .limit = (operand_160).limit, .pair = @as(state_type_162, .{ state_type_161{ .previous = (((operand_160).pair).@"0").previous, .total = (((operand_160).pair).@"0").total, }, ((operand_160).pair).@"1", }), };
        };

        var state_159: state_type_163 = operand_165;
        var state_changed_166 = false;

        while ((((state_159).pair).@"1" < (state_159).limit)) {
            state_159 = block_193: {
                const value_4: state_type_163 = block_192: {
                    const operand_181 = state_159;
                    const operand_182 = (zx_abi).zx_type_14{ .previous = (((operand_181).pair).@"0").previous, .total = (((operand_181).pair).@"0").total, };
                    const operand_183 = @as((zx_abi).zx_type_16, .{ (&operand_182), ((operand_181).pair).@"1", });
                    const operand_184 = (zx_abi).zx_type_18{ .limit = (operand_181).limit, .pair = (&operand_183), };

                    const operand_191 = block_190: {
                        const operand_185 = (&operand_184);
                        const operand_186 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_185).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_185).pair).@"0", ((operand_185).pair).@"1", (operand_185).pair, }), .zx_origin = operand_185, }));

                        break :block_190 (if (((operand_186).zx_origin != null)) ((operand_186).zx_origin.?).* else block_189: {
                            break :block_189 (zx_abi).zx_type_18{ .limit = (operand_186).limit, .pair = (if ((((operand_186).pair).@"2" != null)) ((operand_186).pair).@"2".? else block_188: {
                                const operand_187 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_187).* = @as((zx_abi).zx_type_16, .{ ((operand_186).pair).@"0", ((operand_186).pair).@"1", });
                                break :block_188 @as(*const (zx_abi).zx_type_16, operand_187);
                            }), };
                        });
                    };

                    break :block_192 state_type_163{ .limit = (operand_191).limit, .pair = @as(state_type_162, .{ state_type_161{ .previous = (((operand_191).pair).@"0").previous, .total = (((operand_191).pair).@"0").total, }, ((operand_191).pair).@"1", }), };
                };

                const value_5: state_type_163 = state_159;
                const value_6: state_type_162 = (value_5).pair;
                const value_7: state_type_161 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_163 = block_180: {
                    break :block_180 state_type_163{ .limit = (value_5).limit, .pair = block_179: {
                        const operand_177 = block_176: {
                            break :block_176 state_type_161{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_178 = (value_6).@"1";

                        break :block_179 @as(state_type_162, .{ operand_177, operand_178, });
                    }, };
                };
                const value_10: state_type_163 = value_9;
                const value_11: state_type_162 = (value_10).pair;
                const value_12: state_type_161 = (value_11).@"0";

                const value_13: state_type_163 = block_175: {
                    break :block_175 state_type_163{ .limit = (value_10).limit, .pair = block_174: {
                        const operand_172 = block_171: {
                            break :block_171 state_type_161{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_173 = (value_11).@"1";

                        break :block_174 @as(state_type_162, .{ operand_172, operand_173, });
                    }, };
                };
                const value_14: state_type_163 = value_13;
                const value_15: state_type_162 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";
                const value_17: state_type_163 = block_170: {
                    break :block_170 state_type_163{ .limit = (value_14).limit, .pair = block_169: {
                        const operand_167 = (value_15).@"0";
                        const operand_168 = (value_16 + @as(u64, 1));

                        break :block_169 @as(state_type_162, .{ operand_167, operand_168, });
                    }, };
                };

                break :block_193 value_17;
            };

            state_changed_166 = true;
        }

        break :block_203 block_202: {
            const operand_194 = (((value_1).pair).@"0").total;
            const operand_195 = (((state_159).pair).@"0").total;
            const operand_196 = (((state_159).pair).@"0").previous;
            const operand_197 = ((state_159).pair).@"1";
            const operand_198 = @as(i64, 0);
            const operand_199 = (in).values;

            break :block_202 block_201: {
                const operand_200 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_200).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_194, .total = operand_195, .previous = operand_196, .steps = operand_197, .other = operand_198, .values = operand_199, });

                break :block_201 @as(*const (zx_abi).zx_type_13, operand_200);
            };
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_18 = block_60: {
        const operand_46 = block_56: {
            const operand_52 = block_51: {
                const operand_47 = (in).start;
                const operand_48 = (in).start;

                break :block_51 block_50: {
                    const operand_49 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_49).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_47, .previous = operand_48, });

                    break :block_50 @as(*const (zx_abi).zx_type_14, operand_49);
                };
            };

            const operand_53 = @as(u64, 0);

            break :block_56 block_55: {
                const operand_54 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_54).* = @as((zx_abi).zx_type_16, .{ operand_52, operand_53, });

                break :block_55 @as(*const (zx_abi).zx_type_16, operand_54);
            };
        };

        const operand_57 = (in).count;

        break :block_60 block_59: {
            const operand_58 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_58).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_46, .limit = operand_57, });

            break :block_59 @as(*const (zx_abi).zx_type_18, operand_58);
        };
    };

    return block_45: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_4 = struct { state_type_3, u64, };

        const state_type_5 = struct {
            limit: u64,
            pair: state_type_4,
        };
        const operand_7 = block_6: {
            const operand_2 = value_1;

            break :block_6 state_type_5{ .limit = (operand_2).limit, .pair = @as(state_type_4, .{ state_type_3{ .previous = (((operand_2).pair).@"0").previous, .total = (((operand_2).pair).@"0").total, }, ((operand_2).pair).@"1", }), };
        };

        var state_1: state_type_5 = operand_7;
        var state_changed_8 = false;

        while ((((state_1).pair).@"1" < (state_1).limit)) {
            state_1 = block_35: {
                const value_4: state_type_5 = block_34: {
                    const operand_23 = state_1;
                    const operand_24 = (zx_abi).zx_type_14{ .previous = (((operand_23).pair).@"0").previous, .total = (((operand_23).pair).@"0").total, };
                    const operand_25 = @as((zx_abi).zx_type_16, .{ (&operand_24), ((operand_23).pair).@"1", });
                    const operand_26 = (zx_abi).zx_type_18{ .limit = (operand_23).limit, .pair = (&operand_25), };

                    const operand_33 = block_32: {
                        const operand_27 = (&operand_26);
                        const operand_28 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_27).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_27).pair).@"0", ((operand_27).pair).@"1", (operand_27).pair, }), .zx_origin = operand_27, }));

                        break :block_32 (if (((operand_28).zx_origin != null)) ((operand_28).zx_origin.?).* else block_31: {
                            break :block_31 (zx_abi).zx_type_18{ .limit = (operand_28).limit, .pair = (if ((((operand_28).pair).@"2" != null)) ((operand_28).pair).@"2".? else block_30: {
                                const operand_29 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_29).* = @as((zx_abi).zx_type_16, .{ ((operand_28).pair).@"0", ((operand_28).pair).@"1", });
                                break :block_30 @as(*const (zx_abi).zx_type_16, operand_29);
                            }), };
                        });
                    };

                    break :block_34 state_type_5{ .limit = (operand_33).limit, .pair = @as(state_type_4, .{ state_type_3{ .previous = (((operand_33).pair).@"0").previous, .total = (((operand_33).pair).@"0").total, }, ((operand_33).pair).@"1", }), };
                };

                const value_5: state_type_5 = state_1;
                const value_6: state_type_4 = (value_5).pair;
                const value_7: state_type_3 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_5 = block_22: {
                    break :block_22 state_type_5{ .limit = (value_5).limit, .pair = block_21: {
                        const operand_19 = block_18: {
                            break :block_18 state_type_3{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_20 = (value_6).@"1";

                        break :block_21 @as(state_type_4, .{ operand_19, operand_20, });
                    }, };
                };
                const value_10: state_type_5 = value_9;
                const value_11: state_type_4 = (value_10).pair;
                const value_12: state_type_3 = (value_11).@"0";

                const value_13: state_type_5 = block_17: {
                    break :block_17 state_type_5{ .limit = (value_10).limit, .pair = block_16: {
                        const operand_14 = block_13: {
                            break :block_13 state_type_3{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_15 = (value_11).@"1";

                        break :block_16 @as(state_type_4, .{ operand_14, operand_15, });
                    }, };
                };
                const value_14: state_type_5 = value_13;
                const value_15: state_type_4 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";
                const value_17: state_type_5 = block_12: {
                    break :block_12 state_type_5{ .limit = (value_14).limit, .pair = block_11: {
                        const operand_9 = (value_15).@"0";
                        const operand_10 = (value_16 + @as(u64, 1));

                        break :block_11 @as(state_type_4, .{ operand_9, operand_10, });
                    }, };
                };

                break :block_35 value_17;
            };

            state_changed_8 = true;
        }

        break :block_45 block_44: {
            const operand_36 = (((value_1).pair).@"0").total;
            const operand_37 = (((state_1).pair).@"0").total;
            const operand_38 = (((state_1).pair).@"0").previous;
            const operand_39 = ((state_1).pair).@"1";
            const operand_40 = @as(i64, 0);
            const operand_41 = (in).values;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_42).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_36, .total = operand_37, .previous = operand_38, .steps = operand_39, .other = operand_40, .values = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_13, operand_42);
            };
        };
    };
}

