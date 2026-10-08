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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((@rem((in).index, @as(u64, 2)) == @as(u64, 0))) (in).left else (in).right);
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_17) error{ }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (if ((@rem((in).index, @as(u64, 2)) == @as(u64, 0))) ((in).left).* else ((in).right).*);
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_17 = block_56: {
        const operand_39 = block_44: {
            const operand_40 = (in).start;
            const operand_41 = (in).start;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_42).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_40, .previous = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_14, operand_42);
            };
        };
        const operand_45 = block_50: {
            const operand_46 = ((in).start + @as(i64, 100));
            const operand_47 = (in).start;

            break :block_50 block_49: {
                const operand_48 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_48).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_46, .previous = operand_47, });

                break :block_49 @as(*const (zx_abi).zx_type_14, operand_48);
            };
        };

        const operand_51 = @as(u64, 0);
        const operand_52 = (in).count;
        const operand_53 = (in).start;

        break :block_56 block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_54).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_39, .right = operand_45, .index = operand_51, .limit = operand_52, .previous = operand_53, });

            break :block_55 @as(*const (zx_abi).zx_type_17, operand_54);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_38: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (operand_11).index, .left = (operand_11).left, .limit = (operand_11).limit, .previous = (operand_11).previous, .right = (operand_11).right, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_34: {
                const value_4: *const (zx_abi).zx_type_14 = block_33: {
                    const operand_31 = state_10;
                    var state_borrow_32: (zx_abi).zx_type_17 = undefined;

                    state_borrow_32 = (zx_abi).zx_type_17{ .index = (operand_31).index, .left = (operand_31).left, .limit = (operand_31).limit, .previous = (operand_31).previous, .right = (operand_31).right, };

                    break :block_33 (try function_0(allocator, ((operand_31).zx_origin orelse (&state_borrow_32))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).left;

                const value_7: i64 = (block_30: {
                    break :block_30 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_29: {
                    break :block_29 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_28: {
                        break :block_28 block_27: {
                            const operand_26 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_26).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_24: {
                                break :block_24 value_6;
                            }).previous, .total = (block_25: {
                                break :block_25 value_7;
                            } + @as(i64, 1)), });

                            break :block_27 @as(*const (zx_abi).zx_type_14, operand_26);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).right;

                const value_11: i64 = (block_23: {
                    break :block_23 value_10;
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_22: {
                    break :block_22 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_21: {
                        break :block_21 block_20: {
                            const operand_19 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_19).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_17: {
                                break :block_17 value_10;
                            }).previous, .total = (block_18: {
                                break :block_18 value_11;
                            } + @as(i64, 2)), });

                            break :block_20 @as(*const (zx_abi).zx_type_14, operand_19);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_15: {
                        break :block_15 value_4;
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_13: {
                        break :block_13 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_34 value_17;
            };

            state_changed_12 = true;
        }

        break :block_38 (if (state_changed_12) block_37: {
            break :block_37 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_17));

                (operand_35).* = (zx_abi).zx_type_17{ .index = (state_10).index, .left = (state_10).left, .limit = (state_10).limit, .previous = (state_10).previous, .right = (state_10).right, };

                break :block_36 @as(*const (zx_abi).zx_type_17, operand_35);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).left).total;
        const operand_2 = ((value_18).left).total;
        const operand_3 = (value_18).previous;
        const operand_4 = (value_18).index;
        const operand_5 = ((value_18).right).total;
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

    const value_1: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_106: {
        const operand_91 = block_96: {
            const operand_92 = (in).start;
            const operand_93 = (in).start;

            break :block_96 block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_94).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_92, .previous = operand_93, });

                break :block_95 @as(*const (zx_abi).zx_type_14, operand_94);
            };
        };
        const operand_97 = block_102: {
            const operand_98 = ((in).start + @as(i64, 100));
            const operand_99 = (in).start;

            break :block_102 block_101: {
                const operand_100 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_100).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_98, .previous = operand_99, });

                break :block_101 @as(*const (zx_abi).zx_type_14, operand_100);
            };
        };

        const operand_103 = @as(u64, 0);
        const operand_104 = (in).count;
        const operand_105 = (in).start;

        break :block_106 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .left = operand_91, .right = operand_97, .index = operand_103, .limit = operand_104, .previous = operand_105, });
    };

    const value_18: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_90: {
        const operand_65 = value_1;
        var state_64: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_65;
        var state_changed_66 = false;

        while (((state_64).index < (state_64).limit)) {
            state_64 = block_88: {
                const value_4: (zx_abi).zx_type_14 = block_87: {
                    const operand_85 = state_64;
                    var state_borrow_86: (zx_abi).zx_type_17 = undefined;

                    state_borrow_86 = (zx_abi).zx_type_17{ .index = (operand_85).index, .left = (operand_85).left, .limit = (operand_85).limit, .previous = (operand_85).previous, .right = (operand_85).right, };

                    break :block_87 (try function_0_value(allocator, ((operand_85).zx_origin orelse (&state_borrow_86))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_64;
                const value_6: (zx_abi).zx_type_14 = ((value_5).left).*;

                const value_7: i64 = (block_84: {
                    break :block_84 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_83: {
                    break :block_83 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_82: {
                        break :block_82 block_81: {
                            const operand_80 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_80).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_78: {
                                break :block_78 (&value_6);
                            }).previous, .total = (block_79: {
                                break :block_79 value_7;
                            } + @as(i64, 1)), });

                            break :block_81 @as(*const (zx_abi).zx_type_14, operand_80);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).right).*;

                const value_11: i64 = (block_77: {
                    break :block_77 (&value_10);
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_76: {
                    break :block_76 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_75: {
                        break :block_75 block_74: {
                            const operand_73 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_73).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_71: {
                                break :block_71 (&value_10);
                            }).previous, .total = (block_72: {
                                break :block_72 value_11;
                            } + @as(i64, 2)), });

                            break :block_74 @as(*const (zx_abi).zx_type_14, operand_73);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_70: {
                    break :block_70 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_69: {
                        break :block_69 (&value_4);
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_68: {
                    break :block_68 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_67: {
                        break :block_67 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_88 value_17;
            };

            state_changed_66 = true;
        }

        break :block_90 (if (state_changed_66) state_64 else operand_65);
    };

    return block_63: {
        const operand_57 = ((value_1).left).total;
        const operand_58 = ((value_18).left).total;
        const operand_59 = (value_18).previous;
        const operand_60 = (value_18).index;
        const operand_61 = ((value_18).right).total;
        const operand_62 = (in).values;

        break :block_63 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_57, .total = operand_58, .previous = operand_59, .steps = operand_60, .other = operand_61, .values = operand_62, });
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

    const value_1: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_156: {
        const operand_141 = block_146: {
            const operand_142 = (in).start;
            const operand_143 = (in).start;

            break :block_146 block_145: {
                const operand_144 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_144).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_142, .previous = operand_143, });

                break :block_145 @as(*const (zx_abi).zx_type_14, operand_144);
            };
        };
        const operand_147 = block_152: {
            const operand_148 = ((in).start + @as(i64, 100));
            const operand_149 = (in).start;

            break :block_152 block_151: {
                const operand_150 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_150).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_148, .previous = operand_149, });

                break :block_151 @as(*const (zx_abi).zx_type_14, operand_150);
            };
        };

        const operand_153 = @as(u64, 0);
        const operand_154 = (in).count;
        const operand_155 = (in).start;

        break :block_156 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .left = operand_141, .right = operand_147, .index = operand_153, .limit = operand_154, .previous = operand_155, });
    };

    const value_18: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_140: {
        const operand_115 = value_1;
        var state_114: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_115;
        var state_changed_116 = false;

        while (((state_114).index < (state_114).limit)) {
            state_114 = block_138: {
                const value_4: (zx_abi).zx_type_14 = block_137: {
                    const operand_135 = state_114;
                    var state_borrow_136: (zx_abi).zx_type_17 = undefined;

                    state_borrow_136 = (zx_abi).zx_type_17{ .index = (operand_135).index, .left = (operand_135).left, .limit = (operand_135).limit, .previous = (operand_135).previous, .right = (operand_135).right, };

                    break :block_137 (try function_0_value(allocator, ((operand_135).zx_origin orelse (&state_borrow_136))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_114;
                const value_6: (zx_abi).zx_type_14 = ((value_5).left).*;

                const value_7: i64 = (block_134: {
                    break :block_134 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_133: {
                    break :block_133 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_132: {
                        break :block_132 block_131: {
                            const operand_130 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_130).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_128: {
                                break :block_128 (&value_6);
                            }).previous, .total = (block_129: {
                                break :block_129 value_7;
                            } + @as(i64, 1)), });

                            break :block_131 @as(*const (zx_abi).zx_type_14, operand_130);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).right).*;

                const value_11: i64 = (block_127: {
                    break :block_127 (&value_10);
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_126: {
                    break :block_126 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_125: {
                        break :block_125 block_124: {
                            const operand_123 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_123).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_121: {
                                break :block_121 (&value_10);
                            }).previous, .total = (block_122: {
                                break :block_122 value_11;
                            } + @as(i64, 2)), });

                            break :block_124 @as(*const (zx_abi).zx_type_14, operand_123);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_120: {
                    break :block_120 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_119: {
                        break :block_119 (&value_4);
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_118: {
                    break :block_118 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_117: {
                        break :block_117 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_138 value_17;
            };

            state_changed_116 = true;
        }

        break :block_140 (if (state_changed_116) state_114 else operand_115);
    };

    return block_113: {
        const operand_107 = ((value_1).left).total;
        const operand_108 = ((value_18).left).total;
        const operand_109 = (value_18).previous;
        const operand_110 = (value_18).index;
        const operand_111 = ((value_18).right).total;
        const operand_112 = (in).values;

        break :block_113 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_107, .total = operand_108, .previous = operand_109, .steps = operand_110, .other = operand_111, .values = operand_112, });
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

    const value_1: *const (zx_abi).zx_type_17 = block_212: {
        const operand_195 = block_200: {
            const operand_196 = (in).start;
            const operand_197 = (in).start;

            break :block_200 block_199: {
                const operand_198 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_198).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_196, .previous = operand_197, });

                break :block_199 @as(*const (zx_abi).zx_type_14, operand_198);
            };
        };
        const operand_201 = block_206: {
            const operand_202 = ((in).start + @as(i64, 100));
            const operand_203 = (in).start;

            break :block_206 block_205: {
                const operand_204 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_204).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_202, .previous = operand_203, });

                break :block_205 @as(*const (zx_abi).zx_type_14, operand_204);
            };
        };

        const operand_207 = @as(u64, 0);
        const operand_208 = (in).count;
        const operand_209 = (in).start;

        break :block_212 block_211: {
            const operand_210 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_210).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_195, .right = operand_201, .index = operand_207, .limit = operand_208, .previous = operand_209, });

            break :block_211 @as(*const (zx_abi).zx_type_17, operand_210);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_194: {
        const operand_167 = value_1;
        var state_166: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (operand_167).index, .left = (operand_167).left, .limit = (operand_167).limit, .previous = (operand_167).previous, .right = (operand_167).right, .zx_origin = operand_167, };
        var state_changed_168 = false;

        while (((state_166).index < (state_166).limit)) {
            state_166 = block_190: {
                const value_4: *const (zx_abi).zx_type_14 = block_189: {
                    const operand_187 = state_166;
                    var state_borrow_188: (zx_abi).zx_type_17 = undefined;
                    state_borrow_188 = (zx_abi).zx_type_17{ .index = (operand_187).index, .left = (operand_187).left, .limit = (operand_187).limit, .previous = (operand_187).previous, .right = (operand_187).right, };

                    break :block_189 (try function_0(allocator, ((operand_187).zx_origin orelse (&state_borrow_188))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_166;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).left;

                const value_7: i64 = (block_186: {
                    break :block_186 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_185: {
                    break :block_185 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_184: {
                        break :block_184 block_183: {
                            const operand_182 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_182).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_180: {
                                break :block_180 value_6;
                            }).previous, .total = (block_181: {
                                break :block_181 value_7;
                            } + @as(i64, 1)), });

                            break :block_183 @as(*const (zx_abi).zx_type_14, operand_182);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).right;

                const value_11: i64 = (block_179: {
                    break :block_179 value_10;
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_178: {
                    break :block_178 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_177: {
                        break :block_177 block_176: {
                            const operand_175 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_175).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_173: {
                                break :block_173 value_10;
                            }).previous, .total = (block_174: {
                                break :block_174 value_11;
                            } + @as(i64, 2)), });

                            break :block_176 @as(*const (zx_abi).zx_type_14, operand_175);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_172: {
                    break :block_172 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_171: {
                        break :block_171 value_4;
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_170: {
                    break :block_170 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_169: {
                        break :block_169 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_190 value_17;
            };

            state_changed_168 = true;
        }

        break :block_194 (if (state_changed_168) block_193: {
            break :block_193 (if (((state_166).zx_origin != null)) (state_166).zx_origin.? else block_192: {
                const operand_191 = (try (allocator).create((zx_abi).zx_type_17));

                (operand_191).* = (zx_abi).zx_type_17{ .index = (state_166).index, .left = (state_166).left, .limit = (state_166).limit, .previous = (state_166).previous, .right = (state_166).right, };

                break :block_192 @as(*const (zx_abi).zx_type_17, operand_191);
            });
        } else operand_167);
    };

    return block_165: {
        const operand_157 = ((value_1).left).total;
        const operand_158 = ((value_18).left).total;
        const operand_159 = (value_18).previous;
        const operand_160 = (value_18).index;
        const operand_161 = ((value_18).right).total;
        const operand_162 = (in).values;

        break :block_165 block_164: {
            const operand_163 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_163).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_157, .total = operand_158, .previous = operand_159, .steps = operand_160, .other = operand_161, .values = operand_162, });

            break :block_164 @as(*const (zx_abi).zx_type_13, operand_163);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_17 = block_56: {
        const operand_39 = block_44: {
            const operand_40 = (in).start;
            const operand_41 = (in).start;

            break :block_44 block_43: {
                const operand_42 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_42).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_40, .previous = operand_41, });

                break :block_43 @as(*const (zx_abi).zx_type_14, operand_42);
            };
        };
        const operand_45 = block_50: {
            const operand_46 = ((in).start + @as(i64, 100));
            const operand_47 = (in).start;

            break :block_50 block_49: {
                const operand_48 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_48).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_46, .previous = operand_47, });

                break :block_49 @as(*const (zx_abi).zx_type_14, operand_48);
            };
        };

        const operand_51 = @as(u64, 0);
        const operand_52 = (in).count;
        const operand_53 = (in).start;

        break :block_56 block_55: {
            const operand_54 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_54).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_39, .right = operand_45, .index = operand_51, .limit = operand_52, .previous = operand_53, });

            break :block_55 @as(*const (zx_abi).zx_type_17, operand_54);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_38: {
        const operand_11 = value_1;
        var state_10: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (operand_11).index, .left = (operand_11).left, .limit = (operand_11).limit, .previous = (operand_11).previous, .right = (operand_11).right, .zx_origin = operand_11, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_34: {
                const value_4: *const (zx_abi).zx_type_14 = block_33: {
                    const operand_31 = state_10;
                    var state_borrow_32: (zx_abi).zx_type_17 = undefined;

                    state_borrow_32 = (zx_abi).zx_type_17{ .index = (operand_31).index, .left = (operand_31).left, .limit = (operand_31).limit, .previous = (operand_31).previous, .right = (operand_31).right, };

                    break :block_33 (try function_0(allocator, ((operand_31).zx_origin orelse (&state_borrow_32))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_10;
                const value_6: *const (zx_abi).zx_type_14 = (value_5).left;

                const value_7: i64 = (block_30: {
                    break :block_30 value_6;
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_29: {
                    break :block_29 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_28: {
                        break :block_28 block_27: {
                            const operand_26 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_26).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_24: {
                                break :block_24 value_6;
                            }).previous, .total = (block_25: {
                                break :block_25 value_7;
                            } + @as(i64, 1)), });

                            break :block_27 @as(*const (zx_abi).zx_type_14, operand_26);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: *const (zx_abi).zx_type_14 = (value_9).right;

                const value_11: i64 = (block_23: {
                    break :block_23 value_10;
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_22: {
                    break :block_22 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_21: {
                        break :block_21 block_20: {
                            const operand_19 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_19).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_17: {
                                break :block_17 value_10;
                            }).previous, .total = (block_18: {
                                break :block_18 value_11;
                            } + @as(i64, 2)), });

                            break :block_20 @as(*const (zx_abi).zx_type_14, operand_19);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_16: {
                    break :block_16 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_15: {
                        break :block_15 value_4;
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_14: {
                    break :block_14 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_13: {
                        break :block_13 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_34 value_17;
            };

            state_changed_12 = true;
        }

        break :block_38 (if (state_changed_12) block_37: {
            break :block_37 (if (((state_10).zx_origin != null)) (state_10).zx_origin.? else block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_17));

                (operand_35).* = (zx_abi).zx_type_17{ .index = (state_10).index, .left = (state_10).left, .limit = (state_10).limit, .previous = (state_10).previous, .right = (state_10).right, };

                break :block_36 @as(*const (zx_abi).zx_type_17, operand_35);
            });
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).left).total;
        const operand_2 = ((value_18).left).total;
        const operand_3 = (value_18).previous;
        const operand_4 = (value_18).index;
        const operand_5 = ((value_18).right).total;
        const operand_6 = (in).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

