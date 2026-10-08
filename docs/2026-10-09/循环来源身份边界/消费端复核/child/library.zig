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

    const value_1: *const (zx_abi).zx_type_15 = block_40: {
        const operand_30 = block_35: {
            const operand_31 = (in).start;
            const operand_32 = (in).start;

            break :block_35 block_34: {
                const operand_33 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_33).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_31, .previous = operand_32, });

                break :block_34 @as(*const (zx_abi).zx_type_14, operand_33);
            };
        };

        const operand_36 = @as(u64, 0);
        const operand_37 = (in).count;

        break :block_40 block_39: {
            const operand_38 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_38).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_30, .index = operand_36, .limit = operand_37, });

            break :block_39 @as(*const (zx_abi).zx_type_15, operand_38);
        };
    };

    return block_29: {
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
            state_1 = block_19: {
                const value_4: state_type_3 = block_18: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_17 = block_16: {
                        break :block_16 (try function_0_value(allocator, (&operand_15)));
                    };

                    break :block_18 state_type_3{ .previous = (operand_17).previous, .total = (operand_17).total, };
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
                        break :block_9 state_type_3{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_19 value_14;
            };

            state_changed_7 = true;
        }

        break :block_29 block_28: {
            const operand_20 = ((value_1).leaf).total;
            const operand_21 = ((state_1).leaf).total;
            const operand_22 = ((state_1).leaf).previous;
            const operand_23 = (state_1).index;
            const operand_24 = @as(i64, 0);
            const operand_25 = (in).values;

            break :block_28 block_27: {
                const operand_26 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_26).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_20, .total = operand_21, .previous = operand_22, .steps = operand_23, .other = operand_24, .values = operand_25, });

                break :block_27 @as(*const (zx_abi).zx_type_13, operand_26);
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
        const operand_50 = value_1;
        var state_49: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_50;
        var state_changed_51 = false;

        while (((state_49).index < (state_49).limit)) {
            state_49 = block_70: {
                const value_4: (zx_abi).zx_type_14 = block_69: {
                    const operand_67 = state_49;
                    var state_borrow_68: (zx_abi).zx_type_15 = undefined;

                    state_borrow_68 = (zx_abi).zx_type_15{ .index = (operand_67).index, .leaf = (operand_67).leaf, .limit = (operand_67).limit, };

                    break :block_69 (try function_0_value(allocator, ((operand_67).zx_origin orelse (&state_borrow_68))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_49;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_66: {
                    break :block_66 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_65: {
                    break :block_65 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_64: {
                        break :block_64 block_63: {
                            const operand_62 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_62).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_60: {
                                break :block_60 (&value_6);
                            }).previous, .total = (block_61: {
                                break :block_61 value_7;
                            } + @as(i64, 1)), });

                            break :block_63 @as(*const (zx_abi).zx_type_14, operand_62);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_59: {
                    break :block_59 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_58: {
                        break :block_58 block_57: {
                            const operand_56 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_56).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_54: {
                                break :block_54 (&value_4);
                            }).total, .total = (block_55: {
                                break :block_55 (&value_10);
                            }).total, });

                            break :block_57 @as(*const (zx_abi).zx_type_14, operand_56);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_53: {
                    break :block_53 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_52: {
                        break :block_52 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_70 value_14;
            };

            state_changed_51 = true;
        }

        break :block_72 (if (state_changed_51) state_49 else operand_50);
    };

    return block_48: {
        const operand_42 = ((value_1).leaf).total;
        const operand_43 = ((value_15).leaf).total;
        const operand_44 = ((value_15).leaf).previous;
        const operand_45 = (value_15).index;
        const operand_46 = @as(i64, 0);
        const operand_47 = (in).values;

        break :block_48 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_42, .total = operand_43, .previous = operand_44, .steps = operand_45, .other = operand_46, .values = operand_47, });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_122: {
        const operand_114 = block_119: {
            const operand_115 = (in).start;
            const operand_116 = (in).start;

            break :block_119 block_118: {
                const operand_117 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_117).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_115, .previous = operand_116, });

                break :block_118 @as(*const (zx_abi).zx_type_14, operand_117);
            };
        };

        const operand_120 = @as(u64, 0);
        const operand_121 = (in).count;

        break :block_122 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_114, .index = operand_120, .limit = operand_121, });
    };

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_113: {
        const operand_91 = value_1;
        var state_90: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_91;
        var state_changed_92 = false;

        while (((state_90).index < (state_90).limit)) {
            state_90 = block_111: {
                const value_4: (zx_abi).zx_type_14 = block_110: {
                    const operand_108 = state_90;
                    var state_borrow_109: (zx_abi).zx_type_15 = undefined;

                    state_borrow_109 = (zx_abi).zx_type_15{ .index = (operand_108).index, .leaf = (operand_108).leaf, .limit = (operand_108).limit, };

                    break :block_110 (try function_0_value(allocator, ((operand_108).zx_origin orelse (&state_borrow_109))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_90;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_107: {
                    break :block_107 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_106: {
                    break :block_106 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_105: {
                        break :block_105 block_104: {
                            const operand_103 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_103).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_101: {
                                break :block_101 (&value_6);
                            }).previous, .total = (block_102: {
                                break :block_102 value_7;
                            } + @as(i64, 1)), });

                            break :block_104 @as(*const (zx_abi).zx_type_14, operand_103);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_100: {
                    break :block_100 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_99: {
                        break :block_99 block_98: {
                            const operand_97 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_97).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_95: {
                                break :block_95 (&value_4);
                            }).total, .total = (block_96: {
                                break :block_96 (&value_10);
                            }).total, });

                            break :block_98 @as(*const (zx_abi).zx_type_14, operand_97);
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

                break :block_111 value_14;
            };

            state_changed_92 = true;
        }

        break :block_113 (if (state_changed_92) state_90 else operand_91);
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
        const state_type_125 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_126 = struct {
            index: u64,
            leaf: state_type_125,
            limit: u64,
        };
        const operand_128 = block_127: {
            const operand_124 = value_1;

            break :block_127 state_type_126{ .index = (operand_124).index, .leaf = state_type_125{ .previous = ((operand_124).leaf).previous, .total = ((operand_124).leaf).total, }, .limit = (operand_124).limit, };
        };

        var state_123: state_type_126 = operand_128;
        var state_changed_129 = false;

        while (((state_123).index < (state_123).limit)) {
            state_123 = block_141: {
                const value_4: state_type_125 = block_140: {
                    const operand_135 = state_123;
                    const operand_136 = (zx_abi).zx_type_14{ .previous = ((operand_135).leaf).previous, .total = ((operand_135).leaf).total, };
                    const operand_137 = (zx_abi).zx_type_15{ .index = (operand_135).index, .leaf = (&operand_136), .limit = (operand_135).limit, };

                    const operand_139 = block_138: {
                        break :block_138 (try function_0_value(allocator, (&operand_137)));
                    };

                    break :block_140 state_type_125{ .previous = (operand_139).previous, .total = (operand_139).total, };
                };

                const value_5: state_type_126 = state_123;
                const value_6: state_type_125 = (value_5).leaf;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_126 = block_134: {
                    break :block_134 state_type_126{ .index = (value_5).index, .leaf = block_133: {
                        break :block_133 state_type_125{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, };
                };
                const value_9: state_type_126 = value_8;
                const value_10: state_type_125 = (value_9).leaf;

                const value_11: state_type_126 = block_132: {
                    break :block_132 state_type_126{ .index = (value_9).index, .leaf = block_131: {
                        break :block_131 state_type_125{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_126 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_126 = block_130: {
                    break :block_130 state_type_126{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_141 value_14;
            };

            state_changed_129 = true;
        }

        break :block_151 block_150: {
            const operand_142 = ((value_1).leaf).total;
            const operand_143 = ((state_123).leaf).total;
            const operand_144 = ((state_123).leaf).previous;
            const operand_145 = (state_123).index;
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

    const value_1: *const (zx_abi).zx_type_15 = block_40: {
        const operand_30 = block_35: {
            const operand_31 = (in).start;
            const operand_32 = (in).start;

            break :block_35 block_34: {
                const operand_33 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_33).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_31, .previous = operand_32, });

                break :block_34 @as(*const (zx_abi).zx_type_14, operand_33);
            };
        };

        const operand_36 = @as(u64, 0);
        const operand_37 = (in).count;

        break :block_40 block_39: {
            const operand_38 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_38).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_30, .index = operand_36, .limit = operand_37, });

            break :block_39 @as(*const (zx_abi).zx_type_15, operand_38);
        };
    };

    return block_29: {
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
            state_1 = block_19: {
                const value_4: state_type_3 = block_18: {
                    const operand_13 = state_1;
                    const operand_14 = (zx_abi).zx_type_14{ .previous = ((operand_13).leaf).previous, .total = ((operand_13).leaf).total, };
                    const operand_15 = (zx_abi).zx_type_15{ .index = (operand_13).index, .leaf = (&operand_14), .limit = (operand_13).limit, };

                    const operand_17 = block_16: {
                        break :block_16 (try function_0_value(allocator, (&operand_15)));
                    };

                    break :block_18 state_type_3{ .previous = (operand_17).previous, .total = (operand_17).total, };
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
                        break :block_9 state_type_3{ .previous = (value_4).total, .total = (value_10).total, };
                    }, .limit = (value_9).limit, };
                };
                const value_12: state_type_4 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_13 + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, };
                };

                break :block_19 value_14;
            };

            state_changed_7 = true;
        }

        break :block_29 block_28: {
            const operand_20 = ((value_1).leaf).total;
            const operand_21 = ((state_1).leaf).total;
            const operand_22 = ((state_1).leaf).previous;
            const operand_23 = (state_1).index;
            const operand_24 = @as(i64, 0);
            const operand_25 = (in).values;

            break :block_28 block_27: {
                const operand_26 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_26).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_20, .total = operand_21, .previous = operand_22, .steps = operand_23, .other = operand_24, .values = operand_25, });

                break :block_27 @as(*const (zx_abi).zx_type_13, operand_26);
            };
        };
    };
}

