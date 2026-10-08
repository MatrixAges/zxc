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

    const value_1: *const (zx_abi).zx_type_20 = block_58: {
        const operand_47 = block_53: {
            const operand_48 = (in).values;
            const operand_49 = (in).start;
            const operand_50 = (in).start;

            break :block_53 block_52: {
                const operand_51 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_51).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .values = operand_48, .total = operand_49, .previous = operand_50, });

                break :block_52 @as(*const (zx_abi).zx_type_19, operand_51);
            };
        };

        const operand_54 = @as(u64, 0);
        const operand_55 = (in).count;

        break :block_58 block_57: {
            const operand_56 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_56).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = operand_47, .index = operand_54, .limit = operand_55, });

            break :block_57 @as(*const (zx_abi).zx_type_20, operand_56);
        };
    };

    return block_46: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
            values: []const i64,
        };
        const state_type_4 = struct {
            box: state_type_3,
            index: u64,
            limit: u64,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .box = state_type_3{ .previous = ((operand_2).box).previous, .total = ((operand_2).box).total, .values = ((operand_2).box).values, }, .index = (operand_2).index, .limit = (operand_2).limit, };
        };

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_36: {
                const value_4: state_type_3 = block_35: {
                    const operand_27 = state_1;
                    const operand_28 = (zx_abi).zx_type_19{ .previous = ((operand_27).box).previous, .total = ((operand_27).box).total, .values = ((operand_27).box).values, };
                    const operand_29 = (zx_abi).zx_type_20{ .box = (&operand_28), .index = (operand_27).index, .limit = (operand_27).limit, };

                    const operand_34 = block_33: {
                        const operand_30 = (&operand_29);
                        const operand_31 = (try function_0_value(allocator, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = ((operand_30).box).previous, .total = ((operand_30).box).total, .values = ((operand_30).box).values, .zx_origin = (operand_30).box, }, .index = (operand_30).index, .limit = (operand_30).limit, .zx_origin = operand_30, }));

                        break :block_33 (if (((operand_31).zx_origin != null)) ((operand_31).zx_origin.?).* else block_32: {
                            break :block_32 (zx_abi).zx_type_19{ .previous = (operand_31).previous, .total = (operand_31).total, .values = (operand_31).values, };
                        });
                    };

                    break :block_35 state_type_3{ .previous = (operand_34).previous, .total = (operand_34).total, .values = (operand_34).values, };
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);
                const value_9: i64 = block_26: {
                    const operand_24 = value_7;
                    const operand_25 = value_8;

                    if ((operand_25 >= (operand_24).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_26 (operand_24)[@intCast(operand_25)];
                };
                const value_10: state_type_4 = block_23: {
                    break :block_23 state_type_4{ .box = block_22: {
                        break :block_22 state_type_3{ .previous = (value_6).previous, .total = (value_6).total, .values = block_21: {
                            const operand_16 = value_7;
                            const operand_17 = value_8;

                            if ((operand_17 >= (operand_16).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_18 = (value_9 + @as(i64, 1));

                            break :block_21 block_20: {
                                const operand_19 = (try (allocator).dupe(i64, operand_16));

                                (operand_19)[@intCast(operand_17)] = operand_18;

                                break :block_20 operand_19;
                            };
                        }, };
                    }, .index = (value_5).index, .limit = (value_5).limit, };
                };
                const value_11: state_type_4 = value_10;
                const value_12: state_type_3 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: state_type_4 = block_15: {
                    break :block_15 state_type_4{ .box = block_14: {
                        break :block_14 state_type_3{ .previous = (value_12).previous, .total = (value_13 + block_13: {
                            const operand_11 = (value_4).values;
                            const operand_12 = @as(u64, 0);

                            if ((operand_12 >= (operand_11).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_13 (operand_11)[@intCast(operand_12)];
                        }), .values = (value_12).values, };
                    }, .index = (value_11).index, .limit = (value_11).limit, };
                };
                const value_15: state_type_4 = value_14;
                const value_16: state_type_3 = (value_15).box;

                const value_17: state_type_4 = block_10: {
                    break :block_10 state_type_4{ .box = block_9: {
                        break :block_9 state_type_3{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, };
                    }, .index = (value_15).index, .limit = (value_15).limit, };
                };
                const value_18: state_type_4 = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .box = (value_18).box, .index = (value_19 + @as(u64, 1)), .limit = (value_18).limit, };
                };

                break :block_36 value_20;
            };

            state_changed_7 = true;
        }

        break :block_46 block_45: {
            const operand_37 = ((value_1).box).total;
            const operand_38 = ((state_1).box).total;
            const operand_39 = ((state_1).box).previous;
            const operand_40 = (state_1).index;
            const operand_41 = @as(i64, 0);
            const operand_42 = ((state_1).box).values;

            break :block_45 block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_43).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_37, .total = operand_38, .previous = operand_39, .steps = operand_40, .other = operand_41, .values = operand_42, });

                break :block_44 @as(*const (zx_abi).zx_type_13, operand_43);
            };
        };
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_107: {
        const operand_100 = block_104: {
            const operand_101 = (in).values;
            const operand_102 = (in).start;
            const operand_103 = (in).start;

            break :block_104 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .values = operand_101, .total = operand_102, .previous = operand_103, });
        };

        const operand_105 = @as(u64, 0);
        const operand_106 = (in).count;

        break :block_107 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = operand_100, .index = operand_105, .limit = operand_106, });
    };

    const value_21: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_99: {
        const operand_68 = value_1;
        var state_67: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = operand_68;
        var state_changed_69 = false;

        while (((state_67).index < (state_67).limit)) {
            state_67 = block_97: {
                const value_4: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = block_96: {
                    break :block_96 (try function_0_value(allocator, state_67));
                };

                const value_5: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = state_67;
                const value_6: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);

                const value_9: i64 = block_95: {
                    const operand_93 = block_91: {
                        break :block_91 value_7;
                    };
                    const operand_94 = block_92: {
                        break :block_92 value_8;
                    };

                    if ((operand_94 >= (operand_93).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_95 (operand_93)[@intCast(operand_94)];
                };
                const value_10: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_90: {
                    break :block_90 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_89: {
                        break :block_89 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_6).previous, .total = (value_6).total, .values = block_88: {
                            const operand_81 = block_80: {
                                break :block_80 value_7;
                            };
                            const operand_83 = block_82: {
                                break :block_82 value_8;
                            };

                            if ((operand_83 >= (operand_81).len)) {
                                return error.IndexOutOfBounds;
                            }
                            const operand_85 = (block_84: {
                                break :block_84 value_9;
                            } + @as(i64, 1));

                            break :block_88 block_87: {
                                const operand_86 = (try (allocator).dupe(i64, operand_81));

                                (operand_86)[@intCast(operand_83)] = operand_85;
                                break :block_87 operand_86;
                            };
                        }, });
                    }, .index = (value_5).index, .limit = (value_5).limit, });
                };
                const value_11: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_10;
                const value_12: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_79: {
                    break :block_79 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_78: {
                        break :block_78 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_12).previous, .total = (block_74: {
                            break :block_74 value_13;
                        } + block_77: {
                            const operand_75 = (value_4).values;
                            const operand_76 = @as(u64, 0);

                            if ((operand_76 >= (operand_75).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_77 (operand_75)[@intCast(operand_76)];
                        }), .values = (value_12).values, });
                    }, .index = (value_11).index, .limit = (value_11).limit, });
                };

                const value_15: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_14;
                const value_16: (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (value_15).box;

                const value_17: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_73: {
                    break :block_73 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = block_72: {
                        break :block_72 @as((zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, });
                    }, .index = (value_15).index, .limit = (value_15).limit, });
                };

                const value_18: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = block_71: {
                    break :block_71 @as((zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (value_18).box, .index = (block_70: {
                        break :block_70 value_19;
                    } + @as(u64, 1)), .limit = (value_18).limit, });
                };

                break :block_97 value_20;
            };

            state_changed_69 = true;
        }

        break :block_99 (if (state_changed_69) state_67 else operand_68);
    };

    return block_66: {
        const operand_60 = ((value_1).box).total;
        const operand_61 = ((value_21).box).total;
        const operand_62 = ((value_21).box).previous;
        const operand_63 = (value_21).index;
        const operand_64 = @as(i64, 0);
        const operand_65 = ((value_21).box).values;

        break :block_66 @as((zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701, (zx_abi).value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .initial = operand_60, .total = operand_61, .previous = operand_62, .steps = operand_63, .other = operand_64, .values = operand_65, });
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_20 = block_58: {
        const operand_47 = block_53: {
            const operand_48 = (in).values;
            const operand_49 = (in).start;
            const operand_50 = (in).start;

            break :block_53 block_52: {
                const operand_51 = (try (allocator).create((zx_abi).zx_type_19));

                (operand_51).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .values = operand_48, .total = operand_49, .previous = operand_50, });

                break :block_52 @as(*const (zx_abi).zx_type_19, operand_51);
            };
        };

        const operand_54 = @as(u64, 0);
        const operand_55 = (in).count;

        break :block_58 block_57: {
            const operand_56 = (try (allocator).create((zx_abi).zx_type_20));

            (operand_56).* = @as((zx_abi).zx_type_20, (zx_abi).zx_type_20{ .box = operand_47, .index = operand_54, .limit = operand_55, });

            break :block_57 @as(*const (zx_abi).zx_type_20, operand_56);
        };
    };

    return block_46: {
        const state_type_3 = struct {
            previous: i64,
            total: i64,
            values: []const i64,
        };
        const state_type_4 = struct {
            box: state_type_3,
            index: u64,
            limit: u64,
        };
        const operand_6 = block_5: {
            const operand_2 = value_1;

            break :block_5 state_type_4{ .box = state_type_3{ .previous = ((operand_2).box).previous, .total = ((operand_2).box).total, .values = ((operand_2).box).values, }, .index = (operand_2).index, .limit = (operand_2).limit, };
        };

        var state_1: state_type_4 = operand_6;
        var state_changed_7 = false;

        while (((state_1).index < (state_1).limit)) {
            state_1 = block_36: {
                const value_4: state_type_3 = block_35: {
                    const operand_27 = state_1;
                    const operand_28 = (zx_abi).zx_type_19{ .previous = ((operand_27).box).previous, .total = ((operand_27).box).total, .values = ((operand_27).box).values, };
                    const operand_29 = (zx_abi).zx_type_20{ .box = (&operand_28), .index = (operand_27).index, .limit = (operand_27).limit, };

                    const operand_34 = block_33: {
                        const operand_30 = (&operand_29);
                        const operand_31 = (try function_0_value(allocator, (zx_abi).value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be{ .box = (zx_abi).value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .previous = ((operand_30).box).previous, .total = ((operand_30).box).total, .values = ((operand_30).box).values, .zx_origin = (operand_30).box, }, .index = (operand_30).index, .limit = (operand_30).limit, .zx_origin = operand_30, }));

                        break :block_33 (if (((operand_31).zx_origin != null)) ((operand_31).zx_origin.?).* else block_32: {
                            break :block_32 (zx_abi).zx_type_19{ .previous = (operand_31).previous, .total = (operand_31).total, .values = (operand_31).values, };
                        });
                    };

                    break :block_35 state_type_3{ .previous = (operand_34).previous, .total = (operand_34).total, .values = (operand_34).values, };
                };
                const value_5: state_type_4 = state_1;
                const value_6: state_type_3 = (value_5).box;
                const value_7: []const i64 = (value_6).values;
                const value_8: u64 = @as(u64, 0);
                const value_9: i64 = block_26: {
                    const operand_24 = value_7;
                    const operand_25 = value_8;

                    if ((operand_25 >= (operand_24).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_26 (operand_24)[@intCast(operand_25)];
                };
                const value_10: state_type_4 = block_23: {
                    break :block_23 state_type_4{ .box = block_22: {
                        break :block_22 state_type_3{ .previous = (value_6).previous, .total = (value_6).total, .values = block_21: {
                            const operand_16 = value_7;
                            const operand_17 = value_8;

                            if ((operand_17 >= (operand_16).len)) {
                                return error.IndexOutOfBounds;
                            }

                            const operand_18 = (value_9 + @as(i64, 1));

                            break :block_21 block_20: {
                                const operand_19 = (try (allocator).dupe(i64, operand_16));

                                (operand_19)[@intCast(operand_17)] = operand_18;

                                break :block_20 operand_19;
                            };
                        }, };
                    }, .index = (value_5).index, .limit = (value_5).limit, };
                };
                const value_11: state_type_4 = value_10;
                const value_12: state_type_3 = (value_11).box;
                const value_13: i64 = (value_12).total;

                const value_14: state_type_4 = block_15: {
                    break :block_15 state_type_4{ .box = block_14: {
                        break :block_14 state_type_3{ .previous = (value_12).previous, .total = (value_13 + block_13: {
                            const operand_11 = (value_4).values;
                            const operand_12 = @as(u64, 0);

                            if ((operand_12 >= (operand_11).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_13 (operand_11)[@intCast(operand_12)];
                        }), .values = (value_12).values, };
                    }, .index = (value_11).index, .limit = (value_11).limit, };
                };
                const value_15: state_type_4 = value_14;
                const value_16: state_type_3 = (value_15).box;

                const value_17: state_type_4 = block_10: {
                    break :block_10 state_type_4{ .box = block_9: {
                        break :block_9 state_type_3{ .previous = (value_4).total, .total = (value_16).total, .values = (value_16).values, };
                    }, .index = (value_15).index, .limit = (value_15).limit, };
                };
                const value_18: state_type_4 = value_17;
                const value_19: u64 = (value_18).index;

                const value_20: state_type_4 = block_8: {
                    break :block_8 state_type_4{ .box = (value_18).box, .index = (value_19 + @as(u64, 1)), .limit = (value_18).limit, };
                };

                break :block_36 value_20;
            };

            state_changed_7 = true;
        }

        break :block_46 block_45: {
            const operand_37 = ((value_1).box).total;
            const operand_38 = ((state_1).box).total;
            const operand_39 = ((state_1).box).previous;
            const operand_40 = (state_1).index;
            const operand_41 = @as(i64, 0);
            const operand_42 = ((state_1).box).values;

            break :block_45 block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_43).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .initial = operand_37, .total = operand_38, .previous = operand_39, .steps = operand_40, .other = operand_41, .values = operand_42, });

                break :block_44 @as(*const (zx_abi).zx_type_13, operand_43);
            };
        };
    };
}

