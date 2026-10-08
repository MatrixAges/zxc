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

    const value_1: *const (zx_abi).zx_type_17 = block_49: {
        const operand_32 = block_37: {
            const operand_33 = (in).start;
            const operand_34 = (in).start;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_35).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_33, .previous = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_14, operand_35);
            };
        };
        const operand_38 = block_43: {
            const operand_39 = ((in).start + @as(i64, 100));
            const operand_40 = (in).start;

            break :block_43 block_42: {
                const operand_41 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_41).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_39, .previous = operand_40, });

                break :block_42 @as(*const (zx_abi).zx_type_14, operand_41);
            };
        };

        const operand_44 = @as(u64, 0);
        const operand_45 = (in).count;
        const operand_46 = (in).start;

        break :block_49 block_48: {
            const operand_47 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_47).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_32, .right = operand_38, .index = operand_44, .limit = operand_45, .previous = operand_46, });

            break :block_48 @as(*const (zx_abi).zx_type_17, operand_47);
        };
    };

    return block_31: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_4 = struct {
            index: u64,
            left: state_type_3,
            limit: u64,
            previous: i64,
            right: state_type_3,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .index = (operand_2).index, .left = state_type_3{ .previous = ((operand_2).left).previous, .total = ((operand_2).left).total, }, .limit = (operand_2).limit, .previous = (operand_2).previous, .right = state_type_3{ .previous = ((operand_2).right).previous, .total = ((operand_2).right).total, }, };
        };

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_21: {
                const value_4: state_type_3 = block_20: {
                    const operand_14 = state_1;
                    const operand_15 = (zx_abi).zx_type_14{ .previous = ((operand_14).left).previous, .total = ((operand_14).left).total, };
                    const operand_16 = (zx_abi).zx_type_14{ .previous = ((operand_14).right).previous, .total = ((operand_14).right).total, };
                    const operand_17 = (zx_abi).zx_type_17{ .index = (operand_14).index, .left = (&operand_15), .limit = (operand_14).limit, .previous = (operand_14).previous, .right = (&operand_16), };

                    const operand_19 = block_18: {
                        break :block_18 (try function_0_value(allocator, (&operand_17)));
                    };

                    break :block_20 state_type_3{ .previous = (operand_19).previous, .total = (operand_19).total, };
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).left;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_4 = block_13: {
                    break :block_13 state_type_4{ .index = (value_5).index, .left = block_12: {
                        break :block_12 state_type_3{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_4 = value_8;
                const value_10: state_type_3 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_4 = block_11: {
                    break :block_11 state_type_4{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_10: {
                        break :block_10 state_type_3{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_4 = value_12;

                const value_14: state_type_4 = block_9: {
                    break :block_9 state_type_4{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };
                const value_15: state_type_4 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_21 value_17;
            };

            state_changed_7 = true;
        }

        break :block_31 block_30: {
            const operand_22 = ((value_1).left).total;
            const operand_23 = ((state_1).left).total;
            const operand_24 = (state_1).previous;
            const operand_25 = (state_1).index;
            const operand_26 = ((state_1).right).total;
            const operand_27 = (in).values;

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_28).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_22, .total = operand_23, .previous = operand_24, .steps = operand_25, .other = operand_26, .values = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_13, operand_28);
            };
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_100: {
        const operand_85 = block_90: {
            const operand_86 = (in).start;
            const operand_87 = (in).start;

            break :block_90 block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_88).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_86, .previous = operand_87, });

                break :block_89 @as(*const (zx_abi).zx_type_14, operand_88);
            };
        };
        const operand_91 = block_96: {
            const operand_92 = ((in).start + @as(i64, 100));
            const operand_93 = (in).start;

            break :block_96 block_95: {
                const operand_94 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_94).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_92, .previous = operand_93, });

                break :block_95 @as(*const (zx_abi).zx_type_14, operand_94);
            };
        };

        const operand_97 = @as(u64, 0);
        const operand_98 = (in).count;
        const operand_99 = (in).start;

        break :block_100 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .left = operand_85, .right = operand_91, .index = operand_97, .limit = operand_98, .previous = operand_99, });
    };

    const value_18: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_84: {
        const operand_59 = value_1;
        var state_58: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_59;
        var state_changed_60 = false;

        while (((state_58).index < (state_58).limit)) {
            state_58 = block_82: {
                const value_4: (zx_abi).zx_type_14 = block_81: {
                    const operand_79 = state_58;
                    var state_borrow_80: (zx_abi).zx_type_17 = undefined;
                    state_borrow_80 = (zx_abi).zx_type_17{ .index = (operand_79).index, .left = (operand_79).left, .limit = (operand_79).limit, .previous = (operand_79).previous, .right = (operand_79).right, };

                    break :block_81 (try function_0_value(allocator, ((operand_79).zx_origin orelse (&state_borrow_80))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_58;
                const value_6: (zx_abi).zx_type_14 = ((value_5).left).*;

                const value_7: i64 = (block_78: {
                    break :block_78 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_77: {
                    break :block_77 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_76: {
                        break :block_76 block_75: {
                            const operand_74 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_74).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_72: {
                                break :block_72 (&value_6);
                            }).previous, .total = (block_73: {
                                break :block_73 value_7;
                            } + @as(i64, 1)), });

                            break :block_75 @as(*const (zx_abi).zx_type_14, operand_74);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).right).*;

                const value_11: i64 = (block_71: {
                    break :block_71 (&value_10);
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_70: {
                    break :block_70 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_69: {
                        break :block_69 block_68: {
                            const operand_67 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_67).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_65: {
                                break :block_65 (&value_10);
                            }).previous, .total = (block_66: {
                                break :block_66 value_11;
                            } + @as(i64, 2)), });

                            break :block_68 @as(*const (zx_abi).zx_type_14, operand_67);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_64: {
                    break :block_64 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_63: {
                        break :block_63 (&value_4);
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_62: {
                    break :block_62 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_61: {
                        break :block_61 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_82 value_17;
            };

            state_changed_60 = true;
        }

        break :block_84 (if (state_changed_60) state_58 else operand_59);
    };

    return block_57: {
        const operand_51 = ((value_1).left).total;
        const operand_52 = ((value_18).left).total;
        const operand_53 = (value_18).previous;
        const operand_54 = (value_18).index;
        const operand_55 = ((value_18).right).total;
        const operand_56 = (in).values;

        break :block_57 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_51, .total = operand_52, .previous = operand_53, .steps = operand_54, .other = operand_55, .values = operand_56, });
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

    const value_1: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_151: {
        const operand_136 = block_141: {
            const operand_137 = (in).start;
            const operand_138 = (in).start;

            break :block_141 block_140: {
                const operand_139 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_139).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_137, .previous = operand_138, });

                break :block_140 @as(*const (zx_abi).zx_type_14, operand_139);
            };
        };
        const operand_142 = block_147: {
            const operand_143 = ((in).start + @as(i64, 100));
            const operand_144 = (in).start;

            break :block_147 block_146: {
                const operand_145 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_145).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_143, .previous = operand_144, });

                break :block_146 @as(*const (zx_abi).zx_type_14, operand_145);
            };
        };

        const operand_148 = @as(u64, 0);
        const operand_149 = (in).count;
        const operand_150 = (in).start;

        break :block_151 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .left = operand_136, .right = operand_142, .index = operand_148, .limit = operand_149, .previous = operand_150, });
    };

    const value_18: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_135: {
        const operand_110 = value_1;
        var state_109: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = operand_110;
        var state_changed_111 = false;

        while (((state_109).index < (state_109).limit)) {
            state_109 = block_133: {
                const value_4: (zx_abi).zx_type_14 = block_132: {
                    const operand_130 = state_109;
                    var state_borrow_131: (zx_abi).zx_type_17 = undefined;

                    state_borrow_131 = (zx_abi).zx_type_17{ .index = (operand_130).index, .left = (operand_130).left, .limit = (operand_130).limit, .previous = (operand_130).previous, .right = (operand_130).right, };

                    break :block_132 (try function_0_value(allocator, ((operand_130).zx_origin orelse (&state_borrow_131))));
                };

                const value_5: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = state_109;
                const value_6: (zx_abi).zx_type_14 = ((value_5).left).*;

                const value_7: i64 = (block_129: {
                    break :block_129 (&value_6);
                }).total;

                const value_8: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_128: {
                    break :block_128 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_5).index, .left = block_127: {
                        break :block_127 block_126: {
                            const operand_125 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_125).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_123: {
                                break :block_123 (&value_6);
                            }).previous, .total = (block_124: {
                                break :block_124 value_7;
                            } + @as(i64, 1)), });

                            break :block_126 @as(*const (zx_abi).zx_type_14, operand_125);
                        };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, });
                };
                const value_9: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_8;
                const value_10: (zx_abi).zx_type_14 = ((value_9).right).*;

                const value_11: i64 = (block_122: {
                    break :block_122 (&value_10);
                }).total;

                const value_12: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_121: {
                    break :block_121 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_120: {
                        break :block_120 block_119: {
                            const operand_118 = (try (allocator).create((zx_abi).zx_type_14));

                            (operand_118).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .previous = (block_116: {
                                break :block_116 (&value_10);
                            }).previous, .total = (block_117: {
                                break :block_117 value_11;
                            } + @as(i64, 2)), });

                            break :block_119 @as(*const (zx_abi).zx_type_14, operand_118);
                        };
                    }, });
                };

                const value_13: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_12;

                const value_14: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_115: {
                    break :block_115 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (block_114: {
                        break :block_114 (&value_4);
                    }).total, .right = (value_13).right, });
                };

                const value_15: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = block_113: {
                    break :block_113 @as((zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .index = (block_112: {
                        break :block_112 value_16;
                    } + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, });
                };

                break :block_133 value_17;
            };

            state_changed_111 = true;
        }

        break :block_135 (if (state_changed_111) state_109 else operand_110);
    };

    return block_108: {
        const operand_102 = ((value_1).left).total;
        const operand_103 = ((value_18).left).total;
        const operand_104 = (value_18).previous;
        const operand_105 = (value_18).index;
        const operand_106 = ((value_18).right).total;
        const operand_107 = (in).values;

        break :block_108 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_102, .total = operand_103, .previous = operand_104, .steps = operand_105, .other = operand_106, .values = operand_107, });
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

    const value_1: *const (zx_abi).zx_type_17 = block_200: {
        const operand_183 = block_188: {
            const operand_184 = (in).start;
            const operand_185 = (in).start;

            break :block_188 block_187: {
                const operand_186 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_186).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_184, .previous = operand_185, });

                break :block_187 @as(*const (zx_abi).zx_type_14, operand_186);
            };
        };
        const operand_189 = block_194: {
            const operand_190 = ((in).start + @as(i64, 100));
            const operand_191 = (in).start;

            break :block_194 block_193: {
                const operand_192 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_192).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_190, .previous = operand_191, });

                break :block_193 @as(*const (zx_abi).zx_type_14, operand_192);
            };
        };

        const operand_195 = @as(u64, 0);
        const operand_196 = (in).count;
        const operand_197 = (in).start;

        break :block_200 block_199: {
            const operand_198 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_198).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_183, .right = operand_189, .index = operand_195, .limit = operand_196, .previous = operand_197, });

            break :block_199 @as(*const (zx_abi).zx_type_17, operand_198);
        };
    };

    return block_182: {
        const state_type_154 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_155 = struct {
            index: u64,
            left: state_type_154,
            limit: u64,
            previous: i64,
            right: state_type_154,
        };
        const operand_157 = block_156: {
            const operand_153 = value_1;

            break :block_156 state_type_155{ .index = (operand_153).index, .left = state_type_154{ .previous = ((operand_153).left).previous, .total = ((operand_153).left).total, }, .limit = (operand_153).limit, .previous = (operand_153).previous, .right = state_type_154{ .previous = ((operand_153).right).previous, .total = ((operand_153).right).total, }, };
        };

        var state_152: state_type_155 = operand_157;
        var state_changed_158 = false;

        while (((state_152).index < (state_152).limit)) {
            state_152 = block_172: {
                const value_4: state_type_154 = block_171: {
                    const operand_165 = state_152;
                    const operand_166 = (zx_abi).zx_type_14{ .previous = ((operand_165).left).previous, .total = ((operand_165).left).total, };
                    const operand_167 = (zx_abi).zx_type_14{ .previous = ((operand_165).right).previous, .total = ((operand_165).right).total, };
                    const operand_168 = (zx_abi).zx_type_17{ .index = (operand_165).index, .left = (&operand_166), .limit = (operand_165).limit, .previous = (operand_165).previous, .right = (&operand_167), };

                    const operand_170 = block_169: {
                        break :block_169 (try function_0_value(allocator, (&operand_168)));
                    };

                    break :block_171 state_type_154{ .previous = (operand_170).previous, .total = (operand_170).total, };
                };

                const value_5: state_type_155 = state_152;
                const value_6: state_type_154 = (value_5).left;
                const value_7: i64 = (value_6).total;

                const value_8: state_type_155 = block_164: {
                    break :block_164 state_type_155{ .index = (value_5).index, .left = block_163: {
                        break :block_163 state_type_154{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_155 = value_8;
                const value_10: state_type_154 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_155 = block_162: {
                    break :block_162 state_type_155{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_161: {
                        break :block_161 state_type_154{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_155 = value_12;

                const value_14: state_type_155 = block_160: {
                    break :block_160 state_type_155{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };

                const value_15: state_type_155 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_155 = block_159: {
                    break :block_159 state_type_155{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_172 value_17;
            };

            state_changed_158 = true;
        }

        break :block_182 block_181: {
            const operand_173 = ((value_1).left).total;
            const operand_174 = ((state_152).left).total;
            const operand_175 = (state_152).previous;
            const operand_176 = (state_152).index;
            const operand_177 = ((state_152).right).total;
            const operand_178 = (in).values;

            break :block_181 block_180: {
                const operand_179 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_179).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_173, .total = operand_174, .previous = operand_175, .steps = operand_176, .other = operand_177, .values = operand_178, });

                break :block_180 @as(*const (zx_abi).zx_type_13, operand_179);
            };
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_17 = block_49: {
        const operand_32 = block_37: {
            const operand_33 = (in).start;
            const operand_34 = (in).start;

            break :block_37 block_36: {
                const operand_35 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_35).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_33, .previous = operand_34, });

                break :block_36 @as(*const (zx_abi).zx_type_14, operand_35);
            };
        };
        const operand_38 = block_43: {
            const operand_39 = ((in).start + @as(i64, 100));
            const operand_40 = (in).start;

            break :block_43 block_42: {
                const operand_41 = (try (allocator).create((zx_abi).zx_type_14));

                (operand_41).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .total = operand_39, .previous = operand_40, });

                break :block_42 @as(*const (zx_abi).zx_type_14, operand_41);
            };
        };

        const operand_44 = @as(u64, 0);
        const operand_45 = (in).count;
        const operand_46 = (in).start;

        break :block_49 block_48: {
            const operand_47 = (try (allocator).create((zx_abi).zx_type_17));

            (operand_47).* = @as((zx_abi).zx_type_17, (zx_abi).zx_type_17{ .left = operand_32, .right = operand_38, .index = operand_44, .limit = operand_45, .previous = operand_46, });

            break :block_48 @as(*const (zx_abi).zx_type_17, operand_47);
        };
    };

    return block_31: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
        };
        const state_type_4 = struct {
            index: u64,
            left: state_type_3,
            limit: u64,
            previous: i64,
            right: state_type_3,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .index = (operand_2).index, .left = state_type_3{ .previous = ((operand_2).left).previous, .total = ((operand_2).left).total, }, .limit = (operand_2).limit, .previous = (operand_2).previous, .right = state_type_3{ .previous = ((operand_2).right).previous, .total = ((operand_2).right).total, }, };
        };

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_21: {
                const value_4: state_type_3 = block_20: {
                    const operand_14 = state_1;
                    const operand_15 = (zx_abi).zx_type_14{ .previous = ((operand_14).left).previous, .total = ((operand_14).left).total, };
                    const operand_16 = (zx_abi).zx_type_14{ .previous = ((operand_14).right).previous, .total = ((operand_14).right).total, };
                    const operand_17 = (zx_abi).zx_type_17{ .index = (operand_14).index, .left = (&operand_15), .limit = (operand_14).limit, .previous = (operand_14).previous, .right = (&operand_16), };

                    const operand_19 = block_18: {
                        break :block_18 (try function_0_value(allocator, (&operand_17)));
                    };

                    break :block_20 state_type_3{ .previous = (operand_19).previous, .total = (operand_19).total, };
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).left;
                const value_7: i64 = (value_6).total;
                const value_8: state_type_4 = block_13: {
                    break :block_13 state_type_4{ .index = (value_5).index, .left = block_12: {
                        break :block_12 state_type_3{ .previous = (value_6).previous, .total = (value_7 + @as(i64, 1)), };
                    }, .limit = (value_5).limit, .previous = (value_5).previous, .right = (value_5).right, };
                };
                const value_9: state_type_4 = value_8;
                const value_10: state_type_3 = (value_9).right;
                const value_11: i64 = (value_10).total;

                const value_12: state_type_4 = block_11: {
                    break :block_11 state_type_4{ .index = (value_9).index, .left = (value_9).left, .limit = (value_9).limit, .previous = (value_9).previous, .right = block_10: {
                        break :block_10 state_type_3{ .previous = (value_10).previous, .total = (value_11 + @as(i64, 2)), };
                    }, };
                };
                const value_13: state_type_4 = value_12;

                const value_14: state_type_4 = block_9: {
                    break :block_9 state_type_4{ .index = (value_13).index, .left = (value_13).left, .limit = (value_13).limit, .previous = (value_4).total, .right = (value_13).right, };
                };
                const value_15: state_type_4 = value_14;
                const value_16: u64 = (value_15).index;

                const value_17: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .index = (value_16 + @as(u64, 1)), .left = (value_15).left, .limit = (value_15).limit, .previous = (value_15).previous, .right = (value_15).right, };
                };

                break :block_21 value_17;
            };

            state_changed_7 = true;
        }

        break :block_31 block_30: {
            const operand_22 = ((value_1).left).total;
            const operand_23 = ((state_1).left).total;
            const operand_24 = (state_1).previous;
            const operand_25 = (state_1).index;
            const operand_26 = ((state_1).right).total;
            const operand_27 = (in).values;

            break :block_30 block_29: {
                const operand_28 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_28).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_22, .total = operand_23, .previous = operand_24, .steps = operand_25, .other = operand_26, .values = operand_27, });

                break :block_29 @as(*const (zx_abi).zx_type_13, operand_28);
            };
        };
    };
}

