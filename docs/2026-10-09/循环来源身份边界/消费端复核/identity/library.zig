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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!*const (zx_abi).zx_type_15 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ }!(zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_15 = block_43: {
        const operand_33 = block_38: {
            const operand_34 = (in).start;
            const operand_35 = (in).start;

            break :block_38 block_37: {
                const operand_36 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_36).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_34, .previous = operand_35, });

                break :block_37 @as(*const (zx_abi).zx_type_14, operand_36);
            };
        };

        const operand_39 = @as(u64, 0);
        const operand_40 = (in).count;

        break :block_43 block_42: {
            const operand_41 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_41).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_33, .index = operand_39, .limit = operand_40, });

            break :block_42 @as(*const (zx_abi).zx_type_15, operand_41);
        };
    };

    return block_32: {
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

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_22: {
                const value_4: state_type_4 = block_21: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_20 = block_19: {
                        const operand_16 = (&operand_15);
                        const operand_17 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_16).index, .leaf = (operand_16).leaf, .limit = (operand_16).limit, .zx_origin = operand_16, }));

                        break :block_19 (if (((operand_17).zx_origin != null)) ((operand_17).zx_origin.?).* else block_18: {
                            break :block_18 (zx_abi).zx_type_15{ .index = (operand_17).index, .leaf = (operand_17).leaf, .limit = (operand_17).limit, };
                        });
                    };

                    break :block_21 state_type_4{ .index = (operand_20).index, .leaf = state_type_3{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, }, .limit = (operand_20).limit, };
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
                        break :block_9 state_type_3{ .previous = ((value_4).leaf).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_22 value_14;
            };

            state_changed_7 = true;
        }

        break :block_32 block_31: {
            const operand_23 = ((value_1).leaf).total;
            const operand_24 = ((state_1).leaf).total;
            const operand_25 = ((state_1).leaf).previous;
            const operand_26 = (state_1).index;
            const operand_27 = @as(i64, 0);
            const operand_28 = (in).values;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_23, .total = operand_24, .previous = operand_25, .steps = operand_26, .other = operand_27, .values = operand_28, });

                break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
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

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_72: {
        const operand_53 = value_1;
        var state_52: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_53;
        var state_changed_54 = false;

        while (((state_52).index < (state_52).limit)) {
            state_52 = block_70: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_69: {
                    break :block_69 (try function_0_value(allocator, state_52));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_52;
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

                            (operand_58).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_57: {
                                break :block_57 (&value_10);
                            }).total, });

                            break :block_59 @as(*const (zx_abi).zx_type_14, operand_58);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_56: {
                    break :block_56 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_55: {
                        break :block_55 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_70 value_14;
            };

            state_changed_54 = true;
        }

        break :block_72 (if (state_changed_54) state_52 else operand_53);
    };

    return block_51: {
        const operand_45 = ((value_1).leaf).total;
        const operand_46 = ((value_15).leaf).total;
        const operand_47 = ((value_15).leaf).previous;
        const operand_48 = (value_15).index;
        const operand_49 = @as(i64, 0);
        const operand_50 = (in).values;

        break :block_51 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_45, .total = operand_46, .previous = operand_47, .steps = operand_48, .other = operand_49, .values = operand_50, });
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

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_110: {
        const operand_91 = value_1;
        var state_90: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_91;
        var state_changed_92 = false;

        while (((state_90).index < (state_90).limit)) {
            state_90 = block_108: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_107: {
                    break :block_107 (try function_0_value(allocator, state_90));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_90;
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

                            (operand_96).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_95: {
                                break :block_95 (&value_10);
                            }).total, });

                            break :block_97 @as(*const (zx_abi).zx_type_14, operand_96);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_94: {
                    break :block_94 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_93: {
                        break :block_93 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_108 value_14;
            };

            state_changed_92 = true;
        }

        break :block_110 (if (state_changed_92) state_90 else operand_91);
    };

    return block_89: {
        const operand_83 = ((value_1).leaf).total;
        const operand_84 = ((value_15).leaf).total;
        const operand_85 = ((value_15).leaf).previous;
        const operand_86 = (value_15).index;
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
        const state_type_122 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_123 = struct {
            index: u64,
            leaf: state_type_122,
            limit: u64,
        };
        const operand_125 = block_124: {
            const operand_121 = value_1;

            break :block_124 state_type_123{ .index = (operand_121).index, .leaf = state_type_122{ .previous = ((operand_121).leaf).previous, .total = ((operand_121).leaf).total, }, .limit = (operand_121).limit, };
        };

        var state_120: state_type_123 = operand_125;
        var state_changed_126 = false;

        while (((state_120).index < (state_120).limit)) {
            state_120 = block_141: {
                const value_4: state_type_123 = block_140: {
                    const operand_132 = state_120;
                    const operand_133 = (zx_abi).zx_type_14{ .previous = ((operand_132).leaf).previous, .total = ((operand_132).leaf).total, };
                    const operand_134 = (zx_abi).zx_type_15{ .index = (operand_132).index, .leaf = (&operand_133), .limit = (operand_132).limit, };

                    const operand_139 = block_138: {
                        const operand_135 = (&operand_134);
                        const operand_136 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_135).index, .leaf = (operand_135).leaf, .limit = (operand_135).limit, .zx_origin = operand_135, }));

                        break :block_138 (if (((operand_136).zx_origin != null)) ((operand_136).zx_origin.?).* else block_137: {
                            break :block_137 (zx_abi).zx_type_15{ .index = (operand_136).index, .leaf = (operand_136).leaf, .limit = (operand_136).limit, };
                        });
                    };

                    break :block_140 state_type_123{ .index = (operand_139).index, .leaf = state_type_122{ .previous = ((operand_139).leaf).previous, .total = ((operand_139).leaf).total, }, .limit = (operand_139).limit, };
                };
                const value_5: state_type_123 = state_120;
                const value_6: state_type_122 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_123 = block_131: {
                    break :block_131 state_type_123{ .index = (value_5).index, .leaf = block_130: {
                        break :block_130 state_type_122{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_123 = value_8;
                const value_10: state_type_122 = (value_9).leaf;

                const value_11: state_type_123 = block_129: {
                    break :block_129 state_type_123{ .index = (value_9).index, .leaf = block_128: {
                        break :block_128 state_type_122{ .previous = ((value_4).leaf).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_123 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_123 = block_127: {
                    break :block_127 state_type_123{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_141 value_14;
            };

            state_changed_126 = true;
        }

        break :block_151 block_150: {
            const operand_142 = ((value_1).leaf).total;
            const operand_143 = ((state_120).leaf).total;
            const operand_144 = ((state_120).leaf).previous;
            const operand_145 = (state_120).index;
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

    const value_1: *const (zx_abi).zx_type_15 = block_43: {
        const operand_33 = block_38: {
            const operand_34 = (in).start;
            const operand_35 = (in).start;

            break :block_38 block_37: {
                const operand_36 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_36).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_34, .previous = operand_35, });

                break :block_37 @as(*const (zx_abi).zx_type_14, operand_36);
            };
        };

        const operand_39 = @as(u64, 0);
        const operand_40 = (in).count;

        break :block_43 block_42: {
            const operand_41 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_41).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_33, .index = operand_39, .limit = operand_40, });

            break :block_42 @as(*const (zx_abi).zx_type_15, operand_41);
        };
    };

    return block_32: {
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

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_22: {
                const value_4: state_type_4 = block_21: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_20 = block_19: {
                        const operand_16 = (&operand_15);
                        const operand_17 = (try function_0_value(allocator, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_16).index, .leaf = (operand_16).leaf, .limit = (operand_16).limit, .zx_origin = operand_16, }));

                        break :block_19 (if (((operand_17).zx_origin != null)) ((operand_17).zx_origin.?).* else block_18: {
                            break :block_18 (zx_abi).zx_type_15{ .index = (operand_17).index, .leaf = (operand_17).leaf, .limit = (operand_17).limit, };
                        });
                    };

                    break :block_21 state_type_4{ .index = (operand_20).index, .leaf = state_type_3{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, }, .limit = (operand_20).limit, };
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
                        break :block_9 state_type_3{ .previous = ((value_4).leaf).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_22 value_14;
            };

            state_changed_7 = true;
        }

        break :block_32 block_31: {
            const operand_23 = ((value_1).leaf).total;
            const operand_24 = ((state_1).leaf).total;
            const operand_25 = ((state_1).leaf).previous;
            const operand_26 = (state_1).index;
            const operand_27 = @as(i64, 0);
            const operand_28 = (in).values;

            break :block_31 block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_29).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_23, .total = operand_24, .previous = operand_25, .steps = operand_26, .other = operand_27, .values = operand_28, });

                break :block_30 @as(*const (zx_abi).zx_type_13, operand_29);
            };
        };
    };
}

