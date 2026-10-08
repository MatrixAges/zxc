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
const zx_shape_21 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_14, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_14, .@"2" = zx_shape_14, }, };
pub const input_shape = zx_shape_12;
pub const output_shape = zx_shape_19;
pub const Input = *const (zx_abi).zx_type_12;
pub const Output = *const (zx_abi).zx_type_19;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_68: {
        const value_2: []const i64 = (in).left;

        break :block_68 block_67: {
            const operand_49 = block_48: {
                const operand_44 = value_2;
                const operand_45 = @as(u64, 0);

                const operand_46 = block_47: {
                    break :block_47 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_48 (zx_abi).zx_type_17{ .index = operand_45, .result = operand_46, .source = operand_44, };
            };

            var state_capacity_50: (std).ArrayList(i64) = .empty;
            var state_capacity_started_51 = false;

            defer (state_capacity_50).deinit(allocator);

            var state_43: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_49).index, .result = (operand_49).result, .source = (operand_49).source, .zx_origin = (&operand_49), };

            while (((state_43).index < @as(u64, ((state_43).source).len))) {
                state_43 = block_65: {
                    const value_5: i64 = block_64: {
                        const operand_62 = (state_43).source;
                        const operand_63 = (state_43).index;

                        if ((operand_63 >= (operand_62).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_64 (operand_62)[@intCast(operand_63)];
                    };
                    const value_1: i64 = block_61: {
                        break :block_61 value_5;
                    };
                    const value_6: i64 = block_60: {
                        break :block_60 value_1;
                    };

                    break :block_65 block_59: {
                        const operand_52 = (state_43).source;
                        const operand_53 = ((state_43).index + @as(u64, 1));

                        const operand_54 = (block_58: {
                            const operand_55 = (state_43).result;

                            const operand_57 = block_56: {
                                break :block_56 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_55).len, 1));

                            if ((!state_capacity_started_51)) {
                                (try (state_capacity_50).ensureTotalCapacityPrecise(allocator, ((operand_49).source).len));
                                (try (state_capacity_50).appendSlice(allocator, operand_55));
                                state_capacity_started_51 = true;
                            } else {
                                ((state_capacity_50).items).len = (operand_55).len;
                            }

                            (try (state_capacity_50).append(allocator, operand_57));

                            break :block_58 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_50).items, {}, null, });
                        }).@"0";

                        break :block_59 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_53, .result = operand_54, .source = operand_52, });
                    };
                };
            }

            var state_owned_66: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_66);

            if (state_capacity_started_51) {
                ((state_capacity_50).items).len = ((state_43).result).len;
                state_owned_66 = (try (state_capacity_50).toOwnedSlice(allocator));
            }

            if (state_capacity_started_51) {
                state_43 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_43).index, .result = state_owned_66, .source = (state_43).source, };
            }

            break :block_67 (state_43).result;
        };
    };

    const value_16: []const i64 = block_42: {
        const value_10: []const i64 = (in).right;

        break :block_42 block_41: {
            const operand_23 = block_22: {
                const operand_18 = value_10;
                const operand_19 = @as(u64, 0);

                const operand_20 = block_21: {
                    break :block_21 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_22 (zx_abi).zx_type_17{ .index = operand_19, .result = operand_20, .source = operand_18, };
            };

            var state_capacity_24: (std).ArrayList(i64) = .empty;
            var state_capacity_started_25 = false;

            defer (state_capacity_24).deinit(allocator);

            var state_17: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_23).index, .result = (operand_23).result, .source = (operand_23).source, .zx_origin = (&operand_23), };

            while (((state_17).index < @as(u64, ((state_17).source).len))) {
                state_17 = block_39: {
                    const value_13: i64 = block_38: {
                        const operand_36 = (state_17).source;
                        const operand_37 = (state_17).index;

                        if ((operand_37 >= (operand_36).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_38 (operand_36)[@intCast(operand_37)];
                    };
                    const value_9: i64 = block_35: {
                        break :block_35 value_13;
                    };
                    const value_14: i64 = block_34: {
                        break :block_34 value_9;
                    };

                    break :block_39 block_33: {
                        const operand_26 = (state_17).source;
                        const operand_27 = ((state_17).index + @as(u64, 1));

                        const operand_28 = (block_32: {
                            const operand_29 = (state_17).result;

                            const operand_31 = block_30: {
                                break :block_30 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_29).len, 1));

                            if ((!state_capacity_started_25)) {
                                (try (state_capacity_24).ensureTotalCapacityPrecise(allocator, ((operand_23).source).len));
                                (try (state_capacity_24).appendSlice(allocator, operand_29));

                                state_capacity_started_25 = true;
                            } else {
                                ((state_capacity_24).items).len = (operand_29).len;
                            }

                            (try (state_capacity_24).append(allocator, operand_31));

                            break :block_32 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_24).items, {}, null, });
                        }).@"0";

                        break :block_33 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_27, .result = operand_28, .source = operand_26, });
                    };
                };
            }

            var state_owned_40: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_40);

            if (state_capacity_started_25) {
                ((state_capacity_24).items).len = ((state_17).result).len;
                state_owned_40 = (try (state_capacity_24).toOwnedSlice(allocator));
            }

            if (state_capacity_started_25) {
                state_17 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_17).index, .result = state_owned_40, .source = (state_17).source, };
            }

            break :block_41 (state_17).result;
        };
    };

    return block_16: {
        const operand_1 = block_6: {
            const operand_2 = value_8;
            const operand_3 = value_16;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_4).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_2, .right = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_13, operand_4);
            };
        };

        const operand_7 = @as(u64, 0);
        const operand_8 = (in).count;
        const operand_9 = (in).delta;
        const operand_10 = (in).enabled;
        const operand_11 = (in).left_index;
        const operand_12 = (in).right_index;
        const operand_13 = (in).marker;

        break :block_16 block_15: {
            const operand_14 = (try (allocator).create((zx_abi).zx_type_14));
            (operand_14).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = operand_1, .round = operand_7, .count = operand_8, .delta = operand_9, .enabled = operand_10, .left_index = operand_11, .right_index = operand_12, .marker = operand_13, });

            break :block_15 @as(*const (zx_abi).zx_type_14, operand_14);
        };
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    const value_8: []const i64 = block_134: {
        const value_2: []const i64 = (in).left;

        break :block_134 block_133: {
            const operand_115 = block_114: {
                const operand_110 = value_2;
                const operand_111 = @as(u64, 0);

                const operand_112 = block_113: {
                    break :block_113 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_114 (zx_abi).zx_type_17{ .index = operand_111, .result = operand_112, .source = operand_110, };
            };

            var state_capacity_116: (std).ArrayList(i64) = .empty;
            var state_capacity_started_117 = false;

            defer (state_capacity_116).deinit(allocator);

            var state_109: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_115).index, .result = (operand_115).result, .source = (operand_115).source, .zx_origin = (&operand_115), };

            while (((state_109).index < @as(u64, ((state_109).source).len))) {
                state_109 = block_131: {
                    const value_5: i64 = block_130: {
                        const operand_128 = (state_109).source;
                        const operand_129 = (state_109).index;

                        if ((operand_129 >= (operand_128).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_130 (operand_128)[@intCast(operand_129)];
                    };
                    const value_1: i64 = block_127: {
                        break :block_127 value_5;
                    };
                    const value_6: i64 = block_126: {
                        break :block_126 value_1;
                    };

                    break :block_131 block_125: {
                        const operand_118 = (state_109).source;
                        const operand_119 = ((state_109).index + @as(u64, 1));

                        const operand_120 = (block_124: {
                            const operand_121 = (state_109).result;

                            const operand_123 = block_122: {
                                break :block_122 value_6;
                            };

                            _ = (try ((std).math).add(usize, (operand_121).len, 1));

                            if ((!state_capacity_started_117)) {
                                (try (state_capacity_116).ensureTotalCapacityPrecise(allocator, ((operand_115).source).len));
                                (try (state_capacity_116).appendSlice(allocator, operand_121));

                                state_capacity_started_117 = true;
                            } else {
                                ((state_capacity_116).items).len = (operand_121).len;
                            }

                            (try (state_capacity_116).append(allocator, operand_123));

                            break :block_124 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_116).items, {}, null, });
                        }).@"0";

                        break :block_125 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_119, .result = operand_120, .source = operand_118, });
                    };
                };
            }

            var state_owned_132: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_132);

            if (state_capacity_started_117) {
                ((state_capacity_116).items).len = ((state_109).result).len;
                state_owned_132 = (try (state_capacity_116).toOwnedSlice(allocator));
            }

            if (state_capacity_started_117) {
                state_109 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_109).index, .result = state_owned_132, .source = (state_109).source, };
            }

            break :block_133 (state_109).result;
        };
    };

    const value_16: []const i64 = block_108: {
        const value_10: []const i64 = (in).right;

        break :block_108 block_107: {
            const operand_89 = block_88: {
                const operand_84 = value_10;
                const operand_85 = @as(u64, 0);

                const operand_86 = block_87: {
                    break :block_87 (try (allocator).dupe(i64, (&[_]i64{})));
                };

                break :block_88 (zx_abi).zx_type_17{ .index = operand_85, .result = operand_86, .source = operand_84, };
            };

            var state_capacity_90: (std).ArrayList(i64) = .empty;
            var state_capacity_started_91 = false;

            defer (state_capacity_90).deinit(allocator);

            var state_83: (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (operand_89).index, .result = (operand_89).result, .source = (operand_89).source, .zx_origin = (&operand_89), };

            while (((state_83).index < @as(u64, ((state_83).source).len))) {
                state_83 = block_105: {
                    const value_13: i64 = block_104: {
                        const operand_102 = (state_83).source;
                        const operand_103 = (state_83).index;

                        if ((operand_103 >= (operand_102).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_104 (operand_102)[@intCast(operand_103)];
                    };
                    const value_9: i64 = block_101: {
                        break :block_101 value_13;
                    };
                    const value_14: i64 = block_100: {
                        break :block_100 value_9;
                    };

                    break :block_105 block_99: {
                        const operand_92 = (state_83).source;
                        const operand_93 = ((state_83).index + @as(u64, 1));

                        const operand_94 = (block_98: {
                            const operand_95 = (state_83).result;

                            const operand_97 = block_96: {
                                break :block_96 value_14;
                            };

                            _ = (try ((std).math).add(usize, (operand_95).len, 1));

                            if ((!state_capacity_started_91)) {
                                (try (state_capacity_90).ensureTotalCapacityPrecise(allocator, ((operand_89).source).len));
                                (try (state_capacity_90).appendSlice(allocator, operand_95));

                                state_capacity_started_91 = true;
                            } else {
                                ((state_capacity_90).items).len = (operand_95).len;
                            }

                            (try (state_capacity_90).append(allocator, operand_97));

                            break :block_98 @as((zx_abi).value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, .{ (state_capacity_90).items, {}, null, });
                        }).@"0";

                        break :block_99 @as((zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = operand_93, .result = operand_94, .source = operand_92, });
                    };
                };
            }

            var state_owned_106: []const i64 = (&[_]i64{});

            errdefer (allocator).free(state_owned_106);

            if (state_capacity_started_91) {
                ((state_capacity_90).items).len = ((state_83).result).len;
                state_owned_106 = (try (state_capacity_90).toOwnedSlice(allocator));
            }

            if (state_capacity_started_91) {
                state_83 = (zx_abi).value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .index = (state_83).index, .result = state_owned_106, .source = (state_83).source, };
            }

            break :block_107 (state_83).result;
        };
    };

    return block_82: {
        const operand_69 = block_74: {
            const operand_70 = value_8;
            const operand_71 = value_16;

            break :block_74 block_73: {
                const operand_72 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_72).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_70, .right = operand_71, });

                break :block_73 @as(*const (zx_abi).zx_type_13, operand_72);
            };
        };

        const operand_75 = @as(u64, 0);
        const operand_76 = (in).count;
        const operand_77 = (in).delta;
        const operand_78 = (in).enabled;
        const operand_79 = (in).left_index;
        const operand_80 = (in).right_index;
        const operand_81 = (in).marker;

        break :block_82 (zx_abi).zx_type_14{ .columns = operand_69, .round = operand_75, .count = operand_76, .delta = operand_77, .enabled = operand_78, .left_index = operand_79, .right_index = operand_80, .marker = operand_81, };
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_38: {
        const operand_2 = in;
        var state_items_4: []i64 = undefined;
        var state_items_started_5 = false;
        var state_items_6: []i64 = undefined;
        var state_items_started_7 = false;

        const state_type_8 = struct {
            left: []const i64,
            right: []const i64,
        };
        const state_type_9 = struct {
            columns: state_type_8,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        var state_1: state_type_9 = state_type_9{ .columns = state_type_8{ .left = ((operand_2).columns).left, .right = ((operand_2).columns).right, }, .count = (operand_2).count, .delta = (operand_2).delta, .enabled = (operand_2).enabled, .left_index = (operand_2).left_index, .marker = (operand_2).marker, .right_index = (operand_2).right_index, .round = (operand_2).round, };
        var state_changed_3 = false;

        while (((state_1).round < (state_1).count)) {
            state_1 = block_32: {
                const value_15: state_type_9 = (if ((state_1).enabled) block_31: {
                    const value_3: state_type_9 = state_1;
                    const value_4: state_type_8 = (value_3).columns;
                    const value_5: []const i64 = (value_4).left;
                    const value_6: u64 = (state_1).left_index;

                    const value_7: i64 = block_30: {
                        const operand_28 = value_5;
                        const operand_29 = value_6;

                        if ((operand_29 >= (operand_28).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_30 (operand_28)[@intCast(operand_29)];
                    };
                    const value_8: state_type_9 = block_27: {
                        break :block_27 state_type_9{ .columns = block_26: {
                            break :block_26 state_type_8{ .left = block_25: {
                                const operand_21 = value_5;
                                const operand_22 = value_6;

                                if ((operand_22 >= (operand_21).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_23 = (value_7 + (state_1).delta);

                                break :block_25 block_24: {
                                    if ((!state_items_started_5)) {
                                        state_items_4 = (try (allocator).dupe(i64, operand_21));
                                        state_items_started_5 = true;
                                    }

                                    (state_items_4)[@intCast(operand_22)] = operand_23;

                                    break :block_24 state_items_4;
                                };
                            }, .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_9: state_type_9 = value_8;
                    const value_10: state_type_8 = (value_9).columns;
                    const value_11: []const i64 = (value_10).right;
                    const value_12: u64 = (value_8).right_index;

                    const value_13: i64 = block_20: {
                        const operand_18 = value_11;
                        const operand_19 = value_12;

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };
                    const value_14: state_type_9 = block_17: {
                        break :block_17 state_type_9{ .columns = block_16: {
                            break :block_16 state_type_8{ .left = (value_10).left, .right = block_15: {
                                const operand_11 = value_11;
                                const operand_12 = value_12;

                                if ((operand_12 >= (operand_11).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_13 = (value_13 - (value_8).delta);

                                break :block_15 block_14: {
                                    if ((!state_items_started_7)) {
                                        state_items_6 = (try (allocator).dupe(i64, operand_11));
                                        state_items_started_7 = true;
                                    }

                                    (state_items_6)[@intCast(operand_12)] = operand_13;

                                    break :block_14 state_items_6;
                                };
                            }, };
                        }, .count = (value_9).count, .delta = (value_9).delta, .enabled = (value_9).enabled, .left_index = (value_9).left_index, .marker = (value_9).marker, .right_index = (value_9).right_index, .round = (value_9).round, };
                    };

                    break :block_31 value_14;
                } else state_1);
                const value_16: state_type_9 = value_15;
                const value_17: u64 = (value_16).round;

                const value_18: state_type_9 = block_10: {
                    break :block_10 state_type_9{ .columns = (value_16).columns, .count = (value_16).count, .delta = (value_16).delta, .enabled = (value_16).enabled, .left_index = (value_16).left_index, .marker = (value_16).marker, .right_index = (value_16).right_index, .round = (value_17 + @as(u64, 1)), };
                };

                break :block_32 value_18;
            };

            state_changed_3 = true;
        }

        break :block_38 (if (state_changed_3) block_37: {
            const operand_36 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_36).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_35: {
                const operand_34 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_34).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_1).columns).left, .right = ((state_1).columns).right, });

                break :block_35 @as(*const (zx_abi).zx_type_13, operand_34);
            }, .count = (state_1).count, .delta = (state_1).delta, .enabled = (state_1).enabled, .left_index = (state_1).left_index, .marker = (state_1).marker, .right_index = (state_1).right_index, .round = (state_1).round, });

            break :block_37 @as(*const (zx_abi).zx_type_14, operand_36);
        } else operand_2);
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return (block_77: {
        const operand_41 = in;
        var state_items_43: []i64 = undefined;
        var state_items_started_44 = false;
        var state_items_45: []i64 = undefined;
        var state_items_started_46 = false;

        const state_type_47 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_48 = struct {
            columns: state_type_47,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        var state_40: state_type_48 = state_type_48{ .columns = state_type_47{ .left = ((operand_41).columns).left, .right = ((operand_41).columns).right, }, .count = (operand_41).count, .delta = (operand_41).delta, .enabled = (operand_41).enabled, .left_index = (operand_41).left_index, .marker = (operand_41).marker, .right_index = (operand_41).right_index, .round = (operand_41).round, };
        var state_changed_42 = false;

        while (((state_40).round < (state_40).count)) {
            state_40 = block_71: {
                const value_15: state_type_48 = (if ((state_40).enabled) block_70: {
                    const value_3: state_type_48 = state_40;
                    const value_4: state_type_47 = (value_3).columns;
                    const value_5: []const i64 = (value_4).left;
                    const value_6: u64 = (state_40).left_index;
                    const value_7: i64 = block_69: {
                        const operand_67 = value_5;
                        const operand_68 = value_6;

                        if ((operand_68 >= (operand_67).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_69 (operand_67)[@intCast(operand_68)];
                    };
                    const value_8: state_type_48 = block_66: {
                        break :block_66 state_type_48{ .columns = block_65: {
                            break :block_65 state_type_47{ .left = block_64: {
                                const operand_60 = value_5;
                                const operand_61 = value_6;

                                if ((operand_61 >= (operand_60).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_62 = (value_7 + (state_40).delta);

                                break :block_64 block_63: {
                                    if ((!state_items_started_44)) {
                                        state_items_43 = (try (allocator).dupe(i64, operand_60));
                                        state_items_started_44 = true;
                                    }

                                    (state_items_43)[@intCast(operand_61)] = operand_62;

                                    break :block_63 state_items_43;
                                };
                            }, .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_9: state_type_48 = value_8;
                    const value_10: state_type_47 = (value_9).columns;
                    const value_11: []const i64 = (value_10).right;
                    const value_12: u64 = (value_8).right_index;
                    const value_13: i64 = block_59: {
                        const operand_57 = value_11;
                        const operand_58 = value_12;

                        if ((operand_58 >= (operand_57).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_59 (operand_57)[@intCast(operand_58)];
                    };
                    const value_14: state_type_48 = block_56: {
                        break :block_56 state_type_48{ .columns = block_55: {
                            break :block_55 state_type_47{ .left = (value_10).left, .right = block_54: {
                                const operand_50 = value_11;
                                const operand_51 = value_12;

                                if ((operand_51 >= (operand_50).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_52 = (value_13 - (value_8).delta);

                                break :block_54 block_53: {
                                    if ((!state_items_started_46)) {
                                        state_items_45 = (try (allocator).dupe(i64, operand_50));
                                        state_items_started_46 = true;
                                    }

                                    (state_items_45)[@intCast(operand_51)] = operand_52;

                                    break :block_53 state_items_45;
                                };
                            }, };
                        }, .count = (value_9).count, .delta = (value_9).delta, .enabled = (value_9).enabled, .left_index = (value_9).left_index, .marker = (value_9).marker, .right_index = (value_9).right_index, .round = (value_9).round, };
                    };

                    break :block_70 value_14;
                } else state_40);
                const value_16: state_type_48 = value_15;
                const value_17: u64 = (value_16).round;

                const value_18: state_type_48 = block_49: {
                    break :block_49 state_type_48{ .columns = (value_16).columns, .count = (value_16).count, .delta = (value_16).delta, .enabled = (value_16).enabled, .left_index = (value_16).left_index, .marker = (value_16).marker, .right_index = (value_16).right_index, .round = (value_17 + @as(u64, 1)), };
                };

                break :block_71 value_18;
            };

            state_changed_42 = true;
        }

        break :block_77 (if (state_changed_42) block_76: {
            const operand_75 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_75).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_74: {
                const operand_73 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_73).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_40).columns).left, .right = ((state_40).columns).right, });

                break :block_74 @as(*const (zx_abi).zx_type_13, operand_73);
            }, .count = (state_40).count, .delta = (state_40).delta, .enabled = (state_40).enabled, .left_index = (state_40).left_index, .marker = (state_40).marker, .right_index = (state_40).right_index, .round = (state_40).round, });

            break :block_76 @as(*const (zx_abi).zx_type_14, operand_75);
        } else operand_41);
    }).*;
}

fn function_1_buffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return (block_120: {
        const operand_80 = in;
        var state_capacity_82: (std).ArrayList(i64) = .empty;
        var state_capacity_started_83 = false;

        defer (state_capacity_82).deinit(allocator);

        var state_capacity_84: (std).ArrayList(i64) = .empty;
        var state_capacity_started_85 = false;

        defer (state_capacity_84).deinit(allocator);

        const state_type_86 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_87 = struct {
            columns: state_type_86,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        var state_79: state_type_87 = state_type_87{ .columns = state_type_86{ .left = ((operand_80).columns).left, .right = ((operand_80).columns).right, }, .count = (operand_80).count, .delta = (operand_80).delta, .enabled = (operand_80).enabled, .left_index = (operand_80).left_index, .marker = (operand_80).marker, .right_index = (operand_80).right_index, .round = (operand_80).round, };
        var state_changed_81 = false;

        while (((state_79).round < (state_79).count)) {
            state_79 = block_112: {
                const value_15: state_type_87 = (if ((state_79).enabled) block_111: {
                    const value_3: state_type_87 = state_79;
                    const value_4: state_type_86 = (value_3).columns;
                    const value_5: []const i64 = (value_4).left;
                    const value_6: u64 = (state_79).left_index;
                    const value_7: i64 = block_110: {
                        const operand_108 = value_5;
                        const operand_109 = value_6;

                        if ((operand_109 >= (operand_108).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_110 (operand_108)[@intCast(operand_109)];
                    };
                    const value_8: state_type_87 = block_107: {
                        break :block_107 state_type_87{ .columns = block_106: {
                            break :block_106 state_type_86{ .left = block_105: {
                                const operand_100 = value_5;
                                const operand_101 = value_6;

                                if ((operand_101 >= (operand_100).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_102 = (value_7 + (state_79).delta);

                                break :block_105 @as([]const i64, (if (((buffers).lane_0 != null)) block_103: {
                                    if ((!(((buffers).lane_0.?).started).*)) {
                                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_100));
                                        (((buffers).lane_0.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_100).len;
                                    }

                                    (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_101)] = operand_102;

                                    break :block_103 ((((buffers).lane_0.?).buffer).*).items;
                                } else block_104: {
                                    if ((!state_capacity_started_83)) {
                                        (try (state_capacity_82).appendSlice(allocator, operand_100));

                                        state_capacity_started_83 = true;
                                    } else {
                                        ((state_capacity_82).items).len = (operand_100).len;
                                    }

                                    ((state_capacity_82).items)[@intCast(operand_101)] = operand_102;

                                    break :block_104 (state_capacity_82).items;
                                }));
                            }, .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_9: state_type_87 = value_8;
                    const value_10: state_type_86 = (value_9).columns;
                    const value_11: []const i64 = (value_10).right;
                    const value_12: u64 = (value_8).right_index;

                    const value_13: i64 = block_99: {
                        const operand_97 = value_11;
                        const operand_98 = value_12;

                        if ((operand_98 >= (operand_97).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_99 (operand_97)[@intCast(operand_98)];
                    };
                    const value_14: state_type_87 = block_96: {
                        break :block_96 state_type_87{ .columns = block_95: {
                            break :block_95 state_type_86{ .left = (value_10).left, .right = block_94: {
                                const operand_89 = value_11;
                                const operand_90 = value_12;

                                if ((operand_90 >= (operand_89).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_91 = (value_13 - (value_8).delta);

                                break :block_94 @as([]const i64, (if (((buffers).lane_1 != null)) block_92: {
                                    if ((!(((buffers).lane_1.?).started).*)) {
                                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_89));
                                        (((buffers).lane_1.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_89).len;
                                    }

                                    (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_90)] = operand_91;

                                    break :block_92 ((((buffers).lane_1.?).buffer).*).items;
                                } else block_93: {
                                    if ((!state_capacity_started_85)) {
                                        (try (state_capacity_84).appendSlice(allocator, operand_89));

                                        state_capacity_started_85 = true;
                                    } else {
                                        ((state_capacity_84).items).len = (operand_89).len;
                                    }

                                    ((state_capacity_84).items)[@intCast(operand_90)] = operand_91;

                                    break :block_93 (state_capacity_84).items;
                                }));
                            }, };
                        }, .count = (value_9).count, .delta = (value_9).delta, .enabled = (value_9).enabled, .left_index = (value_9).left_index, .marker = (value_9).marker, .right_index = (value_9).right_index, .round = (value_9).round, };
                    };

                    break :block_111 value_14;
                } else state_79);
                const value_16: state_type_87 = value_15;
                const value_17: u64 = (value_16).round;

                const value_18: state_type_87 = block_88: {
                    break :block_88 state_type_87{ .columns = (value_16).columns, .count = (value_16).count, .delta = (value_16).delta, .enabled = (value_16).enabled, .left_index = (value_16).left_index, .marker = (value_16).marker, .right_index = (value_16).right_index, .round = (value_17 + @as(u64, 1)), };
                };

                break :block_112 value_18;
            };

            state_changed_81 = true;
        }

        var state_owned_113: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_113);

        if (state_capacity_started_83) {
            ((state_capacity_82).items).len = (((state_79).columns).left).len;
            state_owned_113 = (try (state_capacity_82).toOwnedSlice(allocator));
        }

        if (state_capacity_started_83) {
            ((state_79).columns).left = state_owned_113;
        }

        var state_owned_114: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_114);

        if (state_capacity_started_85) {
            ((state_capacity_84).items).len = (((state_79).columns).right).len;
            state_owned_114 = (try (state_capacity_84).toOwnedSlice(allocator));
        }

        if (state_capacity_started_85) {
            ((state_79).columns).right = state_owned_114;
        }

        break :block_120 (if (state_changed_81) block_119: {
            const operand_118 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_118).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_117: {
                const operand_116 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_116).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_79).columns).left, .right = ((state_79).columns).right, });

                break :block_117 @as(*const (zx_abi).zx_type_13, operand_116);
            }, .count = (state_79).count, .delta = (state_79).delta, .enabled = (state_79).enabled, .left_index = (state_79).left_index, .marker = (state_79).marker, .right_index = (state_79).right_index, .round = (state_79).round, });

            break :block_119 @as(*const (zx_abi).zx_type_14, operand_118);
        } else operand_80);
    }).*;
}

fn function_1_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(i64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_162: {
        const operand_122 = in;
        var state_capacity_124: (std).ArrayList(i64) = .empty;
        var state_capacity_started_125 = false;

        defer (state_capacity_124).deinit(allocator);

        var state_capacity_126: (std).ArrayList(i64) = .empty;
        var state_capacity_started_127 = false;

        defer (state_capacity_126).deinit(allocator);

        const state_type_128 = struct {
            left: []const i64,
            right: []const i64,
        };
        const state_type_129 = struct {
            columns: state_type_128,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        var state_121: state_type_129 = state_type_129{ .columns = state_type_128{ .left = ((operand_122).columns).left, .right = ((operand_122).columns).right, }, .count = (operand_122).count, .delta = (operand_122).delta, .enabled = (operand_122).enabled, .left_index = (operand_122).left_index, .marker = (operand_122).marker, .right_index = (operand_122).right_index, .round = (operand_122).round, };
        var state_changed_123 = false;

        while (((state_121).round < (state_121).count)) {
            state_121 = block_154: {
                const value_15: state_type_129 = (if ((state_121).enabled) block_153: {
                    const value_3: state_type_129 = state_121;
                    const value_4: state_type_128 = (value_3).columns;
                    const value_5: []const i64 = (value_4).left;
                    const value_6: u64 = (state_121).left_index;
                    const value_7: i64 = block_152: {
                        const operand_150 = value_5;
                        const operand_151 = value_6;

                        if ((operand_151 >= (operand_150).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_152 (operand_150)[@intCast(operand_151)];
                    };
                    const value_8: state_type_129 = block_149: {
                        break :block_149 state_type_129{ .columns = block_148: {
                            break :block_148 state_type_128{ .left = block_147: {
                                const operand_142 = value_5;
                                const operand_143 = value_6;

                                if ((operand_143 >= (operand_142).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_144 = (value_7 + (state_121).delta);

                                break :block_147 @as([]const i64, (if (((buffers).lane_0 != null)) block_145: {
                                    if ((!(((buffers).lane_0.?).started).*)) {
                                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_142));
                                        (((buffers).lane_0.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_142).len;
                                    }

                                    (((((buffers).lane_0.?).buffer).*).items)[@intCast(operand_143)] = operand_144;

                                    break :block_145 ((((buffers).lane_0.?).buffer).*).items;
                                } else block_146: {
                                    if ((!state_capacity_started_125)) {
                                        (try (state_capacity_124).appendSlice(allocator, operand_142));

                                        state_capacity_started_125 = true;
                                    } else {
                                        ((state_capacity_124).items).len = (operand_142).len;
                                    }

                                    ((state_capacity_124).items)[@intCast(operand_143)] = operand_144;

                                    break :block_146 (state_capacity_124).items;
                                }));
                            }, .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_9: state_type_129 = value_8;
                    const value_10: state_type_128 = (value_9).columns;
                    const value_11: []const i64 = (value_10).right;
                    const value_12: u64 = (value_8).right_index;

                    const value_13: i64 = block_141: {
                        const operand_139 = value_11;
                        const operand_140 = value_12;

                        if ((operand_140 >= (operand_139).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_141 (operand_139)[@intCast(operand_140)];
                    };
                    const value_14: state_type_129 = block_138: {
                        break :block_138 state_type_129{ .columns = block_137: {
                            break :block_137 state_type_128{ .left = (value_10).left, .right = block_136: {
                                const operand_131 = value_11;
                                const operand_132 = value_12;

                                if ((operand_132 >= (operand_131).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_133 = (value_13 - (value_8).delta);

                                break :block_136 @as([]const i64, (if (((buffers).lane_1 != null)) block_134: {
                                    if ((!(((buffers).lane_1.?).started).*)) {
                                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_131));
                                        (((buffers).lane_1.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_131).len;
                                    }

                                    (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_132)] = operand_133;

                                    break :block_134 ((((buffers).lane_1.?).buffer).*).items;
                                } else block_135: {
                                    if ((!state_capacity_started_127)) {
                                        (try (state_capacity_126).appendSlice(allocator, operand_131));

                                        state_capacity_started_127 = true;
                                    } else {
                                        ((state_capacity_126).items).len = (operand_131).len;
                                    }

                                    ((state_capacity_126).items)[@intCast(operand_132)] = operand_133;

                                    break :block_135 (state_capacity_126).items;
                                }));
                            }, };
                        }, .count = (value_9).count, .delta = (value_9).delta, .enabled = (value_9).enabled, .left_index = (value_9).left_index, .marker = (value_9).marker, .right_index = (value_9).right_index, .round = (value_9).round, };
                    };

                    break :block_153 value_14;
                } else state_121);
                const value_16: state_type_129 = value_15;
                const value_17: u64 = (value_16).round;

                const value_18: state_type_129 = block_130: {
                    break :block_130 state_type_129{ .columns = (value_16).columns, .count = (value_16).count, .delta = (value_16).delta, .enabled = (value_16).enabled, .left_index = (value_16).left_index, .marker = (value_16).marker, .right_index = (value_16).right_index, .round = (value_17 + @as(u64, 1)), };
                };

                break :block_154 value_18;
            };

            state_changed_123 = true;
        }

        var state_owned_155: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_155);

        if (state_capacity_started_125) {
            ((state_capacity_124).items).len = (((state_121).columns).left).len;
            state_owned_155 = (try (state_capacity_124).toOwnedSlice(allocator));
        }

        if (state_capacity_started_125) {
            ((state_121).columns).left = state_owned_155;
        }

        var state_owned_156: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_156);

        if (state_capacity_started_127) {
            ((state_capacity_126).items).len = (((state_121).columns).right).len;
            state_owned_156 = (try (state_capacity_126).toOwnedSlice(allocator));
        }

        if (state_capacity_started_127) {
            ((state_121).columns).right = state_owned_156;
        }

        break :block_162 (if (state_changed_123) block_161: {
            const operand_160 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_160).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_159: {
                const operand_158 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_158).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_121).columns).left, .right = ((state_121).columns).right, });

                break :block_159 @as(*const (zx_abi).zx_type_13, operand_158);
            }, .count = (state_121).count, .delta = (state_121).delta, .enabled = (state_121).enabled, .left_index = (state_121).left_index, .marker = (state_121).marker, .right_index = (state_121).right_index, .round = (state_121).round, });

            break :block_161 @as(*const (zx_abi).zx_type_14, operand_160);
        } else operand_122);
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_12) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_19 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: *const (zx_abi).zx_type_14 = block_27: {
        const operand_24 = (try function_0_value(allocator, in));

        break :block_27 block_26: {
            const operand_25 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_25).* = @as((zx_abi).zx_type_14, operand_24);

            break :block_26 @as(*const (zx_abi).zx_type_14, operand_25);
        };
    };

    const value_2: *const (zx_abi).zx_type_14 = block_23: {
        const operand_19 = value_1;
        const operand_20 = ((operand_19).columns).right;
        var transferred_items_21: (std).ArrayList(i64) = ((std).ArrayList(i64)).fromOwnedSlice(@constCast(operand_20));
        var transferred_started_22 = true;

        break :block_23 (try function_1_buffered_pointer(allocator, operand_19, .{ .lane_0 = null, .lane_1 = .{ .buffer = (&transferred_items_21), .started = (&transferred_started_22), }, }));
    };

    return block_18: {
        const operand_1 = (value_2).columns;

        const operand_2 = block_7: {
            const operand_3 = ((value_1).columns).left;
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

        const operand_14 = (value_2).marker;
        const operand_15 = (value_2).round;

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_16).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .columns = operand_1, .before = operand_2, .original = operand_8, .marker = operand_14, .rounds = operand_15, });

            break :block_17 @as(*const (zx_abi).zx_type_19, operand_16);
        };
    };
}

