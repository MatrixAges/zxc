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

    const value_1: *const (zx_abi).zx_type_18 = block_65: {
        const operand_51 = block_61: {
            const operand_57 = block_56: {
                const operand_52 = (in).start;
                const operand_53 = (in).start;

                break :block_56 block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_54).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_52, .previous = operand_53, });

                    break :block_55 @as(*const (zx_abi).zx_type_14, operand_54);
                };
            };

            const operand_58 = @as(u64, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_59).* = @as((zx_abi).zx_type_16, .{ operand_57, operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_16, operand_59);
            };
        };

        const operand_62 = (in).count;

        break :block_65 block_64: {
            const operand_63 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_63).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_51, .limit = operand_62, });

            break :block_64 @as(*const (zx_abi).zx_type_18, operand_63);
        };
    };

    const value_18: *const (zx_abi).zx_type_18 = block_50: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_14 = struct { state_type_13, u64, };

        const state_type_15 = struct {
            limit: u64,
            pair: state_type_14,
        };

        var state_10: state_type_15 = state_type_15{ .limit = (operand_11).limit, .pair = @as(state_type_14, .{ state_type_13{ .previous = (((operand_11).pair).@"0").previous, .total = (((operand_11).pair).@"0").total, }, ((operand_11).pair).@"1", }), };
        var state_changed_12 = false;

        while ((((state_10).pair).@"1" < (state_10).limit)) {
            state_10 = block_42: {
                const value_4: state_type_15 = block_41: {
                    const operand_30 = state_10;
                    const operand_31 = (zx_abi).zx_type_14{ .previous = (((operand_30).pair).@"0").previous, .total = (((operand_30).pair).@"0").total, };
                    const operand_32 = @as((zx_abi).zx_type_16, .{ (&operand_31), ((operand_30).pair).@"1", });
                    const operand_33 = (zx_abi).zx_type_18{ .limit = (operand_30).limit, .pair = (&operand_32), };

                    const operand_40 = block_39: {
                        const operand_34 = (&operand_33);
                        const operand_35 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_34).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_34).pair).@"0", ((operand_34).pair).@"1", (operand_34).pair, }), .zx_origin = operand_34, }));

                        break :block_39 (if (((operand_35).zx_origin != null)) ((operand_35).zx_origin.?).* else block_38: {
                            break :block_38 (zx_abi).zx_type_18{ .limit = (operand_35).limit, .pair = (if ((((operand_35).pair).@"2" != null)) ((operand_35).pair).@"2".? else block_37: {
                                const operand_36 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_36).* = @as((zx_abi).zx_type_16, .{ ((operand_35).pair).@"0", ((operand_35).pair).@"1", });
                                break :block_37 @as(*const (zx_abi).zx_type_16, operand_36);
                            }), };
                        });
                    };

                    break :block_41 state_type_15{ .limit = (operand_40).limit, .pair = @as(state_type_14, .{ state_type_13{ .previous = (((operand_40).pair).@"0").previous, .total = (((operand_40).pair).@"0").total, }, ((operand_40).pair).@"1", }), };
                };

                const value_5: state_type_15 = state_10;
                const value_6: state_type_14 = (value_5).pair;
                const value_7: state_type_13 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_15 = block_29: {
                    break :block_29 state_type_15{ .limit = (value_5).limit, .pair = block_28: {
                        const operand_26 = block_25: {
                            break :block_25 state_type_13{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_27 = (value_6).@"1";

                        break :block_28 @as(state_type_14, .{ operand_26, operand_27, });
                    }, };
                };
                const value_10: state_type_15 = value_9;
                const value_11: state_type_14 = (value_10).pair;
                const value_12: state_type_13 = (value_11).@"0";

                const value_13: state_type_15 = block_24: {
                    break :block_24 state_type_15{ .limit = (value_10).limit, .pair = block_23: {
                        const operand_21 = block_20: {
                            break :block_20 state_type_13{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_22 = (value_11).@"1";

                        break :block_23 @as(state_type_14, .{ operand_21, operand_22, });
                    }, };
                };
                const value_14: state_type_15 = value_13;
                const value_15: state_type_14 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: state_type_15 = block_19: {
                    break :block_19 state_type_15{ .limit = (value_14).limit, .pair = block_18: {
                        const operand_16 = (value_15).@"0";
                        const operand_17 = (value_16 + @as(u64, 1));

                        break :block_18 @as(state_type_14, .{ operand_16, operand_17, });
                    }, };
                };

                break :block_42 value_17;
            };

            state_changed_12 = true;
        }

        break :block_50 (if (state_changed_12) block_49: {
            const operand_48 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_48).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .limit = (state_10).limit, .pair = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_46).* = @as((zx_abi).zx_type_16, @as((zx_abi).zx_type_16, .{ block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_44).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((state_10).pair).@"0").previous, .total = (((state_10).pair).@"0").total, });

                    break :block_45 @as(*const (zx_abi).zx_type_14, operand_44);
                }, ((state_10).pair).@"1", }));

                break :block_47 @as(*const (zx_abi).zx_type_16, operand_46);
            }, });

            break :block_49 @as(*const (zx_abi).zx_type_18, operand_48);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (((value_1).pair).@"0").total;
        const operand_2 = (((value_18).pair).@"0").total;
        const operand_3 = (((value_18).pair).@"0").previous;
        const operand_4 = ((value_18).pair).@"1";
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_113: {
        const operand_103 = block_111: {
            const operand_109 = block_108: {
                const operand_104 = (in).start;
                const operand_105 = (in).start;

                break :block_108 block_107: {
                    const operand_106 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_106).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_104, .previous = operand_105, });

                    break :block_107 @as(*const (zx_abi).zx_type_14, operand_106);
                };
            };

            const operand_110 = @as(u64, 0);

            break :block_111 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_109, operand_110, null, });
        };

        const operand_112 = (in).count;

        break :block_113 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .pair = operand_103, .limit = operand_112, });
    };

    const value_18: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_102: {
        const operand_74 = value_1;
        var state_73: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = operand_74;
        var state_changed_75 = false;

        while ((((state_73).pair).@"1" < (state_73).limit)) {
            state_73 = block_100: {
                const value_4: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_99: {
                    break :block_99 (try function_0_value(allocator, state_73));
                };

                const value_5: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = state_73;
                const value_6: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_5).pair;
                const value_7: (zx_abi).zx_type_14 = ((value_6).@"0").*;

                const value_8: i64 = (block_98: {
                    break :block_98 (&value_7);
                }).total;

                const value_9: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_97: {
                    break :block_97 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_5).limit, .pair = block_96: {
                        const operand_94 = block_93: {
                            break :block_93 block_92: {
                                const operand_91 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_91).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_89: {
                                    break :block_89 (&value_7);
                                }).previous, .total = (block_90: {
                                    break :block_90 value_8;
                                } + @as(i64, 1)), });

                                break :block_92 @as(*const (zx_abi).zx_type_14, operand_91);
                            };
                        };

                        const operand_95 = (value_6).@"1";

                        break :block_96 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_94, operand_95, null, });
                    }, });
                };

                const value_10: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_9;
                const value_11: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_10).pair;
                const value_12: (zx_abi).zx_type_14 = ((value_11).@"0").*;

                const value_13: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_88: {
                    break :block_88 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_10).limit, .pair = block_87: {
                        const operand_85 = block_84: {
                            break :block_84 block_83: {
                                const operand_82 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_82).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((value_4).pair).@"0").total, .total = (block_81: {
                                    break :block_81 (&value_12);
                                }).total, });

                                break :block_83 @as(*const (zx_abi).zx_type_14, operand_82);
                            };
                        };

                        const operand_86 = (value_11).@"1";

                        break :block_87 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_85, operand_86, null, });
                    }, });
                };

                const value_14: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_13;
                const value_15: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_80: {
                    break :block_80 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_14).limit, .pair = block_79: {
                        const operand_76 = (value_15).@"0";

                        const operand_78 = (block_77: {
                            break :block_77 value_16;
                        } + @as(u64, 1));

                        break :block_79 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_76, operand_78, null, });
                    }, });
                };

                break :block_100 value_17;
            };

            state_changed_75 = true;
        }

        break :block_102 (if (state_changed_75) state_73 else operand_74);
    };

    return block_72: {
        const operand_66 = (((value_1).pair).@"0").total;
        const operand_67 = (((value_18).pair).@"0").total;
        const operand_68 = (((value_18).pair).@"0").previous;
        const operand_69 = ((value_18).pair).@"1";
        const operand_70 = @as(i64, 0);
        const operand_71 = (in).values;

        break :block_72 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_66, .total = operand_67, .previous = operand_68, .steps = operand_69, .other = operand_70, .values = operand_71, });
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

    const value_1: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_161: {
        const operand_151 = block_159: {
            const operand_157 = block_156: {
                const operand_152 = (in).start;
                const operand_153 = (in).start;

                break :block_156 block_155: {
                    const operand_154 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_154).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_152, .previous = operand_153, });

                    break :block_155 @as(*const (zx_abi).zx_type_14, operand_154);
                };
            };

            const operand_158 = @as(u64, 0);

            break :block_159 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_157, operand_158, null, });
        };

        const operand_160 = (in).count;

        break :block_161 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .pair = operand_151, .limit = operand_160, });
    };

    const value_18: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_150: {
        const operand_122 = value_1;
        var state_121: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = operand_122;
        var state_changed_123 = false;

        while ((((state_121).pair).@"1" < (state_121).limit)) {
            state_121 = block_148: {
                const value_4: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_147: {
                    break :block_147 (try function_0_value(allocator, state_121));
                };

                const value_5: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = state_121;
                const value_6: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_5).pair;
                const value_7: (zx_abi).zx_type_14 = ((value_6).@"0").*;

                const value_8: i64 = (block_146: {
                    break :block_146 (&value_7);
                }).total;

                const value_9: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_145: {
                    break :block_145 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_5).limit, .pair = block_144: {
                        const operand_142 = block_141: {
                            break :block_141 block_140: {
                                const operand_139 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_139).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_137: {
                                    break :block_137 (&value_7);
                                }).previous, .total = (block_138: {
                                    break :block_138 value_8;
                                } + @as(i64, 1)), });

                                break :block_140 @as(*const (zx_abi).zx_type_14, operand_139);
                            };
                        };

                        const operand_143 = (value_6).@"1";

                        break :block_144 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_142, operand_143, null, });
                    }, });
                };

                const value_10: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_9;
                const value_11: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_10).pair;
                const value_12: (zx_abi).zx_type_14 = ((value_11).@"0").*;

                const value_13: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_136: {
                    break :block_136 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_10).limit, .pair = block_135: {
                        const operand_133 = block_132: {
                            break :block_132 block_131: {
                                const operand_130 = (try (allocator).create((zx_abi).zx_type_14));

                                (operand_130).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((value_4).pair).@"0").total, .total = (block_129: {
                                    break :block_129 (&value_12);
                                }).total, });

                                break :block_131 @as(*const (zx_abi).zx_type_14, operand_130);
                            };
                        };

                        const operand_134 = (value_11).@"1";

                        break :block_135 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_133, operand_134, null, });
                    }, });
                };

                const value_14: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = value_13;
                const value_15: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = block_128: {
                    break :block_128 @as((zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (value_14).limit, .pair = block_127: {
                        const operand_124 = (value_15).@"0";

                        const operand_126 = (block_125: {
                            break :block_125 value_16;
                        } + @as(u64, 1));

                        break :block_127 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_124, operand_126, null, });
                    }, });
                };

                break :block_148 value_17;
            };

            state_changed_123 = true;
        }

        break :block_150 (if (state_changed_123) state_121 else operand_122);
    };

    return block_120: {
        const operand_114 = (((value_1).pair).@"0").total;
        const operand_115 = (((value_18).pair).@"0").total;
        const operand_116 = (((value_18).pair).@"0").previous;
        const operand_117 = ((value_18).pair).@"1";
        const operand_118 = @as(i64, 0);
        const operand_119 = (in).values;

        break :block_120 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_114, .total = operand_115, .previous = operand_116, .steps = operand_117, .other = operand_118, .values = operand_119, });
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

    const value_1: *const (zx_abi).zx_type_18 = block_226: {
        const operand_212 = block_222: {
            const operand_218 = block_217: {
                const operand_213 = (in).start;
                const operand_214 = (in).start;

                break :block_217 block_216: {
                    const operand_215 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_215).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_213, .previous = operand_214, });

                    break :block_216 @as(*const (zx_abi).zx_type_14, operand_215);
                };
            };

            const operand_219 = @as(u64, 0);

            break :block_222 block_221: {
                const operand_220 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_220).* = @as((zx_abi).zx_type_16, .{ operand_218, operand_219, });

                break :block_221 @as(*const (zx_abi).zx_type_16, operand_220);
            };
        };

        const operand_223 = (in).count;

        break :block_226 block_225: {
            const operand_224 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_224).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_212, .limit = operand_223, });

            break :block_225 @as(*const (zx_abi).zx_type_18, operand_224);
        };
    };

    const value_18: *const (zx_abi).zx_type_18 = block_211: {
        const operand_172 = value_1;

        const state_type_174 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_175 = struct { state_type_174, u64, };

        const state_type_176 = struct {
            limit: u64,
            pair: state_type_175,
        };

        var state_171: state_type_176 = state_type_176{ .limit = (operand_172).limit, .pair = @as(state_type_175, .{ state_type_174{ .previous = (((operand_172).pair).@"0").previous, .total = (((operand_172).pair).@"0").total, }, ((operand_172).pair).@"1", }), };
        var state_changed_173 = false;

        while ((((state_171).pair).@"1" < (state_171).limit)) {
            state_171 = block_203: {
                const value_4: state_type_176 = block_202: {
                    const operand_191 = state_171;
                    const operand_192 = (zx_abi).zx_type_14{ .previous = (((operand_191).pair).@"0").previous, .total = (((operand_191).pair).@"0").total, };
                    const operand_193 = @as((zx_abi).zx_type_16, .{ (&operand_192), ((operand_191).pair).@"1", });
                    const operand_194 = (zx_abi).zx_type_18{ .limit = (operand_191).limit, .pair = (&operand_193), };

                    const operand_201 = block_200: {
                        const operand_195 = (&operand_194);
                        const operand_196 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_195).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_195).pair).@"0", ((operand_195).pair).@"1", (operand_195).pair, }), .zx_origin = operand_195, }));

                        break :block_200 (if (((operand_196).zx_origin != null)) ((operand_196).zx_origin.?).* else block_199: {
                            break :block_199 (zx_abi).zx_type_18{ .limit = (operand_196).limit, .pair = (if ((((operand_196).pair).@"2" != null)) ((operand_196).pair).@"2".? else block_198: {
                                const operand_197 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_197).* = @as((zx_abi).zx_type_16, .{ ((operand_196).pair).@"0", ((operand_196).pair).@"1", });
                                break :block_198 @as(*const (zx_abi).zx_type_16, operand_197);
                            }), };
                        });
                    };

                    break :block_202 state_type_176{ .limit = (operand_201).limit, .pair = @as(state_type_175, .{ state_type_174{ .previous = (((operand_201).pair).@"0").previous, .total = (((operand_201).pair).@"0").total, }, ((operand_201).pair).@"1", }), };
                };
                const value_5: state_type_176 = state_171;
                const value_6: state_type_175 = (value_5).pair;
                const value_7: state_type_174 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_176 = block_190: {
                    break :block_190 state_type_176{ .limit = (value_5).limit, .pair = block_189: {
                        const operand_187 = block_186: {
                            break :block_186 state_type_174{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_188 = (value_6).@"1";

                        break :block_189 @as(state_type_175, .{ operand_187, operand_188, });
                    }, };
                };
                const value_10: state_type_176 = value_9;
                const value_11: state_type_175 = (value_10).pair;
                const value_12: state_type_174 = (value_11).@"0";

                const value_13: state_type_176 = block_185: {
                    break :block_185 state_type_176{ .limit = (value_10).limit, .pair = block_184: {
                        const operand_182 = block_181: {
                            break :block_181 state_type_174{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_183 = (value_11).@"1";

                        break :block_184 @as(state_type_175, .{ operand_182, operand_183, });
                    }, };
                };
                const value_14: state_type_176 = value_13;
                const value_15: state_type_175 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";
                const value_17: state_type_176 = block_180: {
                    break :block_180 state_type_176{ .limit = (value_14).limit, .pair = block_179: {
                        const operand_177 = (value_15).@"0";
                        const operand_178 = (value_16 + @as(u64, 1));

                        break :block_179 @as(state_type_175, .{ operand_177, operand_178, });
                    }, };
                };

                break :block_203 value_17;
            };

            state_changed_173 = true;
        }

        break :block_211 (if (state_changed_173) block_210: {
            const operand_209 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_209).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .limit = (state_171).limit, .pair = block_208: {
                const operand_207 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_207).* = @as((zx_abi).zx_type_16, @as((zx_abi).zx_type_16, .{ block_206: {
                    const operand_205 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_205).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((state_171).pair).@"0").previous, .total = (((state_171).pair).@"0").total, });

                    break :block_206 @as(*const (zx_abi).zx_type_14, operand_205);
                }, ((state_171).pair).@"1", }));

                break :block_208 @as(*const (zx_abi).zx_type_16, operand_207);
            }, });

            break :block_210 @as(*const (zx_abi).zx_type_18, operand_209);
        } else operand_172);
    };

    return block_170: {
        const operand_162 = (((value_1).pair).@"0").total;
        const operand_163 = (((value_18).pair).@"0").total;
        const operand_164 = (((value_18).pair).@"0").previous;
        const operand_165 = ((value_18).pair).@"1";
        const operand_166 = @as(i64, 0);
        const operand_167 = (in).values;

        break :block_170 block_169: {
            const operand_168 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_168).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_162, .total = operand_163, .previous = operand_164, .steps = operand_165, .other = operand_166, .values = operand_167, });

            break :block_169 @as(*const (zx_abi).zx_type_13, operand_168);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_18 = block_65: {
        const operand_51 = block_61: {
            const operand_57 = block_56: {
                const operand_52 = (in).start;
                const operand_53 = (in).start;

                break :block_56 block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_54).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_52, .previous = operand_53, });

                    break :block_55 @as(*const (zx_abi).zx_type_14, operand_54);
                };
            };

            const operand_58 = @as(u64, 0);

            break :block_61 block_60: {
                const operand_59 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_59).* = @as((zx_abi).zx_type_16, .{ operand_57, operand_58, });

                break :block_60 @as(*const (zx_abi).zx_type_16, operand_59);
            };
        };

        const operand_62 = (in).count;

        break :block_65 block_64: {
            const operand_63 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_63).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .pair = operand_51, .limit = operand_62, });

            break :block_64 @as(*const (zx_abi).zx_type_18, operand_63);
        };
    };

    const value_18: *const (zx_abi).zx_type_18 = block_50: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };

        const state_type_14 = struct { state_type_13, u64, };

        const state_type_15 = struct {
            limit: u64,
            pair: state_type_14,
        };

        var state_10: state_type_15 = state_type_15{ .limit = (operand_11).limit, .pair = @as(state_type_14, .{ state_type_13{ .previous = (((operand_11).pair).@"0").previous, .total = (((operand_11).pair).@"0").total, }, ((operand_11).pair).@"1", }), };
        var state_changed_12 = false;

        while ((((state_10).pair).@"1" < (state_10).limit)) {
            state_10 = block_42: {
                const value_4: state_type_15 = block_41: {
                    const operand_30 = state_10;
                    const operand_31 = (zx_abi).zx_type_14{ .previous = (((operand_30).pair).@"0").previous, .total = (((operand_30).pair).@"0").total, };
                    const operand_32 = @as((zx_abi).zx_type_16, .{ (&operand_31), ((operand_30).pair).@"1", });
                    const operand_33 = (zx_abi).zx_type_18{ .limit = (operand_30).limit, .pair = (&operand_32), };

                    const operand_40 = block_39: {
                        const operand_34 = (&operand_33);
                        const operand_35 = (try function_0_value(allocator, (zx_abi).value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .limit = (operand_34).limit, .pair = @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ ((operand_34).pair).@"0", ((operand_34).pair).@"1", (operand_34).pair, }), .zx_origin = operand_34, }));

                        break :block_39 (if (((operand_35).zx_origin != null)) ((operand_35).zx_origin.?).* else block_38: {
                            break :block_38 (zx_abi).zx_type_18{ .limit = (operand_35).limit, .pair = (if ((((operand_35).pair).@"2" != null)) ((operand_35).pair).@"2".? else block_37: {
                                const operand_36 = (try (allocator).create((zx_abi).zx_type_16));

                                (operand_36).* = @as((zx_abi).zx_type_16, .{ ((operand_35).pair).@"0", ((operand_35).pair).@"1", });
                                break :block_37 @as(*const (zx_abi).zx_type_16, operand_36);
                            }), };
                        });
                    };

                    break :block_41 state_type_15{ .limit = (operand_40).limit, .pair = @as(state_type_14, .{ state_type_13{ .previous = (((operand_40).pair).@"0").previous, .total = (((operand_40).pair).@"0").total, }, ((operand_40).pair).@"1", }), };
                };

                const value_5: state_type_15 = state_10;
                const value_6: state_type_14 = (value_5).pair;
                const value_7: state_type_13 = (value_6).@"0";
                const value_8: i64 = (value_7).total;

                const value_9: state_type_15 = block_29: {
                    break :block_29 state_type_15{ .limit = (value_5).limit, .pair = block_28: {
                        const operand_26 = block_25: {
                            break :block_25 state_type_13{ .previous = (value_7).previous, .total = (value_8 + @as(i64, 1)), };
                        };

                        const operand_27 = (value_6).@"1";

                        break :block_28 @as(state_type_14, .{ operand_26, operand_27, });
                    }, };
                };
                const value_10: state_type_15 = value_9;
                const value_11: state_type_14 = (value_10).pair;
                const value_12: state_type_13 = (value_11).@"0";

                const value_13: state_type_15 = block_24: {
                    break :block_24 state_type_15{ .limit = (value_10).limit, .pair = block_23: {
                        const operand_21 = block_20: {
                            break :block_20 state_type_13{ .previous = (((value_4).pair).@"0").total, .total = (value_12).total, };
                        };

                        const operand_22 = (value_11).@"1";

                        break :block_23 @as(state_type_14, .{ operand_21, operand_22, });
                    }, };
                };
                const value_14: state_type_15 = value_13;
                const value_15: state_type_14 = (value_14).pair;
                const value_16: u64 = (value_15).@"1";

                const value_17: state_type_15 = block_19: {
                    break :block_19 state_type_15{ .limit = (value_14).limit, .pair = block_18: {
                        const operand_16 = (value_15).@"0";
                        const operand_17 = (value_16 + @as(u64, 1));

                        break :block_18 @as(state_type_14, .{ operand_16, operand_17, });
                    }, };
                };

                break :block_42 value_17;
            };

            state_changed_12 = true;
        }

        break :block_50 (if (state_changed_12) block_49: {
            const operand_48 = (try (allocator).create((zx_abi).zx_type_18));

            (operand_48).* = @as((zx_abi).zx_type_18, (zx_abi).zx_type_18{ .limit = (state_10).limit, .pair = block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_46).* = @as((zx_abi).zx_type_16, @as((zx_abi).zx_type_16, .{ block_45: {
                    const operand_44 = (try (allocator).create((zx_abi).zx_type_14));

                    (operand_44).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (((state_10).pair).@"0").previous, .total = (((state_10).pair).@"0").total, });

                    break :block_45 @as(*const (zx_abi).zx_type_14, operand_44);
                }, ((state_10).pair).@"1", }));

                break :block_47 @as(*const (zx_abi).zx_type_16, operand_46);
            }, });

            break :block_49 @as(*const (zx_abi).zx_type_18, operand_48);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = (((value_1).pair).@"0").total;
        const operand_2 = (((value_18).pair).@"0").total;
        const operand_3 = (((value_18).pair).@"0").previous;
        const operand_4 = ((value_18).pair).@"1";
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

