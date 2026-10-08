const std = @import("std");
const zx_abi = @import("zxc_abi");
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
const zx_shape_12 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .delta = zx_shape_7, .enabled = zx_shape_1, .left = zx_shape_11, .left_index = zx_shape_5, .marker = zx_shape_5, .right = zx_shape_11, .right_index = zx_shape_5, }, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .left = zx_shape_11, .right = zx_shape_11, }, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .columns = zx_shape_13, .count = zx_shape_5, .delta = zx_shape_7, .enabled = zx_shape_1, .left_index = zx_shape_5, .marker = zx_shape_5, .right_index = zx_shape_5, .round = zx_shape_5, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_13, .@"1" = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .delta = zx_shape_7, .enabled = zx_shape_1, .left_index = zx_shape_5, .product = zx_shape_15, .right_index = zx_shape_5, .round = zx_shape_5, }, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_11, .source = zx_shape_11, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_11, .@"1" = zx_shape_0, }, };
const zx_shape_19 = .{ .kind = .object, .fields = .{ .before = zx_shape_13, .columns = zx_shape_13, .marker = zx_shape_5, .original = zx_shape_13, .rounds = zx_shape_5, }, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_16, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_16, .@"2" = zx_shape_16, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_19;
pub const Input = *const (zx_abi).zx_type_12;
pub const Output = *const (zx_abi).zx_type_19;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_72: {
        const value_2: []const i64 = (in).left;

        break :block_72 block_71: {
            const operand_53 = block_52: {
                const operand_48 = value_2;
                const operand_49 = @as(u64, 0);

                const operand_50 = block_51: {
                    break :block_51 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_52 (zx_abi).zx_type_17{ .index = operand_49, .result = operand_50, .source = operand_48, };
            };

            var state_capacity_54: (std).ArrayList(i64) = .empty;
            var state_capacity_started_55 = false;

            defer (state_capacity_54).deinit(allocator);

            var state_47: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_53).index, .result = (operand_53).result, .source = (operand_53).source, .zx_origin = (&operand_53), };

            while (((state_47).index < @as(u64, ((state_47).source).len))) {
                state_47 = block_69: {
                    const value_5: i64 = block_68: {
                        const operand_66 = (state_47).source;
                        const operand_67 = (state_47).index;

                        if ((operand_67 >= (operand_66).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_68 (operand_66)[@intCast(operand_67)];
                    };
                    const value_1: i64 = block_65: {
                        break :block_65 value_5;
                    };
                    const value_6: i64 = block_64: {
                        break :block_64 value_1;
                    };

                    break :block_69 block_63: {
                        const operand_56 = (state_47).source;
                        const operand_57 = ((state_47).index + @as(u64, 1));

                        const operand_58 = (block_62: {
                            const operand_59 = (state_47).result;

                            const operand_61 = block_60: {
                                break :block_60 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_59).len, 1));

                            if ((!state_capacity_started_55)) {
                                (try (state_capacity_54).ensureTotalCapacityPrecise(allocator, ((operand_53).source).len));
                                (try (state_capacity_54).appendSlice(allocator, operand_59));

                                state_capacity_started_55 = true;
                            } else {
                                ((state_capacity_54).items).len = (operand_59).len;
                            }

                            (try (state_capacity_54).append(allocator, operand_61));

                            break :block_62 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_54).items, {}, null, });
                        }).@"0";

                        break :block_63 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_57, .result = operand_58, .source = operand_56, });
                    };
                };
            }

            var state_owned_70: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_70);

            if (state_capacity_started_55) {
                ((state_capacity_54).items).len = ((state_47).result).len;
                state_owned_70 = (try (state_capacity_54).toOwnedSlice(allocator));
            }

            if (state_capacity_started_55) {
                state_47 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_47).index, .result = state_owned_70, .source = (state_47).source, };
            }

            break :block_71 (state_47).result;
        };
    };

    const value_16: []const i64 = block_46: {
        const value_10: []const i64 = (in).right;

        break :block_46 block_45: {
            const operand_27 = block_26: {
                const operand_22 = value_10;
                const operand_23 = @as(u64, 0);

                const operand_24 = block_25: {
                    break :block_25 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_26 (zx_abi).zx_type_17{ .index = operand_23, .result = operand_24, .source = operand_22, };
            };

            var state_capacity_28: (std).ArrayList(i64) = .empty;
            var state_capacity_started_29 = false;

            defer (state_capacity_28).deinit(allocator);

            var state_21: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_27).index, .result = (operand_27).result, .source = (operand_27).source, .zx_origin = (&operand_27), };

            while (((state_21).index < @as(u64, ((state_21).source).len))) {
                state_21 = block_43: {
                    const value_13: i64 = block_42: {
                        const operand_40 = (state_21).source;
                        const operand_41 = (state_21).index;

                        if ((operand_41 >= (operand_40).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_42 (operand_40)[@intCast(operand_41)];
                    };
                    const value_9: i64 = block_39: {
                        break :block_39 value_13;
                    };
                    const value_14: i64 = block_38: {
                        break :block_38 value_9;
                    };

                    break :block_43 block_37: {
                        const operand_30 = (state_21).source;
                        const operand_31 = ((state_21).index + @as(u64, 1));

                        const operand_32 = (block_36: {
                            const operand_33 = (state_21).result;

                            const operand_35 = block_34: {
                                break :block_34 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_33).len, 1));

                            if ((!state_capacity_started_29)) {
                                (try (state_capacity_28).ensureTotalCapacityPrecise(allocator, ((operand_27).source).len));
                                (try (state_capacity_28).appendSlice(allocator, operand_33));

                                state_capacity_started_29 = true;
                            } else {
                                ((state_capacity_28).items).len = (operand_33).len;
                            }

                            (try (state_capacity_28).append(allocator, operand_35));

                            break :block_36 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_28).items, {}, null, });
                        }).@"0";

                        break :block_37 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_31, .result = operand_32, .source = operand_30, });
                    };
                };
            }

            var state_owned_44: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_44);

            if (state_capacity_started_29) {
                ((state_capacity_28).items).len = ((state_21).result).len;
                state_owned_44 = (try (state_capacity_28).toOwnedSlice(allocator));
            }

            if (state_capacity_started_29) {
                state_21 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_21).index, .result = state_owned_44, .source = (state_21).source, };
            }

            break :block_45 (state_21).result;
        };
    };

    return block_20: {
        const operand_1 = block_11: {
            const operand_7 = block_6: {
                const operand_2 = value_8;
                const operand_3 = value_16;

                break :block_6 block_5: {
                    const operand_4 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_4).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_2, .right = operand_3, });

                    break :block_5 @as(*const (zx_abi).zx_type_13, operand_4);
                };
            };

            const operand_8 = (in).marker;

            break :block_11 block_10: {
                const operand_9 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_9).* = @as((zx_abi).zx_type_15, .{ operand_7, operand_8, });

                break :block_10 @as(*const (zx_abi).zx_type_15, operand_9);
            };
        };

        const operand_12 = @as(u64, 0);
        const operand_13 = (in).count;
        const operand_14 = (in).delta;
        const operand_15 = (in).enabled;
        const operand_16 = (in).left_index;
        const operand_17 = (in).right_index;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_18).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .product = operand_1, .round = operand_12, .count = operand_13, .delta = operand_14, .enabled = operand_15, .left_index = operand_16, .right_index = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_16, operand_18);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_142: {
        const value_2: []const i64 = (in).left;

        break :block_142 block_141: {
            const operand_123 = block_122: {
                const operand_118 = value_2;
                const operand_119 = @as(u64, 0);
                const operand_120 = block_121: {
                    break :block_121 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_122 (zx_abi).zx_type_17{ .index = operand_119, .result = operand_120, .source = operand_118, };
            };

            var state_capacity_124: (std).ArrayList(i64) = .empty;
            var state_capacity_started_125 = false;

            defer (state_capacity_124).deinit(allocator);

            var state_117: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_123).index, .result = (operand_123).result, .source = (operand_123).source, .zx_origin = (&operand_123), };

            while (((state_117).index < @as(u64, ((state_117).source).len))) {
                state_117 = block_139: {
                    const value_5: i64 = block_138: {
                        const operand_136 = (state_117).source;
                        const operand_137 = (state_117).index;

                        if ((operand_137 >= (operand_136).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_138 (operand_136)[@intCast(operand_137)];
                    };
                    const value_1: i64 = block_135: {
                        break :block_135 value_5;
                    };
                    const value_6: i64 = block_134: {
                        break :block_134 value_1;
                    };

                    break :block_139 block_133: {
                        const operand_126 = (state_117).source;
                        const operand_127 = ((state_117).index + @as(u64, 1));

                        const operand_128 = (block_132: {
                            const operand_129 = (state_117).result;

                            const operand_131 = block_130: {
                                break :block_130 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_129).len, 1));

                            if ((!state_capacity_started_125)) {
                                (try (state_capacity_124).ensureTotalCapacityPrecise(allocator, ((operand_123).source).len));
                                (try (state_capacity_124).appendSlice(allocator, operand_129));

                                state_capacity_started_125 = true;
                            } else {
                                ((state_capacity_124).items).len = (operand_129).len;
                            }

                            (try (state_capacity_124).append(allocator, operand_131));

                            break :block_132 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_124).items, {}, null, });
                        }).@"0";

                        break :block_133 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_127, .result = operand_128, .source = operand_126, });
                    };
                };
            }

            var state_owned_140: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_140);

            if (state_capacity_started_125) {
                ((state_capacity_124).items).len = ((state_117).result).len;
                state_owned_140 = (try (state_capacity_124).toOwnedSlice(allocator));
            }

            if (state_capacity_started_125) {
                state_117 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_117).index, .result = state_owned_140, .source = (state_117).source, };
            }

            break :block_141 (state_117).result;
        };
    };

    const value_16: []const i64 = block_116: {
        const value_10: []const i64 = (in).right;

        break :block_116 block_115: {
            const operand_97 = block_96: {
                const operand_92 = value_10;
                const operand_93 = @as(u64, 0);

                const operand_94 = block_95: {
                    break :block_95 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_96 (zx_abi).zx_type_17{ .index = operand_93, .result = operand_94, .source = operand_92, };
            };

            var state_capacity_98: (std).ArrayList(i64) = .empty;
            var state_capacity_started_99 = false;

            defer (state_capacity_98).deinit(allocator);

            var state_91: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_97).index, .result = (operand_97).result, .source = (operand_97).source, .zx_origin = (&operand_97), };

            while (((state_91).index < @as(u64, ((state_91).source).len))) {
                state_91 = block_113: {
                    const value_13: i64 = block_112: {
                        const operand_110 = (state_91).source;
                        const operand_111 = (state_91).index;

                        if ((operand_111 >= (operand_110).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_112 (operand_110)[@intCast(operand_111)];
                    };
                    const value_9: i64 = block_109: {
                        break :block_109 value_13;
                    };
                    const value_14: i64 = block_108: {
                        break :block_108 value_9;
                    };

                    break :block_113 block_107: {
                        const operand_100 = (state_91).source;
                        const operand_101 = ((state_91).index + @as(u64, 1));

                        const operand_102 = (block_106: {
                            const operand_103 = (state_91).result;

                            const operand_105 = block_104: {
                                break :block_104 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_103).len, 1));

                            if ((!state_capacity_started_99)) {
                                (try (state_capacity_98).ensureTotalCapacityPrecise(allocator, ((operand_97).source).len));
                                (try (state_capacity_98).appendSlice(allocator, operand_103));

                                state_capacity_started_99 = true;
                            } else {
                                ((state_capacity_98).items).len = (operand_103).len;
                            }

                            (try (state_capacity_98).append(allocator, operand_105));

                            break :block_106 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_98).items, {}, null, });
                        }).@"0";

                        break :block_107 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_101, .result = operand_102, .source = operand_100, });
                    };
                };
            }

            var state_owned_114: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_114);

            if (state_capacity_started_99) {
                ((state_capacity_98).items).len = ((state_91).result).len;
                state_owned_114 = (try (state_capacity_98).toOwnedSlice(allocator));
            }

            if (state_capacity_started_99) {
                state_91 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_91).index, .result = state_owned_114, .source = (state_91).source, };
            }

            break :block_115 (state_91).result;
        };
    };

    return block_90: {
        const operand_73 = block_83: {
            const operand_79 = block_78: {
                const operand_74 = value_8;
                const operand_75 = value_16;

                break :block_78 block_77: {
                    const operand_76 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_76).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_74, .right = operand_75, });

                    break :block_77 @as(*const (zx_abi).zx_type_13, operand_76);
                };
            };

            const operand_80 = (in).marker;

            break :block_83 block_82: {
                const operand_81 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_81).* = @as((zx_abi).zx_type_15, .{ operand_79, operand_80, });

                break :block_82 @as(*const (zx_abi).zx_type_15, operand_81);
            };
        };

        const operand_84 = @as(u64, 0);
        const operand_85 = (in).count;
        const operand_86 = (in).delta;
        const operand_87 = (in).enabled;
        const operand_88 = (in).left_index;
        const operand_89 = (in).right_index;

        break :block_90 (zx_abi).zx_type_16{ .product = operand_73, .round = operand_84, .count = operand_85, .delta = operand_86, .enabled = operand_87, .left_index = operand_88, .right_index = operand_89, };
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    return block_47: {
        const operand_2 = in;
        var state_items_4: []i64 = undefined;
        var state_items_started_5 = false;
        var state_items_6: []i64 = undefined;
        var state_items_started_7 = false;

        const state_type_8 = struct {
            left: []const i64,
            right: []const i64,
        };
        const state_type_9 = struct { state_type_8, u64, };

        const state_type_10 = struct {
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            product: state_type_9,
            right_index: u64,
            round: u64,
        };

        var state_1: state_type_10 = state_type_10{ .count = (operand_2).count, .delta = (operand_2).delta, .enabled = (operand_2).enabled, .left_index = (operand_2).left_index, .product = @as(state_type_9, .{ state_type_8{ .left = (((operand_2).product).@"0").left, .right = (((operand_2).product).@"0").right, }, ((operand_2).product).@"1", }), .right_index = (operand_2).right_index, .round = (operand_2).round, };
        var state_changed_3 = false;

        while (((state_1).round < (state_1).count)) {
            state_1 = block_39: {
                const value_17: state_type_10 = (if ((state_1).enabled) block_38: {
                    const value_3: state_type_10 = state_1;
                    const value_4: state_type_9 = (value_3).product;
                    const value_5: state_type_8 = (value_4).@"0";
                    const value_6: []const i64 = (value_5).left;
                    const value_7: u64 = (state_1).left_index;

                    const value_8: i64 = block_37: {
                        const operand_35 = value_6;
                        const operand_36 = value_7;

                        if ((operand_36 >= (operand_35).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_37 (operand_35)[@intCast(operand_36)];
                    };
                    const value_9: state_type_10 = block_34: {
                        break :block_34 state_type_10{ .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .product = block_33: {
                            const operand_31 = block_30: {
                                break :block_30 state_type_8{ .left = block_29: {
                                    const operand_25 = value_6;
                                    const operand_26 = value_7;

                                    if ((operand_26 >= (operand_25).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_27 = (value_8 + (state_1).delta);

                                    break :block_29 block_28: {
                                        if ((!state_items_started_5)) {
                                            state_items_4 = (try (allocator).dupe(i64, operand_25));
                                            state_items_started_5 = true;
                                        }

                                        (state_items_4)[@intCast(operand_26)] = operand_27;

                                        break :block_28 state_items_4;
                                    };
                                }, .right = (value_5).right, };
                            };

                            const operand_32 = (value_4).@"1";

                            break :block_33 @as(state_type_9, .{ operand_31, operand_32, });
                        }, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_10: state_type_10 = value_9;
                    const value_11: state_type_9 = (value_10).product;
                    const value_12: state_type_8 = (value_11).@"0";
                    const value_13: []const i64 = (value_12).right;
                    const value_14: u64 = (value_9).right_index;

                    const value_15: i64 = block_24: {
                        const operand_22 = value_13;
                        const operand_23 = value_14;

                        if ((operand_23 >= (operand_22).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_24 (operand_22)[@intCast(operand_23)];
                    };
                    const value_16: state_type_10 = block_21: {
                        break :block_21 state_type_10{ .count = (value_10).count, .delta = (value_10).delta, .enabled = (value_10).enabled, .left_index = (value_10).left_index, .product = block_20: {
                            const operand_18 = block_17: {
                                break :block_17 state_type_8{ .left = (value_12).left, .right = block_16: {
                                    const operand_12 = value_13;
                                    const operand_13 = value_14;

                                    if ((operand_13 >= (operand_12).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_14 = (value_15 - (value_9).delta);

                                    break :block_16 block_15: {
                                        if ((!state_items_started_7)) {
                                            state_items_6 = (try (allocator).dupe(i64, operand_12));
                                            state_items_started_7 = true;
                                        }

                                        (state_items_6)[@intCast(operand_13)] = operand_14;

                                        break :block_15 state_items_6;
                                    };
                                }, };
                            };

                            const operand_19 = (value_11).@"1";

                            break :block_20 @as(state_type_9, .{ operand_18, operand_19, });
                        }, .right_index = (value_10).right_index, .round = (value_10).round, };
                    };

                    break :block_38 value_16;
                } else state_1);

                const value_18: state_type_10 = value_17;
                const value_19: u64 = (value_18).round;

                const value_20: state_type_10 = block_11: {
                    break :block_11 state_type_10{ .count = (value_18).count, .delta = (value_18).delta, .enabled = (value_18).enabled, .left_index = (value_18).left_index, .product = (value_18).product, .right_index = (value_18).right_index, .round = (value_19 + @as(u64, 1)), };
                };

                break :block_39 value_20;
            };

            state_changed_3 = true;
        }

        break :block_47 (if (state_changed_3) block_46: {
            const operand_45 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_45).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .count = (state_1).count, .delta = (state_1).delta, .enabled = (state_1).enabled, .left_index = (state_1).left_index, .product = block_44: {
                const operand_43 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_43).* = @as((zx_abi).zx_type_15, @as((zx_abi).zx_type_15, .{ block_42: {
                    const operand_41 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_41).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = (((state_1).product).@"0").left, .right = (((state_1).product).@"0").right, });

                    break :block_42 @as(*const (zx_abi).zx_type_13, operand_41);
                }, ((state_1).product).@"1", }));

                break :block_44 @as(*const (zx_abi).zx_type_15, operand_43);
            }, .right_index = (state_1).right_index, .round = (state_1).round, });

            break :block_46 @as(*const (zx_abi).zx_type_16, operand_45);
        } else operand_2);
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    return (block_95: {
        const operand_50 = in;
        var state_items_52: []i64 = undefined;
        var state_items_started_53 = false;
        var state_items_54: []i64 = undefined;
        var state_items_started_55 = false;

        const state_type_56 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_57 = struct { state_type_56, u64, };

        const state_type_58 = struct {
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            product: state_type_57,
            right_index: u64,
            round: u64,
        };

        var state_49: state_type_58 = state_type_58{ .count = (operand_50).count, .delta = (operand_50).delta, .enabled = (operand_50).enabled, .left_index = (operand_50).left_index, .product = @as(state_type_57, .{ state_type_56{ .left = (((operand_50).product).@"0").left, .right = (((operand_50).product).@"0").right, }, ((operand_50).product).@"1", }), .right_index = (operand_50).right_index, .round = (operand_50).round, };
        var state_changed_51 = false;

        while (((state_49).round < (state_49).count)) {
            state_49 = block_87: {
                const value_17: state_type_58 = (if ((state_49).enabled) block_86: {
                    const value_3: state_type_58 = state_49;
                    const value_4: state_type_57 = (value_3).product;
                    const value_5: state_type_56 = (value_4).@"0";
                    const value_6: []const i64 = (value_5).left;
                    const value_7: u64 = (state_49).left_index;
                    const value_8: i64 = block_85: {
                        const operand_83 = value_6;
                        const operand_84 = value_7;

                        if ((operand_84 >= (operand_83).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_85 (operand_83)[@intCast(operand_84)];
                    };
                    const value_9: state_type_58 = block_82: {
                        break :block_82 state_type_58{ .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .product = block_81: {
                            const operand_79 = block_78: {
                                break :block_78 state_type_56{ .left = block_77: {
                                    const operand_73 = value_6;
                                    const operand_74 = value_7;

                                    if ((operand_74 >= (operand_73).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_75 = (value_8 + (state_49).delta);

                                    break :block_77 block_76: {
                                        if ((!state_items_started_53)) {
                                            state_items_52 = (try (allocator).dupe(i64, operand_73));
                                            state_items_started_53 = true;
                                        }

                                        (state_items_52)[@intCast(operand_74)] = operand_75;

                                        break :block_76 state_items_52;
                                    };
                                }, .right = (value_5).right, };
                            };

                            const operand_80 = (value_4).@"1";

                            break :block_81 @as(state_type_57, .{ operand_79, operand_80, });
                        }, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_10: state_type_58 = value_9;
                    const value_11: state_type_57 = (value_10).product;
                    const value_12: state_type_56 = (value_11).@"0";
                    const value_13: []const i64 = (value_12).right;
                    const value_14: u64 = (value_9).right_index;

                    const value_15: i64 = block_72: {
                        const operand_70 = value_13;
                        const operand_71 = value_14;

                        if ((operand_71 >= (operand_70).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_72 (operand_70)[@intCast(operand_71)];
                    };
                    const value_16: state_type_58 = block_69: {
                        break :block_69 state_type_58{ .count = (value_10).count, .delta = (value_10).delta, .enabled = (value_10).enabled, .left_index = (value_10).left_index, .product = block_68: {
                            const operand_66 = block_65: {
                                break :block_65 state_type_56{ .left = (value_12).left, .right = block_64: {
                                    const operand_60 = value_13;
                                    const operand_61 = value_14;

                                    if ((operand_61 >= (operand_60).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_62 = (value_15 - (value_9).delta);

                                    break :block_64 block_63: {
                                        if ((!state_items_started_55)) {
                                            state_items_54 = (try (allocator).dupe(i64, operand_60));
                                            state_items_started_55 = true;
                                        }

                                        (state_items_54)[@intCast(operand_61)] = operand_62;

                                        break :block_63 state_items_54;
                                    };
                                }, };
                            };

                            const operand_67 = (value_11).@"1";

                            break :block_68 @as(state_type_57, .{ operand_66, operand_67, });
                        }, .right_index = (value_10).right_index, .round = (value_10).round, };
                    };

                    break :block_86 value_16;
                } else state_49);

                const value_18: state_type_58 = value_17;
                const value_19: u64 = (value_18).round;

                const value_20: state_type_58 = block_59: {
                    break :block_59 state_type_58{ .count = (value_18).count, .delta = (value_18).delta, .enabled = (value_18).enabled, .left_index = (value_18).left_index, .product = (value_18).product, .right_index = (value_18).right_index, .round = (value_19 + @as(u64, 1)), };
                };

                break :block_87 value_20;
            };

            state_changed_51 = true;
        }

        break :block_95 (if (state_changed_51) block_94: {
            const operand_93 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_93).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .count = (state_49).count, .delta = (state_49).delta, .enabled = (state_49).enabled, .left_index = (state_49).left_index, .product = block_92: {
                const operand_91 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_91).* = @as((zx_abi).zx_type_15, @as((zx_abi).zx_type_15, .{ block_90: {
                    const operand_89 = (try (allocator).create((zx_abi).zx_type_13));
                    (operand_89).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = (((state_49).product).@"0").left, .right = (((state_49).product).@"0").right, });

                    break :block_90 @as(*const (zx_abi).zx_type_13, operand_89);
                }, ((state_49).product).@"1", }));

                break :block_92 @as(*const (zx_abi).zx_type_15, operand_91);
            }, .right_index = (state_49).right_index, .round = (state_49).round, });

            break :block_94 @as(*const (zx_abi).zx_type_16, operand_93);
        } else operand_50);
    }).*;
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    return (block_147: {
        const operand_98 = in;
        var state_capacity_100: (std).ArrayList(i64) = .empty;
        var state_capacity_started_101 = false;

        defer (state_capacity_100).deinit(allocator);

        var state_capacity_102: (std).ArrayList(i64) = .empty;
        var state_capacity_started_103 = false;

        defer (state_capacity_102).deinit(allocator);

        const state_type_104 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_105 = struct { state_type_104, u64, };

        const state_type_106 = struct {
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            product: state_type_105,
            right_index: u64,
            round: u64,
        };

        var state_97: state_type_106 = state_type_106{ .count = (operand_98).count, .delta = (operand_98).delta, .enabled = (operand_98).enabled, .left_index = (operand_98).left_index, .product = @as(state_type_105, .{ state_type_104{ .left = (((operand_98).product).@"0").left, .right = (((operand_98).product).@"0").right, }, ((operand_98).product).@"1", }), .right_index = (operand_98).right_index, .round = (operand_98).round, };
        var state_changed_99 = false;

        while (((state_97).round < (state_97).count)) {
            state_97 = block_137: {
                const value_17: state_type_106 = (if ((state_97).enabled) block_136: {
                    const value_3: state_type_106 = state_97;
                    const value_4: state_type_105 = (value_3).product;
                    const value_5: state_type_104 = (value_4).@"0";
                    const value_6: []const i64 = (value_5).left;
                    const value_7: u64 = (state_97).left_index;
                    const value_8: i64 = block_135: {
                        const operand_133 = value_6;
                        const operand_134 = value_7;

                        if ((operand_134 >= (operand_133).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_135 (operand_133)[@intCast(operand_134)];
                    };
                    const value_9: state_type_106 = block_132: {
                        break :block_132 state_type_106{ .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .product = block_131: {
                            const operand_129 = block_128: {
                                break :block_128 state_type_104{ .left = block_127: {
                                    const operand_122 = value_6;
                                    const operand_123 = value_7;

                                    if ((operand_123 >= (operand_122).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_124 = (value_8 + (state_97).delta);

                                    break :block_127 @as([]const i64, (if (((buffers).lane_0 != null)) block_125: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_122));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_122).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_123)] = operand_124;

                                        break :block_125 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_126: {
                                        if ((!state_capacity_started_101)) {
                                            (try (state_capacity_100).appendSlice(allocator, operand_122));

                                            state_capacity_started_101 = true;
                                        } else {
                                            ((state_capacity_100).items).len = (operand_122).len;
                                        }

                                        ((state_capacity_100).items)[@intCast(operand_123)] = operand_124;

                                        break :block_126 (state_capacity_100).items;
                                    }));
                                }, .right = (value_5).right, };
                            };

                            const operand_130 = (value_4).@"1";

                            break :block_131 @as(state_type_105, .{ operand_129, operand_130, });
                        }, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_10: state_type_106 = value_9;
                    const value_11: state_type_105 = (value_10).product;
                    const value_12: state_type_104 = (value_11).@"0";
                    const value_13: []const i64 = (value_12).right;
                    const value_14: u64 = (value_9).right_index;

                    const value_15: i64 = block_121: {
                        const operand_119 = value_13;
                        const operand_120 = value_14;

                        if ((operand_120 >= (operand_119).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_121 (operand_119)[@intCast(operand_120)];
                    };
                    const value_16: state_type_106 = block_118: {
                        break :block_118 state_type_106{ .count = (value_10).count, .delta = (value_10).delta, .enabled = (value_10).enabled, .left_index = (value_10).left_index, .product = block_117: {
                            const operand_115 = block_114: {
                                break :block_114 state_type_104{ .left = (value_12).left, .right = block_113: {
                                    const operand_108 = value_13;
                                    const operand_109 = value_14;

                                    if ((operand_109 >= (operand_108).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_110 = (value_15 - (value_9).delta);

                                    break :block_113 @as([]const i64, (if (((buffers).lane_1 != null)) block_111: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_108));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_108).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_109)] = operand_110;

                                        break :block_111 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_112: {
                                        if ((!state_capacity_started_103)) {
                                            (try (state_capacity_102).appendSlice(allocator, operand_108));

                                            state_capacity_started_103 = true;
                                        } else {
                                            ((state_capacity_102).items).len = (operand_108).len;
                                        }

                                        ((state_capacity_102).items)[@intCast(operand_109)] = operand_110;

                                        break :block_112 (state_capacity_102).items;
                                    }));
                                }, };
                            };

                            const operand_116 = (value_11).@"1";

                            break :block_117 @as(state_type_105, .{ operand_115, operand_116, });
                        }, .right_index = (value_10).right_index, .round = (value_10).round, };
                    };

                    break :block_136 value_16;
                } else state_97);

                const value_18: state_type_106 = value_17;
                const value_19: u64 = (value_18).round;

                const value_20: state_type_106 = block_107: {
                    break :block_107 state_type_106{ .count = (value_18).count, .delta = (value_18).delta, .enabled = (value_18).enabled, .left_index = (value_18).left_index, .product = (value_18).product, .right_index = (value_18).right_index, .round = (value_19 + @as(u64, 1)), };
                };

                break :block_137 value_20;
            };

            state_changed_99 = true;
        }

        var state_owned_138: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_138);

        if (state_capacity_started_101) {
            ((state_capacity_100).items).len = ((((state_97).product).@"0").left).len;
            state_owned_138 = (try (state_capacity_100).toOwnedSlice(allocator));
        }

        if (state_capacity_started_101) {
            (((state_97).product).@"0").left = state_owned_138;
        }

        var state_owned_139: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_139);

        if (state_capacity_started_103) {
            ((state_capacity_102).items).len = ((((state_97).product).@"0").right).len;
            state_owned_139 = (try (state_capacity_102).toOwnedSlice(allocator));
        }

        if (state_capacity_started_103) {
            (((state_97).product).@"0").right = state_owned_139;
        }

        break :block_147 (if (state_changed_99) block_146: {
            const operand_145 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_145).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .count = (state_97).count, .delta = (state_97).delta, .enabled = (state_97).enabled, .left_index = (state_97).left_index, .product = block_144: {
                const operand_143 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_143).* = @as((zx_abi).zx_type_15, @as((zx_abi).zx_type_15, .{ block_142: {
                    const operand_141 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_141).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = (((state_97).product).@"0").left, .right = (((state_97).product).@"0").right, });

                    break :block_142 @as(*const (zx_abi).zx_type_13, operand_141);
                }, ((state_97).product).@"1", }));

                break :block_144 @as(*const (zx_abi).zx_type_15, operand_143);
            }, .right_index = (state_97).right_index, .round = (state_97).round, });

            break :block_146 @as(*const (zx_abi).zx_type_16, operand_145);
        } else operand_98);
    }).*;
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_16, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_16 {
    @setRuntimeSafety(true);

    return block_198: {
        const operand_149 = in;
        var state_capacity_151: (std).ArrayList(i64) = .empty;
        var state_capacity_started_152 = false;

        defer (state_capacity_151).deinit(allocator);

        var state_capacity_153: (std).ArrayList(i64) = .empty;
        var state_capacity_started_154 = false;

        defer (state_capacity_153).deinit(allocator);

        const state_type_155 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_156 = struct { state_type_155, u64, };

        const state_type_157 = struct {
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            product: state_type_156,
            right_index: u64,
            round: u64,
        };

        var state_148: state_type_157 = state_type_157{ .count = (operand_149).count, .delta = (operand_149).delta, .enabled = (operand_149).enabled, .left_index = (operand_149).left_index, .product = @as(state_type_156, .{ state_type_155{ .left = (((operand_149).product).@"0").left, .right = (((operand_149).product).@"0").right, }, ((operand_149).product).@"1", }), .right_index = (operand_149).right_index, .round = (operand_149).round, };
        var state_changed_150 = false;

        while (((state_148).round < (state_148).count)) {
            state_148 = block_188: {
                const value_17: state_type_157 = (if ((state_148).enabled) block_187: {
                    const value_3: state_type_157 = state_148;
                    const value_4: state_type_156 = (value_3).product;
                    const value_5: state_type_155 = (value_4).@"0";
                    const value_6: []const i64 = (value_5).left;
                    const value_7: u64 = (state_148).left_index;
                    const value_8: i64 = block_186: {
                        const operand_184 = value_6;
                        const operand_185 = value_7;

                        if ((operand_185 >= (operand_184).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_186 (operand_184)[@intCast(operand_185)];
                    };
                    const value_9: state_type_157 = block_183: {
                        break :block_183 state_type_157{ .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .product = block_182: {
                            const operand_180 = block_179: {
                                break :block_179 state_type_155{ .left = block_178: {
                                    const operand_173 = value_6;
                                    const operand_174 = value_7;

                                    if ((operand_174 >= (operand_173).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_175 = (value_8 + (state_148).delta);

                                    break :block_178 @as([]const i64, (if (((buffers).lane_0 != null)) block_176: {
                                        if ((!(((buffers).lane_0.?).started).*)) {
                                            (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_173));
                                            (((buffers).lane_0.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_0.?).buffer).*).items).len = (operand_173).len;
                                        }

                                        (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_174)] = operand_175;

                                        break :block_176 ((((buffers).lane_0.?).buffer).*).items;
                                    } else block_177: {
                                        if ((!state_capacity_started_152)) {
                                            (try (state_capacity_151).appendSlice(allocator, operand_173));

                                            state_capacity_started_152 = true;
                                        } else {
                                            ((state_capacity_151).items).len = (operand_173).len;
                                        }

                                        ((state_capacity_151).items)[@intCast(operand_174)] = operand_175;

                                        break :block_177 (state_capacity_151).items;
                                    }));
                                }, .right = (value_5).right, };
                            };

                            const operand_181 = (value_4).@"1";

                            break :block_182 @as(state_type_156, .{ operand_180, operand_181, });
                        }, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_10: state_type_157 = value_9;
                    const value_11: state_type_156 = (value_10).product;
                    const value_12: state_type_155 = (value_11).@"0";
                    const value_13: []const i64 = (value_12).right;
                    const value_14: u64 = (value_9).right_index;

                    const value_15: i64 = block_172: {
                        const operand_170 = value_13;
                        const operand_171 = value_14;

                        if ((operand_171 >= (operand_170).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_172 (operand_170)[@intCast(operand_171)];
                    };
                    const value_16: state_type_157 = block_169: {
                        break :block_169 state_type_157{ .count = (value_10).count, .delta = (value_10).delta, .enabled = (value_10).enabled, .left_index = (value_10).left_index, .product = block_168: {
                            const operand_166 = block_165: {
                                break :block_165 state_type_155{ .left = (value_12).left, .right = block_164: {
                                    const operand_159 = value_13;
                                    const operand_160 = value_14;

                                    if ((operand_160 >= (operand_159).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_161 = (value_15 - (value_9).delta);

                                    break :block_164 @as([]const i64, (if (((buffers).lane_1 != null)) block_162: {
                                        if ((!(((buffers).lane_1.?).started).*)) {
                                            (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_159));
                                            (((buffers).lane_1.?).started).* = true;
                                        } else {
                                            (((((buffers).lane_1.?).buffer).*).items).len = (operand_159).len;
                                        }

                                        (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_160)] = operand_161;

                                        break :block_162 ((((buffers).lane_1.?).buffer).*).items;
                                    } else block_163: {
                                        if ((!state_capacity_started_154)) {
                                            (try (state_capacity_153).appendSlice(allocator, operand_159));

                                            state_capacity_started_154 = true;
                                        } else {
                                            ((state_capacity_153).items).len = (operand_159).len;
                                        }

                                        ((state_capacity_153).items)[@intCast(operand_160)] = operand_161;

                                        break :block_163 (state_capacity_153).items;
                                    }));
                                }, };
                            };

                            const operand_167 = (value_11).@"1";

                            break :block_168 @as(state_type_156, .{ operand_166, operand_167, });
                        }, .right_index = (value_10).right_index, .round = (value_10).round, };
                    };

                    break :block_187 value_16;
                } else state_148);

                const value_18: state_type_157 = value_17;
                const value_19: u64 = (value_18).round;

                const value_20: state_type_157 = block_158: {
                    break :block_158 state_type_157{ .count = (value_18).count, .delta = (value_18).delta, .enabled = (value_18).enabled, .left_index = (value_18).left_index, .product = (value_18).product, .right_index = (value_18).right_index, .round = (value_19 + @as(u64, 1)), };
                };

                break :block_188 value_20;
            };

            state_changed_150 = true;
        }

        var state_owned_189: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_189);

        if (state_capacity_started_152) {
            ((state_capacity_151).items).len = ((((state_148).product).@"0").left).len;
            state_owned_189 = (try (state_capacity_151).toOwnedSlice(allocator));
        }

        if (state_capacity_started_152) {
            (((state_148).product).@"0").left = state_owned_189;
        }

        var state_owned_190: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_190);

        if (state_capacity_started_154) {
            ((state_capacity_153).items).len = ((((state_148).product).@"0").right).len;
            state_owned_190 = (try (state_capacity_153).toOwnedSlice(allocator));
        }

        if (state_capacity_started_154) {
            (((state_148).product).@"0").right = state_owned_190;
        }

        break :block_198 (if (state_changed_150) block_197: {
            const operand_196 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_196).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .count = (state_148).count, .delta = (state_148).delta, .enabled = (state_148).enabled, .left_index = (state_148).left_index, .product = block_195: {
                const operand_194 = (try (allocator).create((zx_abi).zx_type_15));

                (operand_194).* = @as((zx_abi).zx_type_15, @as((zx_abi).zx_type_15, .{ block_193: {
                    const operand_192 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_192).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = (((state_148).product).@"0").left, .right = (((state_148).product).@"0").right, });

                    break :block_193 @as(*const (zx_abi).zx_type_13, operand_192);
                }, ((state_148).product).@"1", }));

                break :block_195 @as(*const (zx_abi).zx_type_15, operand_194);
            }, .right_index = (state_148).right_index, .round = (state_148).round, });

            break :block_197 @as(*const (zx_abi).zx_type_16, operand_196);
        } else operand_149);
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_16 = block_30: {
        const operand_27 = (try function_0_value(allocator, in));

        break :block_30 block_29: {
            const operand_28 = (try (allocator).create((zx_abi).zx_type_16));

            (operand_28).* = @as((zx_abi).zx_type_16, operand_27);

            break :block_29 @as(*const (zx_abi).zx_type_16, operand_28);
        };
    };

    const value_2: *const (zx_abi).zx_type_16 = block_26: {
        const operand_19 = value_1;
        const operand_20 = (((operand_19).product).@"0").left;
        var transferred_items_21: (std).ArrayList(i64) = ((std).ArrayList(i64)).fromOwnedSlice(@constCast(operand_20));
        var transferred_started_22 = true;
        const operand_23 = (((operand_19).product).@"0").right;
        var transferred_items_24: (std).ArrayList(i64) = ((std).ArrayList(i64)).fromOwnedSlice(@constCast(operand_23));
        var transferred_started_25 = true;

        break :block_26 (try function_1_buffered_pointer(allocator, operand_19, .{ .lane_0 = .{ .buffer = (&transferred_items_21), .started = (&transferred_started_22), }, .lane_1 = .{ .buffer = (&transferred_items_24), .started = (&transferred_started_25), }, }));
    };

    return block_18: {
        const operand_1 = ((value_2).product).@"0";

        const operand_2 = block_7: {
            const operand_3 = (in).left;
            const operand_4 = (in).right;

            break :block_7 block_6: {
                const operand_5 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_5).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_3, .right = operand_4, });

                break :block_6 @as(*const (zx_abi).zx_type_13, operand_5);
            };
        };
        const operand_8 = block_13: {
            const operand_9 = (in).left;
            const operand_10 = (in).right;

            break :block_13 block_12: {
                const operand_11 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_11).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_9, .right = operand_10, });

                break :block_12 @as(*const (zx_abi).zx_type_13, operand_11);
            };
        };

        const operand_14 = ((value_2).product).@"1";
        const operand_15 = (value_2).round;

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_16).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .columns = operand_1, .before = operand_2, .original = operand_8, .marker = operand_14, .rounds = operand_15, });

            break :block_17 @as(*const (zx_abi).zx_type_19, operand_16);
        };
    };
}

