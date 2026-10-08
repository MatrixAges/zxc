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

    const value_1: *const (zx_abi).zx_type_15 = block_47: {
        const operand_37 = block_42: {
            const operand_38 = (in).start;
            const operand_39 = (in).start;

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_40).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_38, .previous = operand_39, });

                break :block_41 @as(*const (zx_abi).zx_type_14, operand_40);
            };
        };

        const operand_43 = @as(u64, 0);
        const operand_44 = (in).count;

        break :block_47 block_46: {
            const operand_45 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_45).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_37, .index = operand_43, .limit = operand_44, });

            break :block_46 @as(*const (zx_abi).zx_type_15, operand_45);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_36: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_14 = struct {
            index: u64,
            leaf: state_type_13,
            limit: u64,
        };
        const state_type_28 = struct { state_type_13, u64, };
        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .leaf = state_type_13{ .previous = ((operand_11).leaf).previous, .total = ((operand_11).leaf).total, }, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_30: {
                const value_4: state_type_28 = block_29: {
                    const operand_20 = state_10;
                    const operand_21 = (zx_abi).zx_type_14{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, };
                    const operand_22 = (zx_abi).zx_type_15{ .index = (operand_20).index, .leaf = (&operand_21), .limit = (operand_20).limit, };

                    const operand_27 = block_26: {
                        const operand_23 = (&operand_22);
                        const operand_24 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_23).index, .leaf = (operand_23).leaf, .limit = (operand_23).limit, .zx_origin = operand_23, }));

                        break :block_26 (if (((operand_24).@"2" != null)) ((operand_24).@"2".?).* else block_25: {
                            break :block_25 @as((zx_abi).zx_type_16, .{ (operand_24).@"0", (operand_24).@"1", });
                        });
                    };

                    break :block_29 @as(state_type_28, .{ state_type_13{ .previous = ((operand_27).@"0").previous, .total = ((operand_27).@"0").total, }, (operand_27).@"1", });
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_14 = block_19: {
                    break :block_19 state_type_14{ .index = (value_5).index, .leaf = block_18: {
                        break :block_18 state_type_13{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_14 = value_8;
                const value_10: state_type_13 = (value_9).leaf;

                const value_11: state_type_14 = block_17: {
                    break :block_17 state_type_14{ .index = (value_9).index, .leaf = block_16: {
                        break :block_16 state_type_13{ .previous = ((value_4).@"0").total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_14 = value_11;

                const value_13: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_30 value_13;
            };

            state_changed_12 = true;
        }

        break :block_36 (if (state_changed_12) block_35: {
            const operand_34 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_34).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_32).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).leaf).previous, .total = ((state_10).leaf).total, });

                break :block_33 @as(*const (zx_abi).zx_type_14, operand_32);
            }, .limit = (state_10).limit, });

            break :block_35 @as(*const (zx_abi).zx_type_15, operand_34);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).leaf).total;
        const operand_2 = ((value_14).leaf).total;
        const operand_3 = ((value_14).leaf).previous;
        const operand_4 = (value_14).index;
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_83: {
        const operand_75 = block_80: {
            const operand_76 = (in).start;
            const operand_77 = (in).start;

            break :block_80 block_79: {
                const operand_78 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_78).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_76, .previous = operand_77, });

                break :block_79 @as(*const (zx_abi).zx_type_14, operand_78);
            };
        };

        const operand_81 = @as(u64, 0);
        const operand_82 = (in).count;

        break :block_83 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_75, .index = operand_81, .limit = operand_82, });
    };

    const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_74: {
        const operand_56 = value_1;
        var state_55: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_56;
        var state_changed_57 = false;

        while (((state_55).index < (state_55).limit)) {
            state_55 = block_72: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_71: {
                    break :block_71 (try function_0_value(allocator, state_55));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_55;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_70: {
                    break :block_70 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_69: {
                    break :block_69 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_68: {
                        break :block_68 block_67: {
                            const operand_66 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_66).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_64: {
                                break :block_64 (&value_6);
                            }).previous, .total = (block_65: {
                                break :block_65 value_7;
                            } + @as(i64, 1)), });

                            break :block_67 @as(*const (zx_abi).zx_type_14, operand_66);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_63: {
                    break :block_63 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_62: {
                        break :block_62 block_61: {
                            const operand_60 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_60).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_59: {
                                break :block_59 (&value_10);
                            }).total, });

                            break :block_61 @as(*const (zx_abi).zx_type_14, operand_60);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_58: {
                    break :block_58 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_72 value_13;
            };

            state_changed_57 = true;
        }

        break :block_74 (if (state_changed_57) state_55 else operand_56);
    };

    return block_54: {
        const operand_48 = ((value_1).leaf).total;
        const operand_49 = ((value_14).leaf).total;
        const operand_50 = ((value_14).leaf).previous;
        const operand_51 = (value_14).index;
        const operand_52 = @as(i64, 0);
        const operand_53 = (in).values;

        break :block_54 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_48, .total = operand_49, .previous = operand_50, .steps = operand_51, .other = operand_52, .values = operand_53, });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_119: {
        const operand_111 = block_116: {
            const operand_112 = (in).start;
            const operand_113 = (in).start;

            break :block_116 block_115: {
                const operand_114 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_114).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_112, .previous = operand_113, });

                break :block_115 @as(*const (zx_abi).zx_type_14, operand_114);
            };
        };

        const operand_117 = @as(u64, 0);
        const operand_118 = (in).count;

        break :block_119 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_111, .index = operand_117, .limit = operand_118, });
    };

    const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_110: {
        const operand_92 = value_1;
        var state_91: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_92;
        var state_changed_93 = false;

        while (((state_91).index < (state_91).limit)) {
            state_91 = block_108: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_107: {
                    break :block_107 (try function_0_value(allocator, state_91));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_91;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_106: {
                    break :block_106 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_105: {
                    break :block_105 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_104: {
                        break :block_104 block_103: {
                            const operand_102 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_102).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_100: {
                                break :block_100 (&value_6);
                            }).previous, .total = (block_101: {
                                break :block_101 value_7;
                            } + @as(i64, 1)), });

                            break :block_103 @as(*const (zx_abi).zx_type_14, operand_102);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_99: {
                    break :block_99 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_98: {
                        break :block_98 block_97: {
                            const operand_96 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_96).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_95: {
                                break :block_95 (&value_10);
                            }).total, });

                            break :block_97 @as(*const (zx_abi).zx_type_14, operand_96);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_94: {
                    break :block_94 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_108 value_13;
            };

            state_changed_93 = true;
        }

        break :block_110 (if (state_changed_93) state_91 else operand_92);
    };

    return block_90: {
        const operand_84 = ((value_1).leaf).total;
        const operand_85 = ((value_14).leaf).total;
        const operand_86 = ((value_14).leaf).previous;
        const operand_87 = (value_14).index;
        const operand_88 = @as(i64, 0);
        const operand_89 = (in).values;

        break :block_90 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_84, .total = operand_85, .previous = operand_86, .steps = operand_87, .other = operand_88, .values = operand_89, });
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

    const value_1: *const (zx_abi).zx_type_15 = block_166: {
        const operand_156 = block_161: {
            const operand_157 = (in).start;
            const operand_158 = (in).start;

            break :block_161 block_160: {
                const operand_159 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_159).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_157, .previous = operand_158, });

                break :block_160 @as(*const (zx_abi).zx_type_14, operand_159);
            };
        };

        const operand_162 = @as(u64, 0);
        const operand_163 = (in).count;

        break :block_166 block_165: {
            const operand_164 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_164).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_156, .index = operand_162, .limit = operand_163, });

            break :block_165 @as(*const (zx_abi).zx_type_15, operand_164);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_155: {
        const operand_130 = value_1;

        const state_type_132 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_133 = struct {
            index: u64,
            leaf: state_type_132,
            limit: u64,
        };
        const state_type_147 = struct { state_type_132, u64, };
        var state_129: state_type_133 = state_type_133{ .index = (operand_130).index, .leaf = state_type_132{ .previous = ((operand_130).leaf).previous, .total = ((operand_130).leaf).total, }, .limit = (operand_130).limit, };
        var state_changed_131 = false;

        while (((state_129).index < (state_129).limit)) {
            state_129 = block_149: {
                const value_4: state_type_147 = block_148: {
                    const operand_139 = state_129;
                    const operand_140 = (zx_abi).zx_type_14{ .previous = ((operand_139).leaf).previous, .total = ((operand_139).leaf).total, };
                    const operand_141 = (zx_abi).zx_type_15{ .index = (operand_139).index, .leaf = (&operand_140), .limit = (operand_139).limit, };

                    const operand_146 = block_145: {
                        const operand_142 = (&operand_141);
                        const operand_143 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_142).index, .leaf = (operand_142).leaf, .limit = (operand_142).limit, .zx_origin = operand_142, }));

                        break :block_145 (if (((operand_143).@"2" != null)) ((operand_143).@"2".?).* else block_144: {
                            break :block_144 @as((zx_abi).zx_type_16, .{ (operand_143).@"0", (operand_143).@"1", });
                        });
                    };

                    break :block_148 @as(state_type_147, .{ state_type_132{ .previous = ((operand_146).@"0").previous, .total = ((operand_146).@"0").total, }, (operand_146).@"1", });
                };
                const value_5: state_type_133 = state_129;
                const value_6: state_type_132 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_133 = block_138: {
                    break :block_138 state_type_133{ .index = (value_5).index, .leaf = block_137: {
                        break :block_137 state_type_132{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_133 = value_8;
                const value_10: state_type_132 = (value_9).leaf;

                const value_11: state_type_133 = block_136: {
                    break :block_136 state_type_133{ .index = (value_9).index, .leaf = block_135: {
                        break :block_135 state_type_132{ .previous = ((value_4).@"0").total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_133 = value_11;

                const value_13: state_type_133 = block_134: {
                    break :block_134 state_type_133{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_149 value_13;
            };

            state_changed_131 = true;
        }

        break :block_155 (if (state_changed_131) block_154: {
            const operand_153 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_153).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_129).index, .leaf = block_152: {
                const operand_151 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_151).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_129).leaf).previous, .total = ((state_129).leaf).total, });

                break :block_152 @as(*const (zx_abi).zx_type_14, operand_151);
            }, .limit = (state_129).limit, });

            break :block_154 @as(*const (zx_abi).zx_type_15, operand_153);
        } else operand_130);
    };

    return block_128: {
        const operand_120 = ((value_1).leaf).total;
        const operand_121 = ((value_14).leaf).total;
        const operand_122 = ((value_14).leaf).previous;
        const operand_123 = (value_14).index;
        const operand_124 = @as(i64, 0);
        const operand_125 = (in).values;

        break :block_128 block_127: {
            const operand_126 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_126).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_120, .total = operand_121, .previous = operand_122, .steps = operand_123, .other = operand_124, .values = operand_125, });

            break :block_127 @as(*const (zx_abi).zx_type_13, operand_126);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_47: {
        const operand_37 = block_42: {
            const operand_38 = (in).start;
            const operand_39 = (in).start;

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_40).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_38, .previous = operand_39, });

                break :block_41 @as(*const (zx_abi).zx_type_14, operand_40);
            };
        };

        const operand_43 = @as(u64, 0);
        const operand_44 = (in).count;

        break :block_47 block_46: {
            const operand_45 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_45).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_37, .index = operand_43, .limit = operand_44, });

            break :block_46 @as(*const (zx_abi).zx_type_15, operand_45);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_36: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_14 = struct {
            index: u64,
            leaf: state_type_13,
            limit: u64,
        };
        const state_type_28 = struct { state_type_13, u64, };
        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .leaf = state_type_13{ .previous = ((operand_11).leaf).previous, .total = ((operand_11).leaf).total, }, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_30: {
                const value_4: state_type_28 = block_29: {
                    const operand_20 = state_10;
                    const operand_21 = (zx_abi).zx_type_14{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, };
                    const operand_22 = (zx_abi).zx_type_15{ .index = (operand_20).index, .leaf = (&operand_21), .limit = (operand_20).limit, };

                    const operand_27 = block_26: {
                        const operand_23 = (&operand_22);
                        const operand_24 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_23).index, .leaf = (operand_23).leaf, .limit = (operand_23).limit, .zx_origin = operand_23, }));

                        break :block_26 (if (((operand_24).@"2" != null)) ((operand_24).@"2".?).* else block_25: {
                            break :block_25 @as((zx_abi).zx_type_16, .{ (operand_24).@"0", (operand_24).@"1", });
                        });
                    };

                    break :block_29 @as(state_type_28, .{ state_type_13{ .previous = ((operand_27).@"0").previous, .total = ((operand_27).@"0").total, }, (operand_27).@"1", });
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_14 = block_19: {
                    break :block_19 state_type_14{ .index = (value_5).index, .leaf = block_18: {
                        break :block_18 state_type_13{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_14 = value_8;
                const value_10: state_type_13 = (value_9).leaf;

                const value_11: state_type_14 = block_17: {
                    break :block_17 state_type_14{ .index = (value_9).index, .leaf = block_16: {
                        break :block_16 state_type_13{ .previous = ((value_4).@"0").total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_14 = value_11;

                const value_13: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_30 value_13;
            };

            state_changed_12 = true;
        }

        break :block_36 (if (state_changed_12) block_35: {
            const operand_34 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_34).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_32).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).leaf).previous, .total = ((state_10).leaf).total, });

                break :block_33 @as(*const (zx_abi).zx_type_14, operand_32);
            }, .limit = (state_10).limit, });

            break :block_35 @as(*const (zx_abi).zx_type_15, operand_34);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).leaf).total;
        const operand_2 = ((value_14).leaf).total;
        const operand_3 = ((value_14).leaf).previous;
        const operand_4 = (value_14).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

