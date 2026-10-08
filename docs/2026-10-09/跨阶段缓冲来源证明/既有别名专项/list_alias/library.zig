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

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20) error{ }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in).box;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be) error{ }!(zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 {
    @setRuntimeSafety(true);

    _ = allocator;

    return (in).box;
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ }!(zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return (in).box;
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_20, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return (in).box;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_20 = block_61: {
        const operand_50 = block_56: {
            const operand_51 = (in).values;
            const operand_52 = (in).start;
            const operand_53 = (in).start;

            break :block_56 block_55: {
                const operand_54 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_54).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .values = operand_51, .total = operand_52, .previous = operand_53, });

                break :block_55 @as(*const (zx_abi).zx_type_19, operand_54);
            };
        };

        const operand_57 = @as(u64, 0);
        const operand_58 = (in).count;

        break :block_61 block_60: {
            const operand_59 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_59).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = operand_50, .index = operand_57, .limit = operand_58, });

            break :block_60 @as(*const (zx_abi).zx_type_20, operand_59);
        };
    };

    const value_21: *const (zx_abi).zx_type_20 = block_49: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
            values: []const i64,
        };
        const state_type_14 = struct {
            box: state_type_13,
            index: u64,
            limit: u64,
        };

        var state_10: state_type_14 = state_type_14{ .box = state_type_13{ .previous = ((operand_11).box).previous, .total = ((operand_11).box).total, .values = ((operand_11).box).values, }, .index = (operand_11).index, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_43: {
                const value_4: state_type_13 = block_42: {
                    const operand_34 = state_10;
                    const operand_35 = (zx_abi).zx_type_19{ .previous = ((operand_34).box).previous, .total = ((operand_34).box).total, .values = ((operand_34).box).values, };
                    const operand_36 = (zx_abi).zx_type_20{ .box = (&operand_35), .index = (operand_34).index, .limit = (operand_34).limit, };

                    const operand_41 = block_40: {
                        const operand_37 = (&operand_36);
                        const operand_38 = (try function_0_value(allocator, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = ((operand_37).box).previous, .total = ((operand_37).box).total, .values = ((operand_37).box).values, .zx_origin = (operand_37).box, }, .index = (operand_37).index, .limit = (operand_37).limit, .zx_origin = operand_37, }));

                        break :block_40 (if (((operand_38).zx_origin != null)) ((operand_38).zx_origin.?).* else block_39: {
                            break :block_39 (zx_abi).zx_type_19{ .previous = (operand_38).previous, .total = (operand_38).total, .values = (operand_38).values, };
                        });
                    };

                    break :block_42 state_type_13{ .previous = (operand_41).previous, .total = (operand_41).total, .values = (operand_41).values, };
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);
                const value_9: i64 = block_33: {
                    const operand_31 = value_7;
                    const operand_32 = value_8;

                    if ((operand_32 >= (operand_31).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_33 (operand_31)[@intCast(operand_32)];
                };

                const value_10: state_type_14 = block_30: {
                    break :block_30 state_type_14{ .box = block_29: {
                        break :block_29 state_type_13{ .previous = (value_6).previous, .total = (value_6).total, .values = block_28: {
                            const operand_23 = value_7;
                            const operand_24 = value_8;

                            if ((operand_24 >= (operand_23).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_25 = (value_9 + @as(i64, 1));

                            break :block_28 block_27: {
                                const operand_26 = (try (allocator).dupe(i64, operand_23));

                                (operand_26)[@intCast(operand_24)] = operand_25;
                                break :block_27 operand_26;
                            };
                        }, };
                    }, .index = (value_5).index, .limit = (value_5).limit, };
                };
                const value_11: state_type_14 = value_10;
                const value_12: state_type_13 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: state_type_14 = block_22: {
                    break :block_22 state_type_14{ .box = block_21: {
                        break :block_21 state_type_13{ .previous = (value_12).previous, .total = (value_13 + block_20: {
                            const operand_18 = (value_4).values;
                            const operand_19 = @as(u64, 0);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        }), .values = (value_12).values, };
                    }, .index = (value_11).index, .limit = (value_11).limit, };
                };
                const value_15: state_type_14 = value_14;
                const value_16: state_type_13 = (value_15).box;

                const value_17: state_type_14 = block_17: {
                    break :block_17 state_type_14{ .box = block_16: {
                        break :block_16 state_type_13{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, };
                    }, .index = (value_15).index, .limit = (value_15).limit, };
                };
                const value_18: state_type_14 = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .box = (value_18).box, .index = (value_19 + @as(u64, 1)), .limit = (value_18).limit, };
                };

                break :block_43 value_20;
            };

            state_changed_12 = true;
        }

        break :block_49 (if (state_changed_12) block_48: {
            const operand_47 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_47).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = block_46: {
                const operand_45 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_45).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .previous = ((state_10).box).previous, .total = ((state_10).box).total, .values = ((state_10).box).values, });

                break :block_46 @as(*const (zx_abi).zx_type_19, operand_45);
            }, .index = (state_10).index, .limit = (state_10).limit, });

            break :block_48 @as(*const (zx_abi).zx_type_20, operand_47);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).box).total;
        const operand_2 = ((value_21).box).total;
        const operand_3 = ((value_21).box).previous;
        const operand_4 = (value_21).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = ((value_21).box).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_109: {
        const operand_102 = block_106: {
            const operand_103 = (in).values;
            const operand_104 = (in).start;
            const operand_105 = (in).start;

            break :block_106 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .values = operand_103, .total = operand_104, .previous = operand_105, });
        };

        const operand_107 = @as(u64, 0);
        const operand_108 = (in).count;

        break :block_109 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = operand_102, .index = operand_107, .limit = operand_108, });
    };

    const value_21: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_101: {
        const operand_70 = value_1;
        var state_69: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = operand_70;
        var state_changed_71 = false;

        while (((state_69).index < (state_69).limit)) {
            state_69 = block_99: {
                const value_4: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_98: {
                    break :block_98 (try function_0_value(allocator, state_69));
                };

                const value_5: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = state_69;
                const value_6: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);

                const value_9: i64 = block_97: {
                    const operand_95 = block_93: {
                        break :block_93 value_7;
                    };
                    const operand_96 = block_94: {
                        break :block_94 value_8;
                    };

                    if ((operand_96 >= (operand_95).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_97 (operand_95)[@intCast(operand_96)];
                };
                const value_10: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_92: {
                    break :block_92 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_91: {
                        break :block_91 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_6).previous, .total = (value_6).total, .values = block_90: {
                            const operand_83 = block_82: {
                                break :block_82 value_7;
                            };
                            const operand_85 = block_84: {
                                break :block_84 value_8;
                            };

                            if ((operand_85 >= (operand_83).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_87 = (block_86: {
                                break :block_86 value_9;
                            } + @as(i64, 1));

                            break :block_90 block_89: {
                                const operand_88 = (try (allocator).dupe(i64, operand_83));

                                (operand_88)[@intCast(operand_85)] = operand_87;

                                break :block_89 operand_88;
                            };
                        }, });
                    }, .index = (value_5).index, .limit = (value_5).limit, });
                };
                const value_11: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_10;
                const value_12: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_81: {
                    break :block_81 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_80: {
                        break :block_80 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_12).previous, .total = (block_76: {
                            break :block_76 value_13;
                        } + block_79: {
                            const operand_77 = (value_4).values;
                            const operand_78 = @as(u64, 0);

                            if ((operand_78 >= (operand_77).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_79 (operand_77)[@intCast(operand_78)];
                        }), .values = (value_12).values, });
                    }, .index = (value_11).index, .limit = (value_11).limit, });
                };

                const value_15: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_14;
                const value_16: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_15).box;

                const value_17: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_75: {
                    break :block_75 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_74: {
                        break :block_74 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, });
                    }, .index = (value_15).index, .limit = (value_15).limit, });
                };

                const value_18: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_73: {
                    break :block_73 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (value_18).box, .index = (block_72: {
                        break :block_72 value_19;
                    } + @as(u64, 1)), .limit = (value_18).limit, });
                };

                break :block_99 value_20;
            };

            state_changed_71 = true;
        }

        break :block_101 (if (state_changed_71) state_69 else operand_70);
    };

    return block_68: {
        const operand_62 = ((value_1).box).total;
        const operand_63 = ((value_21).box).total;
        const operand_64 = ((value_21).box).previous;
        const operand_65 = (value_21).index;
        const operand_66 = @as(i64, 0);
        const operand_67 = ((value_21).box).values;

        break :block_68 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_62, .total = operand_63, .previous = operand_64, .steps = operand_65, .other = operand_66, .values = operand_67, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_20 = block_61: {
        const operand_50 = block_56: {
            const operand_51 = (in).values;
            const operand_52 = (in).start;
            const operand_53 = (in).start;

            break :block_56 block_55: {
                const operand_54 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_54).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .values = operand_51, .total = operand_52, .previous = operand_53, });

                break :block_55 @as(*const (zx_abi).zx_type_19, operand_54);
            };
        };

        const operand_57 = @as(u64, 0);
        const operand_58 = (in).count;

        break :block_61 block_60: {
            const operand_59 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_59).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = operand_50, .index = operand_57, .limit = operand_58, });

            break :block_60 @as(*const (zx_abi).zx_type_20, operand_59);
        };
    };

    const value_21: *const (zx_abi).zx_type_20 = block_49: {
        const operand_11 = value_1;

        const state_type_13 = struct {
            previous: i64,
            total: i64,
            values: []const i64,
        };
        const state_type_14 = struct {
            box: state_type_13,
            index: u64,
            limit: u64,
        };

        var state_10: state_type_14 = state_type_14{ .box = state_type_13{ .previous = ((operand_11).box).previous, .total = ((operand_11).box).total, .values = ((operand_11).box).values, }, .index = (operand_11).index, .limit = (operand_11).limit, };
        var state_changed_12 = false;

        while (((state_10).index < (state_10).limit)) {
            state_10 = block_43: {
                const value_4: state_type_13 = block_42: {
                    const operand_34 = state_10;
                    const operand_35 = (zx_abi).zx_type_19{ .previous = ((operand_34).box).previous, .total = ((operand_34).box).total, .values = ((operand_34).box).values, };
                    const operand_36 = (zx_abi).zx_type_20{ .box = (&operand_35), .index = (operand_34).index, .limit = (operand_34).limit, };

                    const operand_41 = block_40: {
                        const operand_37 = (&operand_36);
                        const operand_38 = (try function_0_value(allocator, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = ((operand_37).box).previous, .total = ((operand_37).box).total, .values = ((operand_37).box).values, .zx_origin = (operand_37).box, }, .index = (operand_37).index, .limit = (operand_37).limit, .zx_origin = operand_37, }));

                        break :block_40 (if (((operand_38).zx_origin != null)) ((operand_38).zx_origin.?).* else block_39: {
                            break :block_39 (zx_abi).zx_type_19{ .previous = (operand_38).previous, .total = (operand_38).total, .values = (operand_38).values, };
                        });
                    };

                    break :block_42 state_type_13{ .previous = (operand_41).previous, .total = (operand_41).total, .values = (operand_41).values, };
                };
                const value_5: state_type_14 = state_10;
                const value_6: state_type_13 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);
                const value_9: i64 = block_33: {
                    const operand_31 = value_7;
                    const operand_32 = value_8;

                    if ((operand_32 >= (operand_31).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_33 (operand_31)[@intCast(operand_32)];
                };

                const value_10: state_type_14 = block_30: {
                    break :block_30 state_type_14{ .box = block_29: {
                        break :block_29 state_type_13{ .previous = (value_6).previous, .total = (value_6).total, .values = block_28: {
                            const operand_23 = value_7;
                            const operand_24 = value_8;

                            if ((operand_24 >= (operand_23).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_25 = (value_9 + @as(i64, 1));

                            break :block_28 block_27: {
                                const operand_26 = (try (allocator).dupe(i64, operand_23));

                                (operand_26)[@intCast(operand_24)] = operand_25;
                                break :block_27 operand_26;
                            };
                        }, };
                    }, .index = (value_5).index, .limit = (value_5).limit, };
                };
                const value_11: state_type_14 = value_10;
                const value_12: state_type_13 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: state_type_14 = block_22: {
                    break :block_22 state_type_14{ .box = block_21: {
                        break :block_21 state_type_13{ .previous = (value_12).previous, .total = (value_13 + block_20: {
                            const operand_18 = (value_4).values;
                            const operand_19 = @as(u64, 0);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        }), .values = (value_12).values, };
                    }, .index = (value_11).index, .limit = (value_11).limit, };
                };
                const value_15: state_type_14 = value_14;
                const value_16: state_type_13 = (value_15).box;

                const value_17: state_type_14 = block_17: {
                    break :block_17 state_type_14{ .box = block_16: {
                        break :block_16 state_type_13{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, };
                    }, .index = (value_15).index, .limit = (value_15).limit, };
                };
                const value_18: state_type_14 = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: state_type_14 = block_15: {
                    break :block_15 state_type_14{ .box = (value_18).box, .index = (value_19 + @as(u64, 1)), .limit = (value_18).limit, };
                };

                break :block_43 value_20;
            };

            state_changed_12 = true;
        }

        break :block_49 (if (state_changed_12) block_48: {
            const operand_47 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_47).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = block_46: {
                const operand_45 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_45).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .previous = ((state_10).box).previous, .total = ((state_10).box).total, .values = ((state_10).box).values, });

                break :block_46 @as(*const (zx_abi).zx_type_19, operand_45);
            }, .index = (state_10).index, .limit = (state_10).limit, });

            break :block_48 @as(*const (zx_abi).zx_type_20, operand_47);
        } else operand_11);
    };

    return block_9: {
        const operand_1 = ((value_1).box).total;
        const operand_2 = ((value_21).box).total;
        const operand_3 = ((value_21).box).previous;
        const operand_4 = (value_21).index;
        const operand_5 = @as(i64, 0);
        const operand_6 = ((value_21).box).values;

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_7).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_1, .total = operand_2, .previous = operand_3, .steps = operand_4, .other = operand_5, .values = operand_6, });

            break :block_8 @as(*const (zx_abi).zx_type_13, operand_7);
        };
    };
}

