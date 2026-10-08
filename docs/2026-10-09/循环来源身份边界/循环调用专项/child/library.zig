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

    const value_1: *const (zx_abi).zx_type_15 = block_46: {
        const operand_36 = block_41: {
            const operand_37 = (in).start;
            const operand_38 = (in).start;

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_39).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_37, .previous = operand_38, });

                break :block_40 @as(*const (zx_abi).zx_type_14, operand_39);
            };
        };

        const operand_42 = @as(u64, 0);
        const operand_43 = (in).count;

        break :block_46 block_45: {
            const operand_44 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_44).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_36, .index = operand_42, .limit = operand_43, });

            break :block_45 @as(*const (zx_abi).zx_type_15, operand_44);
        };
    };

    const value_15: *const (zx_abi).zx_type_15 = block_35: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_31: {
                const value_4: *const (zx_abi).zx_type_14 = block_30: {
                    const operand_28 = state_10;
                    var state_borrow_29: (zx_abi).zx_type_15 = undefined;

                    state_borrow_29 = (zx_abi).zx_type_15{ .index = (operand_28).index, .leaf = (operand_28).leaf, .limit = (operand_28).limit, };

                    break :block_30 (try function_0(allocator, ((operand_28).zx_origin orelse (&state_borrow_29))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_27: {
                    break :block_27 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_26: {
                    break :block_26 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_25: {
                        break :block_25 block_24: {
                            const operand_23 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_23).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_21: {
                                break :block_21 value_6;
                            }).previous, .total = (block_22: {
                                break :block_22 value_7;
                            } + @as(i64, 1)), });

                            break :block_24 @as(*const (zx_abi).zx_type_14, operand_23);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_19: {
                        break :block_19 block_18: {
                            const operand_17 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_17).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_15: {
                                break :block_15 value_4;
                            }).total, .total = (block_16: {
                                break :block_16 value_10;
                            }).total, });

                            break :block_18 @as(*const (zx_abi).zx_type_14, operand_17);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_13: {
                        break :block_13 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_31 value_14;
            };

            state_changed_12 = true;
        }

        break :block_35 (if (state_changed_12) block_34: {
            break :block_34 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_32).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_33 @as(*const (zx_abi).zx_type_15, operand_32);
            });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_86: {
        const operand_78 = block_83: {
            const operand_79 = (in).start;
            const operand_80 = (in).start;

            break :block_83 block_82: {
                const operand_81 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_81).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_79, .previous = operand_80, });

                break :block_82 @as(*const (zx_abi).zx_type_14, operand_81);
            };
        };

        const operand_84 = @as(u64, 0);
        const operand_85 = (in).count;

        break :block_86 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_78, .index = operand_84, .limit = operand_85, });
    };

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_77: {
        const operand_55 = value_1;
        var state_54: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_55;
        var state_changed_56 = false;

        while (((state_54).index < (state_54).limit)) {
            state_54 = block_75: {
                const value_4: (zx_abi).zx_type_14 = block_74: {
                    const operand_72 = state_54;
                    var state_borrow_73: (zx_abi).zx_type_15 = undefined;

                    state_borrow_73 = (zx_abi).zx_type_15{ .index = (operand_72).index, .leaf = (operand_72).leaf, .limit = (operand_72).limit, };

                    break :block_74 (try function_0_value(allocator, ((operand_72).zx_origin orelse (&state_borrow_73))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_54;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_71: {
                    break :block_71 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_70: {
                    break :block_70 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_69: {
                        break :block_69 block_68: {
                            const operand_67 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_67).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_65: {
                                break :block_65 (&value_6);
                            }).previous, .total = (block_66: {
                                break :block_66 value_7;
                            } + @as(i64, 1)), });

                            break :block_68 @as(*const (zx_abi).zx_type_14, operand_67);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_64: {
                    break :block_64 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_63: {
                        break :block_63 block_62: {
                            const operand_61 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_61).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_59: {
                                break :block_59 (&value_4);
                            }).total, .total = (block_60: {
                                break :block_60 (&value_10);
                            }).total, });

                            break :block_62 @as(*const (zx_abi).zx_type_14, operand_61);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_58: {
                    break :block_58 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_57: {
                        break :block_57 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_75 value_14;
            };

            state_changed_56 = true;
        }

        break :block_77 (if (state_changed_56) state_54 else operand_55);
    };

    return block_53: {
        const operand_47 = ((value_1).leaf).total;
        const operand_48 = ((value_15).leaf).total;
        const operand_49 = ((value_15).leaf).previous;
        const operand_50 = (value_15).index;
        const operand_51 = @as(i64, 0);
        const operand_52 = (in).values;

        break :block_53 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_47, .total = operand_48, .previous = operand_49, .steps = operand_50, .other = operand_51, .values = operand_52, });
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_126: {
        const operand_118 = block_123: {
            const operand_119 = (in).start;
            const operand_120 = (in).start;

            break :block_123 block_122: {
                const operand_121 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_121).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_119, .previous = operand_120, });

                break :block_122 @as(*const (zx_abi).zx_type_14, operand_121);
            };
        };

        const operand_124 = @as(u64, 0);
        const operand_125 = (in).count;

        break :block_126 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_118, .index = operand_124, .limit = operand_125, });
    };

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_117: {
        const operand_95 = value_1;
        var state_94: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_95;
        var state_changed_96 = false;

        while (((state_94).index < (state_94).limit)) {
            state_94 = block_115: {
                const value_4: (zx_abi).zx_type_14 = block_114: {
                    const operand_112 = state_94;
                    var state_borrow_113: (zx_abi).zx_type_15 = undefined;

                    state_borrow_113 = (zx_abi).zx_type_15{ .index = (operand_112).index, .leaf = (operand_112).leaf, .limit = (operand_112).limit, };

                    break :block_114 (try function_0_value(allocator, ((operand_112).zx_origin orelse (&state_borrow_113))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_94;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_111: {
                    break :block_111 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_110: {
                    break :block_110 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_109: {
                        break :block_109 block_108: {
                            const operand_107 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_107).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_105: {
                                break :block_105 (&value_6);
                            }).previous, .total = (block_106: {
                                break :block_106 value_7;
                            } + @as(i64, 1)), });

                            break :block_108 @as(*const (zx_abi).zx_type_14, operand_107);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_104: {
                    break :block_104 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_103: {
                        break :block_103 block_102: {
                            const operand_101 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_101).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_99: {
                                break :block_99 (&value_4);
                            }).total, .total = (block_100: {
                                break :block_100 (&value_10);
                            }).total, });

                            break :block_102 @as(*const (zx_abi).zx_type_14, operand_101);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_98: {
                    break :block_98 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_97: {
                        break :block_97 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_115 value_14;
            };

            state_changed_96 = true;
        }

        break :block_117 (if (state_changed_96) state_94 else operand_95);
    };

    return block_93: {
        const operand_87 = ((value_1).leaf).total;
        const operand_88 = ((value_15).leaf).total;
        const operand_89 = ((value_15).leaf).previous;
        const operand_90 = (value_15).index;
        const operand_91 = @as(i64, 0);
        const operand_92 = (in).values;

        break :block_93 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_87, .total = operand_88, .previous = operand_89, .steps = operand_90, .other = operand_91, .values = operand_92, });
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

    const value_1: *const (zx_abi).zx_type_15 = block_172: {
        const operand_162 = block_167: {
            const operand_163 = (in).start;
            const operand_164 = (in).start;

            break :block_167 block_166: {
                const operand_165 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_165).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_163, .previous = operand_164, });

                break :block_166 @as(*const (zx_abi).zx_type_14, operand_165);
            };
        };

        const operand_168 = @as(u64, 0);
        const operand_169 = (in).count;

        break :block_172 block_171: {
            const operand_170 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_170).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_162, .index = operand_168, .limit = operand_169, });

            break :block_171 @as(*const (zx_abi).zx_type_15, operand_170);
        };
    };

    const value_15: *const (zx_abi).zx_type_15 = block_161: {
        const operand_137 = value_1;
        var state_136: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_137).index, .leaf = (operand_137).leaf, .limit = (operand_137).limit, .zx_origin = operand_137, };
        var state_changed_138 = false;

        while (((state_136).index < (state_136).limit)) {
            state_136 = block_157: {
                const value_4: *const (zx_abi).zx_type_14 = block_156: {
                    const operand_154 = state_136;
                    var state_borrow_155: (zx_abi).zx_type_15 = undefined;

                    state_borrow_155 = (zx_abi).zx_type_15{ .index = (operand_154).index, .leaf = (operand_154).leaf, .limit = (operand_154).limit, };

                    break :block_156 (try function_0(allocator, ((operand_154).zx_origin orelse (&state_borrow_155))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_136;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_153: {
                    break :block_153 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_152: {
                    break :block_152 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_151: {
                        break :block_151 block_150: {
                            const operand_149 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_149).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_147: {
                                break :block_147 value_6;
                            }).previous, .total = (block_148: {
                                break :block_148 value_7;
                            } + @as(i64, 1)), });

                            break :block_150 @as(*const (zx_abi).zx_type_14, operand_149);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_146: {
                    break :block_146 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_145: {
                        break :block_145 block_144: {
                            const operand_143 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_143).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_141: {
                                break :block_141 value_4;
                            }).total, .total = (block_142: {
                                break :block_142 value_10;
                            }).total, });

                            break :block_144 @as(*const (zx_abi).zx_type_14, operand_143);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_140: {
                    break :block_140 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_139: {
                        break :block_139 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_157 value_14;
            };

            state_changed_138 = true;
        }

        break :block_161 (if (state_changed_138) block_160: {
            break :block_160 (if (((state_136).zx_origin != null)) (state_136).zx_origin.? else block_159: {
                const operand_158 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_158).* = (zx_abi).zx_type_15{ .index = (state_136).index, .leaf = (state_136).leaf, .limit = (state_136).limit, };

                break :block_159 @as(*const (zx_abi).zx_type_15, operand_158);
            });
        } else operand_137);
    };

    return block_135: {
        const operand_127 = ((value_1).leaf).total;
        const operand_128 = ((value_15).leaf).total;
        const operand_129 = ((value_15).leaf).previous;
        const operand_130 = (value_15).index;
        const operand_131 = @as(i64, 0);
        const operand_132 = (in).values;

        break :block_135 block_134: {
            const operand_133 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_133).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_127, .total = operand_128, .previous = operand_129, .steps = operand_130, .other = operand_131, .values = operand_132, });

            break :block_134 @as(*const (zx_abi).zx_type_13, operand_133);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_15 = block_46: {
        const operand_36 = block_41: {
            const operand_37 = (in).start;
            const operand_38 = (in).start;

            break :block_41 block_40: {
                const operand_39 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_39).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_37, .previous = operand_38, });

                break :block_40 @as(*const (zx_abi).zx_type_14, operand_39);
            };
        };

        const operand_42 = @as(u64, 0);
        const operand_43 = (in).count;

        break :block_46 block_45: {
            const operand_44 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_44).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_36, .index = operand_42, .limit = operand_43, });

            break :block_45 @as(*const (zx_abi).zx_type_15, operand_44);
        };
    };

    const value_15: *const (zx_abi).zx_type_15 = block_35: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_31: {
                const value_4: *const (zx_abi).zx_type_14 = block_30: {
                    const operand_28 = state_10;
                    var state_borrow_29: (zx_abi).zx_type_15 = undefined;

                    state_borrow_29 = (zx_abi).zx_type_15{ .index = (operand_28).index, .leaf = (operand_28).leaf, .limit = (operand_28).limit, };

                    break :block_30 (try function_0(allocator, ((operand_28).zx_origin orelse (&state_borrow_29))));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_27: {
                    break :block_27 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_26: {
                    break :block_26 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_25: {
                        break :block_25 block_24: {
                            const operand_23 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_23).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_21: {
                                break :block_21 value_6;
                            }).previous, .total = (block_22: {
                                break :block_22 value_7;
                            } + @as(i64, 1)), });

                            break :block_24 @as(*const (zx_abi).zx_type_14, operand_23);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_20: {
                    break :block_20 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_19: {
                        break :block_19 block_18: {
                            const operand_17 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_17).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_15: {
                                break :block_15 value_4;
                            }).total, .total = (block_16: {
                                break :block_16 value_10;
                            }).total, });

                            break :block_18 @as(*const (zx_abi).zx_type_14, operand_17);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_13: {
                        break :block_13 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_31 value_14;
            };

            state_changed_12 = true;
        }

        break :block_35 (if (state_changed_12) block_34: {
            break :block_34 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_32).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_33 @as(*const (zx_abi).zx_type_15, operand_32);
            });
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

