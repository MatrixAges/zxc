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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ OutOfMemory, }!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    return block_5: {
        const operand_1 = (in).leaf;
        const operand_2 = (in).index;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_3).* = @as((zx_abi).zx_type_16, .{ operand_1, operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_16, operand_3);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ OutOfMemory, }!(zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_8: {
        const operand_6 = (in).leaf;
        const operand_7 = (in).index;

        break :block_8 @as((zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ operand_6, operand_7, null, });
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_44: {
        const operand_34 = block_39: {
            const operand_35 = (in).start;
            const operand_36 = (in).start;

            break :block_39 block_38: {
                const operand_37 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_37).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_35, .previous = operand_36, });

                break :block_38 @as(*const (zx_abi).zx_type_14, operand_37);
            };
        };

        const operand_40 = @as(u64, 0);
        const operand_41 = (in).count;

        break :block_44 block_43: {
            const operand_42 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_42).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_34, .index = operand_40, .limit = operand_41, });

            break :block_43 @as(*const (zx_abi).zx_type_15, operand_42);
        };
    };

    return block_33: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_4 = struct {
            index: u64,
            leaf: state_type_3,
            limit: u64,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .index = (operand_2).index, .leaf = state_type_3{ .previous = ((operand_2).leaf).previous, .total = ((operand_2).leaf).total, }, .limit = (operand_2).limit, };
        };

        const state_type_21 = struct { state_type_3, u64, };
        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_23: {
                const value_4: state_type_21 = block_22: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_20 = block_19: {
                        const operand_16 = (&operand_15);
                        const operand_17 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_16).index, .leaf = (operand_16).leaf, .limit = (operand_16).limit, .zx_origin = operand_16, }));

                        break :block_19 (if (((operand_17).@"2" != null)) ((operand_17).@"2".?).* else block_18: {
                            break :block_18 @as((zx_abi).zx_type_16, .{ (operand_17).@"0", (operand_17).@"1", });
                        });
                    };

                    break :block_22 @as(state_type_21, .{ state_type_3{ .previous = ((operand_20).@"0").previous, .total = ((operand_20).@"0").total, }, (operand_20).@"1", });
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).leaf;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_4 = block_12: {
                    break :block_12 state_type_4{ .index = (value_5).index, .leaf = block_11: {
                        break :block_11 state_type_3{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_4 = value_8;
                const value_10: state_type_3 = (value_9).leaf;

                const value_11: state_type_4 = block_10: {
                    break :block_10 state_type_4{ .index = (value_9).index, .leaf = block_9: {
                        break :block_9 state_type_3{ .previous = ((value_4).@"0").total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;

                const value_13: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_23 value_13;
            };

            state_changed_7 = true;
        }

        break :block_33 block_32: {
            const operand_24 = ((value_1).leaf).total;
            const operand_25 = ((state_1).leaf).total;
            const operand_26 = ((state_1).leaf).previous;
            const operand_27 = (state_1).index;
            const operand_28 = @as(i64, 0);
            const operand_29 = (in).values;

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_30).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_24, .total = operand_25, .previous = operand_26, .steps = operand_27, .other = operand_28, .values = operand_29, });

                break :block_31 @as(*const (zx_abi).zx_type_13, operand_30);
            };
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_81: {
        const operand_73 = block_78: {
            const operand_74 = (in).start;
            const operand_75 = (in).start;

            break :block_78 block_77: {
                const operand_76 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_76).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_74, .previous = operand_75, });

                break :block_77 @as(*const (zx_abi).zx_type_14, operand_76);
            };
        };

        const operand_79 = @as(u64, 0);
        const operand_80 = (in).count;

        break :block_81 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_73, .index = operand_79, .limit = operand_80, });
    };

    const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_72: {
        const operand_54 = value_1;
        var state_53: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_54;
        var state_changed_55 = false;

        while (((state_53).index < (state_53).limit)) {
            state_53 = block_70: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_69: {
                    break :block_69 (try function_0_value(allocator, state_53));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_53;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_68: {
                    break :block_68 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_67: {
                    break :block_67 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_66: {
                        break :block_66 block_65: {
                            const operand_64 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_64).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_62: {
                                break :block_62 (&value_6);
                            }).previous, .total = (block_63: {
                                break :block_63 value_7;
                            } + @as(i64, 1)), });

                            break :block_65 @as(*const (zx_abi).zx_type_14, operand_64);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_61: {
                    break :block_61 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_60: {
                        break :block_60 block_59: {
                            const operand_58 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_58).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_57: {
                                break :block_57 (&value_10);
                            }).total, });

                            break :block_59 @as(*const (zx_abi).zx_type_14, operand_58);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_56: {
                    break :block_56 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_70 value_13;
            };

            state_changed_55 = true;
        }

        break :block_72 (if (state_changed_55) state_53 else operand_54);
    };

    return block_52: {
        const operand_46 = ((value_1).leaf).total;
        const operand_47 = ((value_14).leaf).total;
        const operand_48 = ((value_14).leaf).previous;
        const operand_49 = (value_14).index;
        const operand_50 = @as(i64, 0);
        const operand_51 = (in).values;

        break :block_52 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_46, .total = operand_47, .previous = operand_48, .steps = operand_49, .other = operand_50, .values = operand_51, });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_118: {
        const operand_110 = block_115: {
            const operand_111 = (in).start;
            const operand_112 = (in).start;

            break :block_115 block_114: {
                const operand_113 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_113).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_111, .previous = operand_112, });

                break :block_114 @as(*const (zx_abi).zx_type_14, operand_113);
            };
        };

        const operand_116 = @as(u64, 0);
        const operand_117 = (in).count;

        break :block_118 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_110, .index = operand_116, .limit = operand_117, });
    };

    const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_109: {
        const operand_91 = value_1;
        var state_90: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_91;
        var state_changed_92 = false;

        while (((state_90).index < (state_90).limit)) {
            state_90 = block_107: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_106: {
                    break :block_106 (try function_0_value(allocator, state_90));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_90;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_105: {
                    break :block_105 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_104: {
                    break :block_104 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_103: {
                        break :block_103 block_102: {
                            const operand_101 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_101).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_99: {
                                break :block_99 (&value_6);
                            }).previous, .total = (block_100: {
                                break :block_100 value_7;
                            } + @as(i64, 1)), });

                            break :block_102 @as(*const (zx_abi).zx_type_14, operand_101);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_98: {
                    break :block_98 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_97: {
                        break :block_97 block_96: {
                            const operand_95 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_95).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_94: {
                                break :block_94 (&value_10);
                            }).total, });

                            break :block_96 @as(*const (zx_abi).zx_type_14, operand_95);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_93: {
                    break :block_93 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_107 value_13;
            };

            state_changed_92 = true;
        }

        break :block_109 (if (state_changed_92) state_90 else operand_91);
    };

    return block_89: {
        const operand_83 = ((value_1).leaf).total;
        const operand_84 = ((value_14).leaf).total;
        const operand_85 = ((value_14).leaf).previous;
        const operand_86 = (value_14).index;
        const operand_87 = @as(i64, 0);
        const operand_88 = (in).values;

        break :block_89 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_83, .total = operand_84, .previous = operand_85, .steps = operand_86, .other = operand_87, .values = operand_88, });
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

    const value_1: *const (zx_abi).zx_type_15 = block_162: {
        const operand_152 = block_157: {
            const operand_153 = (in).start;
            const operand_154 = (in).start;

            break :block_157 block_156: {
                const operand_155 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_155).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_153, .previous = operand_154, });

                break :block_156 @as(*const (zx_abi).zx_type_14, operand_155);
            };
        };

        const operand_158 = @as(u64, 0);
        const operand_159 = (in).count;

        break :block_162 block_161: {
            const operand_160 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_160).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_152, .index = operand_158, .limit = operand_159, });

            break :block_161 @as(*const (zx_abi).zx_type_15, operand_160);
        };
    };

    return block_151: {
        const state_type_121 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_122 = struct {
            index: u64,
            leaf: state_type_121,
            limit: u64,
        };
        const operand_124 = block_123: {
            const operand_120 = value_1;

            break :block_123 state_type_122{ .index = (operand_120).index, .leaf = state_type_121{ .previous = ((operand_120).leaf).previous, .total = ((operand_120).leaf).total, }, .limit = (operand_120).limit, };
        };

        const state_type_139 = struct { state_type_121, u64, };
        var state_119: state_type_122 = operand_124;
        var state_changed_125 = false;

        while (((state_119).index < (state_119).limit)) {
            state_119 = block_141: {
                const value_4: state_type_139 = block_140: {
                    const operand_131 = state_119;
                    const operand_132 = (zx_abi).zx_type_14{ .previous = ((operand_131).leaf).previous, .total = ((operand_131).leaf).total, };
                    const operand_133 = (zx_abi).zx_type_15{ .index = (operand_131).index, .leaf = (&operand_132), .limit = (operand_131).limit, };

                    const operand_138 = block_137: {
                        const operand_134 = (&operand_133);
                        const operand_135 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_134).index, .leaf = (operand_134).leaf, .limit = (operand_134).limit, .zx_origin = operand_134, }));

                        break :block_137 (if (((operand_135).@"2" != null)) ((operand_135).@"2".?).* else block_136: {
                            break :block_136 @as((zx_abi).zx_type_16, .{ (operand_135).@"0", (operand_135).@"1", });
                        });
                    };

                    break :block_140 @as(state_type_139, .{ state_type_121{ .previous = ((operand_138).@"0").previous, .total = ((operand_138).@"0").total, }, (operand_138).@"1", });
                };
                const value_5: state_type_122 = state_119;
                const value_6: state_type_121 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_122 = block_130: {
                    break :block_130 state_type_122{ .index = (value_5).index, .leaf = block_129: {
                        break :block_129 state_type_121{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_122 = value_8;
                const value_10: state_type_121 = (value_9).leaf;

                const value_11: state_type_122 = block_128: {
                    break :block_128 state_type_122{ .index = (value_9).index, .leaf = block_127: {
                        break :block_127 state_type_121{ .previous = ((value_4).@"0").total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_122 = value_11;

                const value_13: state_type_122 = block_126: {
                    break :block_126 state_type_122{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_141 value_13;
            };

            state_changed_125 = true;
        }

        break :block_151 block_150: {
            const operand_142 = ((value_1).leaf).total;
            const operand_143 = ((state_119).leaf).total;
            const operand_144 = ((state_119).leaf).previous;
            const operand_145 = (state_119).index;
            const operand_146 = @as(i64, 0);
            const operand_147 = (in).values;

            break :block_150 block_149: {
                const operand_148 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_148).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_142, .total = operand_143, .previous = operand_144, .steps = operand_145, .other = operand_146, .values = operand_147, });

                break :block_149 @as(*const (zx_abi).zx_type_13, operand_148);
            };
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_44: {
        const operand_34 = block_39: {
            const operand_35 = (in).start;
            const operand_36 = (in).start;

            break :block_39 block_38: {
                const operand_37 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_37).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_35, .previous = operand_36, });

                break :block_38 @as(*const (zx_abi).zx_type_14, operand_37);
            };
        };

        const operand_40 = @as(u64, 0);
        const operand_41 = (in).count;

        break :block_44 block_43: {
            const operand_42 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_42).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_34, .index = operand_40, .limit = operand_41, });

            break :block_43 @as(*const (zx_abi).zx_type_15, operand_42);
        };
    };

    return block_33: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_4 = struct {
            index: u64,
            leaf: state_type_3,
            limit: u64,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .index = (operand_2).index, .leaf = state_type_3{ .previous = ((operand_2).leaf).previous, .total = ((operand_2).leaf).total, }, .limit = (operand_2).limit, };
        };

        const state_type_21 = struct { state_type_3, u64, };
        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_23: {
                const value_4: state_type_21 = block_22: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_20 = block_19: {
                        const operand_16 = (&operand_15);
                        const operand_17 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_16).index, .leaf = (operand_16).leaf, .limit = (operand_16).limit, .zx_origin = operand_16, }));

                        break :block_19 (if (((operand_17).@"2" != null)) ((operand_17).@"2".?).* else block_18: {
                            break :block_18 @as((zx_abi).zx_type_16, .{ (operand_17).@"0", (operand_17).@"1", });
                        });
                    };

                    break :block_22 @as(state_type_21, .{ state_type_3{ .previous = ((operand_20).@"0").previous, .total = ((operand_20).@"0").total, }, (operand_20).@"1", });
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).leaf;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_4 = block_12: {
                    break :block_12 state_type_4{ .index = (value_5).index, .leaf = block_11: {
                        break :block_11 state_type_3{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_4 = value_8;
                const value_10: state_type_3 = (value_9).leaf;

                const value_11: state_type_4 = block_10: {
                    break :block_10 state_type_4{ .index = (value_9).index, .leaf = block_9: {
                        break :block_9 state_type_3{ .previous = ((value_4).@"0").total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;

                const value_13: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_23 value_13;
            };

            state_changed_7 = true;
        }

        break :block_33 block_32: {
            const operand_24 = ((value_1).leaf).total;
            const operand_25 = ((state_1).leaf).total;
            const operand_26 = ((state_1).leaf).previous;
            const operand_27 = (state_1).index;
            const operand_28 = @as(i64, 0);
            const operand_29 = (in).values;

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_30).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_24, .total = operand_25, .previous = operand_26, .steps = operand_27, .other = operand_28, .values = operand_29, });

                break :block_31 @as(*const (zx_abi).zx_type_13, operand_30);
            };
        };
    };
}

