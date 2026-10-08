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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in).leaf;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return ((in).leaf).*;
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

    const value_15: *const (zx_abi).zx_type_15 = block_32: {
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

        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .leaf = state_type_13{ .previous = ((operand_11).leaf).previous, .total = ((operand_11).leaf).total, }, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_26: {
                const value_4: state_type_13 = block_25: {
                    const operand_20 = state_10;
                    const operand_21 = (zx_abi).zx_type_14{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, };
                    const operand_22 = (zx_abi).zx_type_15{ .index = (operand_20).index, .leaf = (&operand_21), .limit = (operand_20).limit, };

                    const operand_24 = block_23: {
                        break :block_23 (try function_0_value(allocator, (&operand_22)));
                    };

                    break :block_25 state_type_13{ .previous = (operand_24).previous, .total = (operand_24).total, };
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
                        break :block_16 state_type_13{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_14 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_26 value_14;
            };

            state_changed_12 = true;
        }

        break :block_32 (if (state_changed_12) block_31: {
            const operand_30 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_30).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_28).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).leaf).previous, .total = ((state_10).leaf).total, });

                break :block_29 @as(*const (zx_abi).zx_type_14, operand_28);
            }, .limit = (state_10).limit, });

            break :block_31 @as(*const (zx_abi).zx_type_15, operand_30);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).leaf).total;
        const operand_2 = ((value_15).leaf).total;
        const operand_3 = ((value_15).leaf).previous;
        const operand_4 = (value_15).index;
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

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_74: {
        const operand_52 = value_1;
        var state_51: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_52;
        var state_changed_53 = false;

        while (((state_51).index < (state_51).limit)) {
            state_51 = block_72: {
                const value_4: (zx_abi).zx_type_14 = block_71: {
                    const operand_69 = state_51;
                    var state_borrow_70: (zx_abi).zx_type_15 = undefined;

                    state_borrow_70 = (zx_abi).zx_type_15{ .index = (operand_69).index, .leaf = (operand_69).leaf, .limit = (operand_69).limit, };

                    break :block_71 (try function_0_value(allocator, ((operand_69).zx_origin orelse (&state_borrow_70))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_51;
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

                            (operand_58).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_56: {
                                break :block_56 (&value_4);
                            }).total, .total = (block_57: {
                                break :block_57 (&value_10);
                            }).total, });

                            break :block_59 @as(*const (zx_abi).zx_type_14, operand_58);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_55: {
                    break :block_55 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_54: {
                        break :block_54 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_72 value_14;
            };

            state_changed_53 = true;
        }

        break :block_74 (if (state_changed_53) state_51 else operand_52);
    };

    return block_50: {
        const operand_44 = ((value_1).leaf).total;
        const operand_45 = ((value_15).leaf).total;
        const operand_46 = ((value_15).leaf).previous;
        const operand_47 = (value_15).index;
        const operand_48 = @as(i64, 0);
        const operand_49 = (in).values;

        break :block_50 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_44, .total = operand_45, .previous = operand_46, .steps = operand_47, .other = operand_48, .values = operand_49, });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_123: {
        const operand_115 = block_120: {
            const operand_116 = (in).start;
            const operand_117 = (in).start;

            break :block_120 block_119: {
                const operand_118 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_118).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_116, .previous = operand_117, });

                break :block_119 @as(*const (zx_abi).zx_type_14, operand_118);
            };
        };

        const operand_121 = @as(u64, 0);
        const operand_122 = (in).count;

        break :block_123 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_115, .index = operand_121, .limit = operand_122, });
    };

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_114: {
        const operand_92 = value_1;
        var state_91: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_92;
        var state_changed_93 = false;

        while (((state_91).index < (state_91).limit)) {
            state_91 = block_112: {
                const value_4: (zx_abi).zx_type_14 = block_111: {
                    const operand_109 = state_91;
                    var state_borrow_110: (zx_abi).zx_type_15 = undefined;

                    state_borrow_110 = (zx_abi).zx_type_15{ .index = (operand_109).index, .leaf = (operand_109).leaf, .limit = (operand_109).limit, };

                    break :block_111 (try function_0_value(allocator, ((operand_109).zx_origin orelse (&state_borrow_110))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_91;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_108: {
                    break :block_108 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_107: {
                    break :block_107 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_106: {
                        break :block_106 block_105: {
                            const operand_104 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_104).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_102: {
                                break :block_102 (&value_6);
                            }).previous, .total = (block_103: {
                                break :block_103 value_7;
                            } + @as(i64, 1)), });

                            break :block_105 @as(*const (zx_abi).zx_type_14, operand_104);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_101: {
                    break :block_101 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_100: {
                        break :block_100 block_99: {
                            const operand_98 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_98).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_96: {
                                break :block_96 (&value_4);
                            }).total, .total = (block_97: {
                                break :block_97 (&value_10);
                            }).total, });

                            break :block_99 @as(*const (zx_abi).zx_type_14, operand_98);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_95: {
                    break :block_95 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_94: {
                        break :block_94 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_112 value_14;
            };

            state_changed_93 = true;
        }

        break :block_114 (if (state_changed_93) state_91 else operand_92);
    };

    return block_90: {
        const operand_84 = ((value_1).leaf).total;
        const operand_85 = ((value_15).leaf).total;
        const operand_86 = ((value_15).leaf).previous;
        const operand_87 = (value_15).index;
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

    const value_15: *const (zx_abi).zx_type_15 = block_155: {
        const operand_134 = value_1;

        const state_type_136 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_137 = struct {
            index: u64,
            leaf: state_type_136,
            limit: u64,
        };

        var state_133: state_type_137 = state_type_137{ .index = (operand_134).index, .leaf = state_type_136{ .previous = ((operand_134).leaf).previous, .total = ((operand_134).leaf).total, }, .limit = (operand_134).limit, };
        var state_changed_135 = false;

        while (((state_133).index < (state_133).limit)) {
            state_133 = block_149: {
                const value_4: state_type_136 = block_148: {
                    const operand_143 = state_133;
                    const operand_144 = (zx_abi).zx_type_14{ .previous = ((operand_143).leaf).previous, .total = ((operand_143).leaf).total, };
                    const operand_145 = (zx_abi).zx_type_15{ .index = (operand_143).index, .leaf = (&operand_144), .limit = (operand_143).limit, };

                    const operand_147 = block_146: {
                        break :block_146 (try function_0_value(allocator, (&operand_145)));
                    };

                    break :block_148 state_type_136{ .previous = (operand_147).previous, .total = (operand_147).total, };
                };

                const value_5: state_type_137 = state_133;
                const value_6: state_type_136 = (value_5).leaf;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_137 = block_142: {
                    break :block_142 state_type_137{ .index = (value_5).index, .leaf = block_141: {
                        break :block_141 state_type_136{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_137 = value_8;
                const value_10: state_type_136 = (value_9).leaf;

                const value_11: state_type_137 = block_140: {
                    break :block_140 state_type_137{ .index = (value_9).index, .leaf = block_139: {
                        break :block_139 state_type_136{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_137 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_137 = block_138: {
                    break :block_138 state_type_137{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_149 value_14;
            };

            state_changed_135 = true;
        }

        break :block_155 (if (state_changed_135) block_154: {
            const operand_153 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_153).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_133).index, .leaf = block_152: {
                const operand_151 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_151).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_133).leaf).previous, .total = ((state_133).leaf).total, });

                break :block_152 @as(*const (zx_abi).zx_type_14, operand_151);
            }, .limit = (state_133).limit, });

            break :block_154 @as(*const (zx_abi).zx_type_15, operand_153);
        } else operand_134);
    };

    return block_132: {
        const operand_124 = ((value_1).leaf).total;
        const operand_125 = ((value_15).leaf).total;
        const operand_126 = ((value_15).leaf).previous;
        const operand_127 = (value_15).index;
        const operand_128 = @as(i64, 0);
        const operand_129 = (in).values;

        break :block_132 block_131: {
            const operand_130 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_130).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_124, .total = operand_125, .previous = operand_126, .steps = operand_127, .other = operand_128, .values = operand_129, });

            break :block_131 @as(*const (zx_abi).zx_type_13, operand_130);
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

    const value_15: *const (zx_abi).zx_type_15 = block_32: {
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

        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .leaf = state_type_13{ .previous = ((operand_11).leaf).previous, .total = ((operand_11).leaf).total, }, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_26: {
                const value_4: state_type_13 = block_25: {
                    const operand_20 = state_10;
                    const operand_21 = (zx_abi).zx_type_14{ .previous = ((operand_20).leaf).previous, .total = ((operand_20).leaf).total, };
                    const operand_22 = (zx_abi).zx_type_15{ .index = (operand_20).index, .leaf = (&operand_21), .limit = (operand_20).limit, };

                    const operand_24 = block_23: {
                        break :block_23 (try function_0_value(allocator, (&operand_22)));
                    };

                    break :block_25 state_type_13{ .previous = (operand_24).previous, .total = (operand_24).total, };
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
                        break :block_16 state_type_13{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_14 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_26 value_14;
            };

            state_changed_12 = true;
        }

        break :block_32 (if (state_changed_12) block_31: {
            const operand_30 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_30).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_28).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).leaf).previous, .total = ((state_10).leaf).total, });

                break :block_29 @as(*const (zx_abi).zx_type_14, operand_28);
            }, .limit = (state_10).limit, });

            break :block_31 @as(*const (zx_abi).zx_type_15, operand_30);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).leaf).total;
        const operand_2 = ((value_15).leaf).total;
        const operand_3 = ((value_15).leaf).previous;
        const operand_4 = (value_15).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

