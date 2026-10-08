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

    const value_15: *const (zx_abi).zx_type_15 = block_32: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_28: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_27: {
                    break :block_27 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_26: {
                    break :block_26 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_25: {
                    break :block_25 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_24: {
                        break :block_24 block_23: {
                            const operand_22 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_22).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_20: {
                                break :block_20 value_6;
                            }).previous, .total = (block_21: {
                                break :block_21 value_7;
                            } + @as(i64, 1)), });

                            break :block_23 @as(*const (zx_abi).zx_type_14, operand_22);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_19: {
                    break :block_19 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_18: {
                        break :block_18 block_17: {
                            const operand_16 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_16).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_15: {
                                break :block_15 value_10;
                            }).total, });

                            break :block_17 @as(*const (zx_abi).zx_type_14, operand_16);
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

                break :block_28 value_14;
            };

            state_changed_12 = true;
        }

        break :block_32 (if (state_changed_12) block_31: {
            break :block_31 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_29).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_30 @as(*const (zx_abi).zx_type_15, operand_29);
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_80: {
        const operand_72 = block_77: {
            const operand_73 = (in).start;
            const operand_74 = (in).start;

            break :block_77 block_76: {
                const operand_75 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_75).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_73, .previous = operand_74, });

                break :block_76 @as(*const (zx_abi).zx_type_14, operand_75);
            };
        };

        const operand_78 = @as(u64, 0);
        const operand_79 = (in).count;

        break :block_80 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_72, .index = operand_78, .limit = operand_79, });
    };

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_71: {
        const operand_52 = value_1;
        var state_51: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_52;
        var state_changed_53 = false;

        while (((state_51).index < (state_51).limit)) {
            state_51 = block_69: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_68: {
                    break :block_68 (try function_0_value(allocator, state_51));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_51;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_67: {
                    break :block_67 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_66: {
                    break :block_66 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_65: {
                        break :block_65 block_64: {
                            const operand_63 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_63).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_61: {
                                break :block_61 (&value_6);
                            }).previous, .total = (block_62: {
                                break :block_62 value_7;
                            } + @as(i64, 1)), });

                            break :block_64 @as(*const (zx_abi).zx_type_14, operand_63);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_60: {
                    break :block_60 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_59: {
                        break :block_59 block_58: {
                            const operand_57 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_57).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_56: {
                                break :block_56 (&value_10);
                            }).total, });

                            break :block_58 @as(*const (zx_abi).zx_type_14, operand_57);
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

                break :block_69 value_14;
            };

            state_changed_53 = true;
        }

        break :block_71 (if (state_changed_53) state_51 else operand_52);
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

    const value_1: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_117: {
        const operand_109 = block_114: {
            const operand_110 = (in).start;
            const operand_111 = (in).start;

            break :block_114 block_113: {
                const operand_112 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_112).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_110, .previous = operand_111, });

                break :block_113 @as(*const (zx_abi).zx_type_14, operand_112);
            };
        };

        const operand_115 = @as(u64, 0);
        const operand_116 = (in).count;

        break :block_117 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .leaf = operand_109, .index = operand_115, .limit = operand_116, });
    };

    const value_15: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_108: {
        const operand_89 = value_1;
        var state_88: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = operand_89;
        var state_changed_90 = false;

        while (((state_88).index < (state_88).limit)) {
            state_88 = block_106: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_105: {
                    break :block_105 (try function_0_value(allocator, state_88));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_88;
                const value_6: (zx_abi).zx_type_14 = ((value_5).leaf).*;

                const value_7: i64 = (block_104: {
                    break :block_104 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_103: {
                    break :block_103 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_102: {
                        break :block_102 block_101: {
                            const operand_100 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_100).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_98: {
                                break :block_98 (&value_6);
                            }).previous, .total = (block_99: {
                                break :block_99 value_7;
                            } + @as(i64, 1)), });

                            break :block_101 @as(*const (zx_abi).zx_type_14, operand_100);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).leaf).*;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_97: {
                    break :block_97 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_96: {
                        break :block_96 block_95: {
                            const operand_94 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_94).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_93: {
                                break :block_93 (&value_10);
                            }).total, });

                            break :block_95 @as(*const (zx_abi).zx_type_14, operand_94);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_92: {
                    break :block_92 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_91: {
                        break :block_91 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_106 value_14;
            };

            state_changed_90 = true;
        }

        break :block_108 (if (state_changed_90) state_88 else operand_89);
    };

    return block_87: {
        const operand_81 = ((value_1).leaf).total;
        const operand_82 = ((value_15).leaf).total;
        const operand_83 = ((value_15).leaf).previous;
        const operand_84 = (value_15).index;
        const operand_85 = @as(i64, 0);
        const operand_86 = (in).values;

        break :block_87 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_81, .total = operand_82, .previous = operand_83, .steps = operand_84, .other = operand_85, .values = operand_86, });
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

    const value_1: *const (zx_abi).zx_type_15 = block_160: {
        const operand_150 = block_155: {
            const operand_151 = (in).start;
            const operand_152 = (in).start;

            break :block_155 block_154: {
                const operand_153 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_153).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_151, .previous = operand_152, });

                break :block_154 @as(*const (zx_abi).zx_type_14, operand_153);
            };
        };

        const operand_156 = @as(u64, 0);
        const operand_157 = (in).count;

        break :block_160 block_159: {
            const operand_158 = (try (allocator).create((zx_abi).zx_type_15));

            (operand_158).* = @as((zx_abi).zx_type_15, (zx_abi).zx_type_15{ .leaf = operand_150, .index = operand_156, .limit = operand_157, });

            break :block_159 @as(*const (zx_abi).zx_type_15, operand_158);
        };
    };

    const value_15: *const (zx_abi).zx_type_15 = block_149: {
        const operand_128 = value_1;
        var state_127: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_128).index, .leaf = (operand_128).leaf, .limit = (operand_128).limit, .zx_origin = operand_128, };
        var state_changed_129 = false;

        while (((state_127).index < (state_127).limit)) {
            state_127 = block_145: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_144: {
                    break :block_144 (try function_0_value(allocator, state_127));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_127;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_143: {
                    break :block_143 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_142: {
                    break :block_142 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_141: {
                        break :block_141 block_140: {
                            const operand_139 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_139).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_137: {
                                break :block_137 value_6;
                            }).previous, .total = (block_138: {
                                break :block_138 value_7;
                            } + @as(i64, 1)), });

                            break :block_140 @as(*const (zx_abi).zx_type_14, operand_139);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_136: {
                    break :block_136 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_135: {
                        break :block_135 block_134: {
                            const operand_133 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_133).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_132: {
                                break :block_132 value_10;
                            }).total, });

                            break :block_134 @as(*const (zx_abi).zx_type_14, operand_133);
                        };
                    }, .limit = (value_9).limit, });
                };
                const value_12: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_11;
                const value_13: u64 = (value_12).index;

                const value_14: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_131: {
                    break :block_131 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (block_130: {
                        break :block_130 value_13;
                    } + @as(u64, 1)), .leaf = (value_12).leaf, .limit = (value_12).limit, });
                };

                break :block_145 value_14;
            };

            state_changed_129 = true;
        }

        break :block_149 (if (state_changed_129) block_148: {
            break :block_148 (if (((state_127).zx_origin != null)) (state_127).zx_origin.? else block_147: {
                const operand_146 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_146).* = (zx_abi).zx_type_15{ .index = (state_127).index, .leaf = (state_127).leaf, .limit = (state_127).limit, };

                break :block_147 @as(*const (zx_abi).zx_type_15, operand_146);
            });
        } else operand_128);
    };

    return block_126: {
        const operand_118 = ((value_1).leaf).total;
        const operand_119 = ((value_15).leaf).total;
        const operand_120 = ((value_15).leaf).previous;
        const operand_121 = (value_15).index;
        const operand_122 = @as(i64, 0);
        const operand_123 = (in).values;

        break :block_126 block_125: {
            const operand_124 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_124).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_118, .total = operand_119, .previous = operand_120, .steps = operand_121, .other = operand_122, .values = operand_123, });

            break :block_125 @as(*const (zx_abi).zx_type_13, operand_124);
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
        var state_10: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_11).index, .leaf = (operand_11).leaf, .limit = (operand_11).limit, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_28: {
                const value_4: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_27: {
                    break :block_27 (try function_0_value(allocator, state_10));
                };

                const value_5: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).leaf;

                const value_7: i64 = (block_26: {
                    break :block_26 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_25: {
                    break :block_25 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_5).index, .leaf = block_24: {
                        break :block_24 block_23: {
                            const operand_22 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_22).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_20: {
                                break :block_20 value_6;
                            }).previous, .total = (block_21: {
                                break :block_21 value_7;
                            } + @as(i64, 1)), });

                            break :block_23 @as(*const (zx_abi).zx_type_14, operand_22);
                        };
                    }, .limit = (value_5).limit, });
                };
                const value_9: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).leaf;

                const value_11: (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_19: {
                    break :block_19 @as((zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (value_9).index, .leaf = block_18: {
                        break :block_18 block_17: {
                            const operand_16 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_16).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((value_4).leaf).total, .total = (block_15: {
                                break :block_15 value_10;
                            }).total, });

                            break :block_17 @as(*const (zx_abi).zx_type_14, operand_16);
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

                break :block_28 value_14;
            };

            state_changed_12 = true;
        }

        break :block_32 (if (state_changed_12) block_31: {
            break :block_31 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_30: {
                const operand_29 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_29).* = (zx_abi).zx_type_15{ .index = (state_10).index, .leaf = (state_10).leaf, .limit = (state_10).limit, };

                break :block_30 @as(*const (zx_abi).zx_type_15, operand_29);
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

