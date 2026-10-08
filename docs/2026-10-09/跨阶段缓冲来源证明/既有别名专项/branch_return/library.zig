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

    const value_1: *const (zx_abi).zx_type_17 = block_54: {
        const operand_37 = block_42: {
            const operand_38 = (in).start;
            const operand_39 = (in).start;

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_40).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_38, .previous = operand_39, });

                break :block_41 @as(*const (zx_abi).zx_type_14, operand_40);
            };
        };
        const operand_43 = block_48: {
            const operand_44 = ((in).start + @as(i64, 100));
            const operand_45 = (in).start;

            break :block_48 block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_46).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_44, .previous = operand_45, });

                break :block_47 @as(*const (zx_abi).zx_type_14, operand_46);
            };
        };

        const operand_49 = @as(u64, 0);
        const operand_50 = (in).count;
        const operand_51 = (in).start;

        break :block_54 block_53: {
            const operand_52 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_52).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_37, .right = operand_43, .index = operand_49, .limit = operand_50, .previous = operand_51, });

            break :block_53 @as(*const (zx_abi).zx_type_17, operand_52);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_36: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_14 = struct {
            index: u64,
            left: state_type_13,
            limit: u64,
            previous: i64,
            right: state_type_13,
        };

        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .left = state_type_13{ .previous = ((operand_11).left).previous, .total = ((operand_11).left).total, }, .limit = (operand_11).limit, .previous = (operand_11).previous, .right = state_type_13{ .previous = ((operand_11).right).previous, .total = ((operand_11).right).total, }, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_28: {
                const value_4: state_type_13 = block_27: {
                    const operand_21 = state_10;
                    const operand_22 = (zx_abi).zx_type_14{ .previous = ((operand_21).left).previous, .total = ((operand_21).left).total, };
                    const operand_23 = (zx_abi).zx_type_14{ .previous = ((operand_21).right).previous, .total = ((operand_21).right).total, };
                    const operand_24 = (zx_abi).zx_type_17{ .index = (operand_21).index, .left = (&operand_22), .limit = (operand_21).limit, .previous = (operand_21).previous, .right = (&operand_23), };

                    const operand_26 = block_25: {
                        break :block_25 (try function_0_value(allocator, (&operand_24)));
                    };

                    break :block_27 state_type_13{ .previous = (operand_26).previous, .total = (operand_26).total, };
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).left;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_14 = block_20: {
                    break :block_20 state_type_14{ .index = (value_5).index, .left = block_19: {
                        break :block_19 state_type_13{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_14 = value_8;
                const value_10: state_type_13 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_14 = block_18: {
                    break :block_18 state_type_14{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_17: {
                        break :block_17 state_type_13{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_14 = value_12;

                const value_14: state_type_14 = block_16: {
                    break :block_16 state_type_14{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };
                const value_15: state_type_14 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_28 value_17;
            };

            state_changed_12 = true;
        }

        break :block_36 (if (state_changed_12) block_35: {
            const operand_34 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_34).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = (state_10).index, .left = block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_30).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).left).previous, .total = ((state_10).left).total, });

                break :block_31 @as(*const (zx_abi).zx_type_14, operand_30);
            }, .limit = (state_10).limit, .previous = (state_10).previous, .right = block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_32).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).right).previous, .total = ((state_10).right).total, });

                break :block_33 @as(*const (zx_abi).zx_type_14, operand_32);
            }, });

            break :block_35 @as(*const (zx_abi).zx_type_17, operand_34);
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

    const value_1: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_104: {
        const operand_89 = block_94: {
            const operand_90 = (in).start;
            const operand_91 = (in).start;

            break :block_94 block_93: {
                const operand_92 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_92).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_90, .previous = operand_91, });

                break :block_93 @as(*const (zx_abi).zx_type_14, operand_92);
            };
        };
        const operand_95 = block_100: {
            const operand_96 = ((in).start + @as(i64, 100));
            const operand_97 = (in).start;

            break :block_100 block_99: {
                const operand_98 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_98).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_96, .previous = operand_97, });

                break :block_99 @as(*const (zx_abi).zx_type_14, operand_98);
            };
        };

        const operand_101 = @as(u64, 0);
        const operand_102 = (in).count;
        const operand_103 = (in).start;

        break :block_104 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .left = operand_89, .right = operand_95, .index = operand_101, .limit = operand_102, .previous = operand_103, });
    };

    const value_18: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_88: {
        const operand_63 = value_1;
        var state_62: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_63;
        var state_changed_64 = false;

        while (((state_62).index < (state_62).limit)) {
            state_62 = block_86: {
                const value_4: (zx_abi).zx_type_14 = block_85: {
                    const operand_83 = state_62;
                    var state_borrow_84: (zx_abi).zx_type_17 = undefined;
                    state_borrow_84 = (zx_abi).zx_type_17{ .index = (operand_83).index, .left = (operand_83).left, .limit = (operand_83).limit, .previous = (operand_83).previous, .right = (operand_83).right, };

                    break :block_85 (try function_0_value(allocator, ((operand_83).zx_origin orelse (&state_borrow_84))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_62;
                const value_6: (zx_abi).zx_type_14 = ((value_5).left).*;

                const value_7: i64 = (block_82: {
                    break :block_82 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_81: {
                    break :block_81 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_80: {
                        break :block_80 block_79: {
                            const operand_78 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_78).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_76: {
                                break :block_76 (&value_6);
                            }).previous, .total = (block_77: {
                                break :block_77 value_7;
                            } + @as(i64, 1)), });

                            break :block_79 @as(*const (zx_abi).zx_type_14, operand_78);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).right).*;

                const value_11: i64 = (block_75: {
                    break :block_75 (&value_10);
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_74: {
                    break :block_74 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_73: {
                        break :block_73 block_72: {
                            const operand_71 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_71).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_69: {
                                break :block_69 (&value_10);
                            }).previous, .total = (block_70: {
                                break :block_70 value_11;
                            } + @as(i64, 2)), });

                            break :block_72 @as(*const (zx_abi).zx_type_14, operand_71);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_68: {
                    break :block_68 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_67: {
                        break :block_67 (&value_4);
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_66: {
                    break :block_66 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_65: {
                        break :block_65 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_86 value_17;
            };

            state_changed_64 = true;
        }

        break :block_88 (if (state_changed_64) state_62 else operand_63);
    };

    return block_61: {
        const operand_55 = ((value_1).left).total;
        const operand_56 = ((value_18).left).total;
        const operand_57 = (value_18).previous;
        const operand_58 = (value_18).index;
        const operand_59 = ((value_18).right).total;
        const operand_60 = (in).values;

        break :block_61 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_55, .total = operand_56, .previous = operand_57, .steps = operand_58, .other = operand_59, .values = operand_60, });
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

    const value_1: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_154: {
        const operand_139 = block_144: {
            const operand_140 = (in).start;
            const operand_141 = (in).start;

            break :block_144 block_143: {
                const operand_142 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_142).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_140, .previous = operand_141, });

                break :block_143 @as(*const (zx_abi).zx_type_14, operand_142);
            };
        };
        const operand_145 = block_150: {
            const operand_146 = ((in).start + @as(i64, 100));
            const operand_147 = (in).start;

            break :block_150 block_149: {
                const operand_148 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_148).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_146, .previous = operand_147, });

                break :block_149 @as(*const (zx_abi).zx_type_14, operand_148);
            };
        };

        const operand_151 = @as(u64, 0);
        const operand_152 = (in).count;
        const operand_153 = (in).start;

        break :block_154 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .left = operand_139, .right = operand_145, .index = operand_151, .limit = operand_152, .previous = operand_153, });
    };

    const value_18: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_138: {
        const operand_113 = value_1;
        var state_112: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_113;
        var state_changed_114 = false;

        while (((state_112).index < (state_112).limit)) {
            state_112 = block_136: {
                const value_4: (zx_abi).zx_type_14 = block_135: {
                    const operand_133 = state_112;
                    var state_borrow_134: (zx_abi).zx_type_17 = undefined;

                    state_borrow_134 = (zx_abi).zx_type_17{ .index = (operand_133).index, .left = (operand_133).left, .limit = (operand_133).limit, .previous = (operand_133).previous, .right = (operand_133).right, };

                    break :block_135 (try function_0_value(allocator, ((operand_133).zx_origin orelse (&state_borrow_134))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_112;
                const value_6: (zx_abi).zx_type_14 = ((value_5).left).*;

                const value_7: i64 = (block_132: {
                    break :block_132 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_131: {
                    break :block_131 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_130: {
                        break :block_130 block_129: {
                            const operand_128 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_128).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_126: {
                                break :block_126 (&value_6);
                            }).previous, .total = (block_127: {
                                break :block_127 value_7;
                            } + @as(i64, 1)), });

                            break :block_129 @as(*const (zx_abi).zx_type_14, operand_128);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).right).*;

                const value_11: i64 = (block_125: {
                    break :block_125 (&value_10);
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_124: {
                    break :block_124 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_123: {
                        break :block_123 block_122: {
                            const operand_121 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_121).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_119: {
                                break :block_119 (&value_10);
                            }).previous, .total = (block_120: {
                                break :block_120 value_11;
                            } + @as(i64, 2)), });

                            break :block_122 @as(*const (zx_abi).zx_type_14, operand_121);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_118: {
                    break :block_118 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_117: {
                        break :block_117 (&value_4);
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_116: {
                    break :block_116 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_115: {
                        break :block_115 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_136 value_17;
            };

            state_changed_114 = true;
        }

        break :block_138 (if (state_changed_114) state_112 else operand_113);
    };

    return block_111: {
        const operand_105 = ((value_1).left).total;
        const operand_106 = ((value_18).left).total;
        const operand_107 = (value_18).previous;
        const operand_108 = (value_18).index;
        const operand_109 = ((value_18).right).total;
        const operand_110 = (in).values;

        break :block_111 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_105, .total = operand_106, .previous = operand_107, .steps = operand_108, .other = operand_109, .values = operand_110, });
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

    const value_1: *const (zx_abi).zx_type_17 = block_208: {
        const operand_191 = block_196: {
            const operand_192 = (in).start;
            const operand_193 = (in).start;

            break :block_196 block_195: {
                const operand_194 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_194).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_192, .previous = operand_193, });

                break :block_195 @as(*const (zx_abi).zx_type_14, operand_194);
            };
        };
        const operand_197 = block_202: {
            const operand_198 = ((in).start + @as(i64, 100));
            const operand_199 = (in).start;

            break :block_202 block_201: {
                const operand_200 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_200).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_198, .previous = operand_199, });

                break :block_201 @as(*const (zx_abi).zx_type_14, operand_200);
            };
        };

        const operand_203 = @as(u64, 0);
        const operand_204 = (in).count;
        const operand_205 = (in).start;

        break :block_208 block_207: {
            const operand_206 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_206).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_191, .right = operand_197, .index = operand_203, .limit = operand_204, .previous = operand_205, });

            break :block_207 @as(*const (zx_abi).zx_type_17, operand_206);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_190: {
        const operand_165 = value_1;

        const state_type_167 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_168 = struct {
            index: u64,
            left: state_type_167,
            limit: u64,
            previous: i64,
            right: state_type_167,
        };

        var state_164: state_type_168 = state_type_168{ .index = (operand_165).index, .left = state_type_167{ .previous = ((operand_165).left).previous, .total = ((operand_165).left).total, }, .limit = (operand_165).limit, .previous = (operand_165).previous, .right = state_type_167{ .previous = ((operand_165).right).previous, .total = ((operand_165).right).total, }, };
        var state_changed_166 = false;

        while (((state_164).index < (state_164).limit)) {
            state_164 = block_182: {
                const value_4: state_type_167 = block_181: {
                    const operand_175 = state_164;
                    const operand_176 = (zx_abi).zx_type_14{ .previous = ((operand_175).left).previous, .total = ((operand_175).left).total, };
                    const operand_177 = (zx_abi).zx_type_14{ .previous = ((operand_175).right).previous, .total = ((operand_175).right).total, };
                    const operand_178 = (zx_abi).zx_type_17{ .index = (operand_175).index, .left = (&operand_176), .limit = (operand_175).limit, .previous = (operand_175).previous, .right = (&operand_177), };

                    const operand_180 = block_179: {
                        break :block_179 (try function_0_value(allocator, (&operand_178)));
                    };

                    break :block_181 state_type_167{ .previous = (operand_180).previous, .total = (operand_180).total, };
                };

                const value_5: state_type_168 = state_164;
                const value_6: state_type_167 = (value_5).left;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_168 = block_174: {
                    break :block_174 state_type_168{ .index = (value_5).index, .left = block_173: {
                        break :block_173 state_type_167{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_168 = value_8;
                const value_10: state_type_167 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_168 = block_172: {
                    break :block_172 state_type_168{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_171: {
                        break :block_171 state_type_167{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_168 = value_12;

                const value_14: state_type_168 = block_170: {
                    break :block_170 state_type_168{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };

                const value_15: state_type_168 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_168 = block_169: {
                    break :block_169 state_type_168{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_182 value_17;
            };

            state_changed_166 = true;
        }

        break :block_190 (if (state_changed_166) block_189: {
            const operand_188 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_188).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = (state_164).index, .left = block_185: {
                const operand_184 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_184).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_164).left).previous, .total = ((state_164).left).total, });

                break :block_185 @as(*const (zx_abi).zx_type_14, operand_184);
            }, .limit = (state_164).limit, .previous = (state_164).previous, .right = block_187: {
                const operand_186 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_186).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_164).right).previous, .total = ((state_164).right).total, });

                break :block_187 @as(*const (zx_abi).zx_type_14, operand_186);
            }, });

            break :block_189 @as(*const (zx_abi).zx_type_17, operand_188);
        } else operand_165);
    };

    return block_163: {
        const operand_155 = ((value_1).left).total;
        const operand_156 = ((value_18).left).total;
        const operand_157 = (value_18).previous;
        const operand_158 = (value_18).index;
        const operand_159 = ((value_18).right).total;
        const operand_160 = (in).values;

        break :block_163 block_162: {
            const operand_161 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_161).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_155, .total = operand_156, .previous = operand_157, .steps = operand_158, .other = operand_159, .values = operand_160, });

            break :block_162 @as(*const (zx_abi).zx_type_13, operand_161);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_17 = block_54: {
        const operand_37 = block_42: {
            const operand_38 = (in).start;
            const operand_39 = (in).start;

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_40).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_38, .previous = operand_39, });

                break :block_41 @as(*const (zx_abi).zx_type_14, operand_40);
            };
        };
        const operand_43 = block_48: {
            const operand_44 = ((in).start + @as(i64, 100));
            const operand_45 = (in).start;

            break :block_48 block_47: {
                const operand_46 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_46).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_44, .previous = operand_45, });

                break :block_47 @as(*const (zx_abi).zx_type_14, operand_46);
            };
        };

        const operand_49 = @as(u64, 0);
        const operand_50 = (in).count;
        const operand_51 = (in).start;

        break :block_54 block_53: {
            const operand_52 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_52).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_37, .right = operand_43, .index = operand_49, .limit = operand_50, .previous = operand_51, });

            break :block_53 @as(*const (zx_abi).zx_type_17, operand_52);
        };
    };

    const value_18: *const (zx_abi).zx_type_17 = block_36: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_14 = struct {
            index: u64,
            left: state_type_13,
            limit: u64,
            previous: i64,
            right: state_type_13,
        };

        var state_10: state_type_14 = state_type_14{ .index = (operand_11).index, .left = state_type_13{ .previous = ((operand_11).left).previous, .total = ((operand_11).left).total, }, .limit = (operand_11).limit, .previous = (operand_11).previous, .right = state_type_13{ .previous = ((operand_11).right).previous, .total = ((operand_11).right).total, }, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_28: {
                const value_4: state_type_13 = block_27: {
                    const operand_21 = state_10;
                    const operand_22 = (zx_abi).zx_type_14{ .previous = ((operand_21).left).previous, .total = ((operand_21).left).total, };
                    const operand_23 = (zx_abi).zx_type_14{ .previous = ((operand_21).right).previous, .total = ((operand_21).right).total, };
                    const operand_24 = (zx_abi).zx_type_17{ .index = (operand_21).index, .left = (&operand_22), .limit = (operand_21).limit, .previous = (operand_21).previous, .right = (&operand_23), };

                    const operand_26 = block_25: {
                        break :block_25 (try function_0_value(allocator, (&operand_24)));
                    };

                    break :block_27 state_type_13{ .previous = (operand_26).previous, .total = (operand_26).total, };
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).left;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_14 = block_20: {
                    break :block_20 state_type_14{ .index = (value_5).index, .left = block_19: {
                        break :block_19 state_type_13{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_14 = value_8;
                const value_10: state_type_13 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_14 = block_18: {
                    break :block_18 state_type_14{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_17: {
                        break :block_17 state_type_13{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_14 = value_12;

                const value_14: state_type_14 = block_16: {
                    break :block_16 state_type_14{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };
                const value_15: state_type_14 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_28 value_17;
            };

            state_changed_12 = true;
        }

        break :block_36 (if (state_changed_12) block_35: {
            const operand_34 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_34).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .index = (state_10).index, .left = block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_30).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).left).previous, .total = ((state_10).left).total, });

                break :block_31 @as(*const (zx_abi).zx_type_14, operand_30);
            }, .limit = (state_10).limit, .previous = (state_10).previous, .right = block_33: {
                const operand_32 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_32).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = ((state_10).right).previous, .total = ((state_10).right).total, });

                break :block_33 @as(*const (zx_abi).zx_type_14, operand_32);
            }, });

            break :block_35 @as(*const (zx_abi).zx_type_17, operand_34);
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

