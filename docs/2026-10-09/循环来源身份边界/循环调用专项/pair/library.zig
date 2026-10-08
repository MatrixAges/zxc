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

    const value_1: *const (zx_abi).zx_type_15 = block_42: {
        const operand_32 = block_37: {
            const operand_33 = (in).start;
            const operand_34 = (in).start;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_35).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_33, .previous = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_14, operand_35);
            };
        };

        const operand_38 = @as(u64, 0);
        const operand_39 = (in).count;

        break :block_42 block_41: {
            const operand_40 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_40).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_32, .index = operand_38, .limit = operand_39, });

            break :block_41 @as(*const (zx_abi).zx_type_15, operand_40);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_31: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_27: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_26: {
                    break :block_26 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_25: {
                    break :block_25 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_24: {
                    break :block_24 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_23: {
                        break :block_23 block_22: {
                            const operand_21 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_21).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_19: {
                                break :block_19 value_6;
                            }).previous, .total = (block_20: {
                                break :block_20 value_7;
                            } + @as(i64, 1)), });

                            break :block_22 @as(*const (zx_abi).zx_type_14, operand_21);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_17: {
                        break :block_17 block_16: {
                            const operand_15 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_15).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_14: {
                                break :block_14 value_10;
                            }).total, });

                            break :block_16 @as(*const (zx_abi).zx_type_14, operand_15);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_27 value_13;
            };

            state_changed_12 = true;
        }

        break :block_31 (if (state_changed_12) block_30: {
            break :block_30 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_28).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_29 @as(*const (zx_abi).zx_type_15, operand_28);
            });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_78: {
        const operand_70 = block_75: {
            const operand_71 = (in).start;
            const operand_72 = (in).start;

            break :block_75 block_74: {
                const operand_73 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_73).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_71, .previous = operand_72, });

                break :block_74 @as(*const (zx_abi).zx_type_14, operand_73);
            };
        };

        const operand_76 = @as(u64, 0);
        const operand_77 = (in).count;

        break :block_78 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_70, .index = operand_76, .limit = operand_77, });
    };

    const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_69: {
        const operand_51 = value_1;
        var state_50: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_51;
        var state_changed_52 = false;

        while (((state_50).index < (state_50).limit)) {
            state_50 = block_67: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_66: {
                    break :block_66 (try function_0_value(allocator, state_50));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_50;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_65: {
                    break :block_65 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_64: {
                    break :block_64 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_63: {
                        break :block_63 block_62: {
                            const operand_61 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_61).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_59: {
                                break :block_59 (&value_6);
                            }).previous, .total = (block_60: {
                                break :block_60 value_7;
                            } + @as(i64, 1)), });

                            break :block_62 @as(*const (zx_abi).zx_type_14, operand_61);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_58: {
                    break :block_58 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_57: {
                        break :block_57 block_56: {
                            const operand_55 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_55).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_54: {
                                break :block_54 (&value_10);
                            }).total, });

                            break :block_56 @as(*const (zx_abi).zx_type_14, operand_55);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_53: {
                    break :block_53 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_67 value_13;
            };

            state_changed_52 = true;
        }

        break :block_69 (if (state_changed_52) state_50 else operand_51);
    };

    return block_49: {
        const operand_43 = ((value_1).leaf).total;
        const operand_44 = ((value_14).leaf).total;
        const operand_45 = ((value_14).leaf).previous;
        const operand_46 = (value_14).index;
        const operand_47 = @as(i64, 0);
        const operand_48 = (in).values;

        break :block_49 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_43, .total = operand_44, .previous = operand_45, .steps = operand_46, .other = operand_47, .values = operand_48, });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_114: {
        const operand_106 = block_111: {
            const operand_107 = (in).start;
            const operand_108 = (in).start;

            break :block_111 block_110: {
                const operand_109 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_109).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_107, .previous = operand_108, });

                break :block_110 @as(*const (zx_abi).zx_type_14, operand_109);
            };
        };

        const operand_112 = @as(u64, 0);
        const operand_113 = (in).count;

        break :block_114 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_106, .index = operand_112, .limit = operand_113, });
    };

    const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_105: {
        const operand_87 = value_1;
        var state_86: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_87;
        var state_changed_88 = false;

        while (((state_86).index < (state_86).limit)) {
            state_86 = block_103: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_102: {
                    break :block_102 (try function_0_value(allocator, state_86));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_86;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_101: {
                    break :block_101 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_100: {
                    break :block_100 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_99: {
                        break :block_99 block_98: {
                            const operand_97 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_97).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_95: {
                                break :block_95 (&value_6);
                            }).previous, .total = (block_96: {
                                break :block_96 value_7;
                            } + @as(i64, 1)), });

                            break :block_98 @as(*const (zx_abi).zx_type_14, operand_97);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_94: {
                    break :block_94 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_93: {
                        break :block_93 block_92: {
                            const operand_91 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_91).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_90: {
                                break :block_90 (&value_10);
                            }).total, });

                            break :block_92 @as(*const (zx_abi).zx_type_14, operand_91);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_89: {
                    break :block_89 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_103 value_13;
            };

            state_changed_88 = true;
        }

        break :block_105 (if (state_changed_88) state_86 else operand_87);
    };

    return block_85: {
        const operand_79 = ((value_1).leaf).total;
        const operand_80 = ((value_14).leaf).total;
        const operand_81 = ((value_14).leaf).previous;
        const operand_82 = (value_14).index;
        const operand_83 = @as(i64, 0);
        const operand_84 = (in).values;

        break :block_85 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_79, .total = operand_80, .previous = operand_81, .steps = operand_82, .other = operand_83, .values = operand_84, });
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

    const value_1: *const (zx_abi).zx_type_15 = block_156: {
        const operand_146 = block_151: {
            const operand_147 = (in).start;
            const operand_148 = (in).start;

            break :block_151 block_150: {
                const operand_149 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_149).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_147, .previous = operand_148, });

                break :block_150 @as(*const (zx_abi).zx_type_14, operand_149);
            };
        };

        const operand_152 = @as(u64, 0);
        const operand_153 = (in).count;

        break :block_156 block_155: {
            const operand_154 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_154).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_146, .index = operand_152, .limit = operand_153, });

            break :block_155 @as(*const (zx_abi).zx_type_15, operand_154);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_145: {
        const operand_125 = value_1;
        var state_124: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_125).index, .leaf = (operand_125).leaf, .limit = (operand_125).limit, .zx_origin = operand_125, };
        var state_changed_126 = false;

        while (((state_124).index < (state_124).limit)) {
            state_124 = block_141: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_140: {
                    break :block_140 (try function_0_value(allocator, state_124));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_124;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_139: {
                    break :block_139 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_138: {
                    break :block_138 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_137: {
                        break :block_137 block_136: {
                            const operand_135 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_135).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_133: {
                                break :block_133 value_6;
                            }).previous, .total = (block_134: {
                                break :block_134 value_7;
                            } + @as(i64, 1)), });

                            break :block_136 @as(*const (zx_abi).zx_type_14, operand_135);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_132: {
                    break :block_132 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_131: {
                        break :block_131 block_130: {
                            const operand_129 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_129).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_128: {
                                break :block_128 value_10;
                            }).total, });

                            break :block_130 @as(*const (zx_abi).zx_type_14, operand_129);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_127: {
                    break :block_127 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_141 value_13;
            };

            state_changed_126 = true;
        }

        break :block_145 (if (state_changed_126) block_144: {
            break :block_144 (if (((state_124).zx_origin != null)) (state_124).zx_origin.? else block_143: {
                const operand_142 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_142).* = (zx_abi).zx_type_15{ .index = (state_124).index, .leaf = (state_124).leaf, .limit = (state_124).limit, };

                break :block_143 @as(*const (zx_abi).zx_type_15, operand_142);
            });
        } else operand_125);
    };

    return block_123: {
        const operand_115 = ((value_1).leaf).total;
        const operand_116 = ((value_14).leaf).total;
        const operand_117 = ((value_14).leaf).previous;
        const operand_118 = (value_14).index;
        const operand_119 = @as(i64, 0);
        const operand_120 = (in).values;

        break :block_123 block_122: {
            const operand_121 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_121).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_115, .total = operand_116, .previous = operand_117, .steps = operand_118, .other = operand_119, .values = operand_120, });

            break :block_122 @as(*const (zx_abi).zx_type_13, operand_121);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_42: {
        const operand_32 = block_37: {
            const operand_33 = (in).start;
            const operand_34 = (in).start;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_35).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_33, .previous = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_14, operand_35);
            };
        };

        const operand_38 = @as(u64, 0);
        const operand_39 = (in).count;

        break :block_42 block_41: {
            const operand_40 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_40).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_32, .index = operand_38, .limit = operand_39, });

            break :block_41 @as(*const (zx_abi).zx_type_15, operand_40);
        };
    };

    const value_14: *const (zx_abi).zx_type_15 = block_31: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_27: {
                const value_4: (zx_abi).value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_26: {
                    break :block_26 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_25: {
                    break :block_25 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_24: {
                    break :block_24 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_23: {
                        break :block_23 block_22: {
                            const operand_21 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_21).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_19: {
                                break :block_19 value_6;
                            }).previous, .total = (block_20: {
                                break :block_20 value_7;
                            } + @as(i64, 1)), });

                            break :block_22 @as(*const (zx_abi).zx_type_14, operand_21);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_18: {
                    break :block_18 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_17: {
                        break :block_17 block_16: {
                            const operand_15 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_15).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).@"0").total, .total = (block_14: {
                                break :block_14 value_10;
                            }).total, });

                            break :block_16 @as(*const (zx_abi).zx_type_14, operand_15);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;

                const value_13: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_13: {
                    break :block_13 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = ((value_4).@"1" + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_27 value_13;
            };

            state_changed_12 = true;
        }

        break :block_31 (if (state_changed_12) block_30: {
            break :block_30 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_28).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_29 @as(*const (zx_abi).zx_type_15, operand_28);
            });
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

