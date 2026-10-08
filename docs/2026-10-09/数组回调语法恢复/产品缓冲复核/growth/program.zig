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

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_35: {
        const operand_2 = in;
        var state_capacity_4: (std).ArrayList(i64) = .empty;
        var state_capacity_started_5 = false;

        defer (state_capacity_4).deinit(allocator);

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

        const state_type_21 = struct { []const i64, void, };
        var state_1: state_type_9 = state_type_9{ .columns = state_type_8{ .left = ((operand_2).columns).left, .right = ((operand_2).columns).right, }, .count = (operand_2).count, .delta = (operand_2).delta, .enabled = (operand_2).enabled, .left_index = (operand_2).left_index, .marker = (operand_2).marker, .right_index = (operand_2).right_index, .round = (operand_2).round, };
        var state_changed_3 = false;

        while (((state_1).round < (state_1).count)) {
            state_1 = block_28: {
                const value_12: state_type_9 = (if ((state_1).enabled) block_27: {
                    const value_3: state_type_9 = state_1;
                    const value_4: state_type_8 = (value_3).columns;

                    const value_5: state_type_9 = block_26: {
                        break :block_26 state_type_9{ .columns = block_25: {
                            break :block_25 state_type_8{ .left = (block_24: {
                                const operand_22 = ((state_1).columns).left;
                                const operand_23 = (state_1).delta;

                                _ = (try ((std).math).add(usize, (operand_22).len, 1));

                                if ((!state_capacity_started_5)) {
                                    (try (state_capacity_4).appendSlice(allocator, operand_22));
                                    state_capacity_started_5 = true;
                                } else {
                                    ((state_capacity_4).items).len = (operand_22).len;
                                }

                                (try (state_capacity_4).append(allocator, operand_23));

                                break :block_24 @as(state_type_21, .{ (state_capacity_4).items, {}, });
                            }).@"0", .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_6: state_type_9 = value_5;
                    const value_7: state_type_8 = (value_6).columns;
                    const value_8: []const i64 = (value_7).right;
                    const value_9: u64 = (value_5).right_index;

                    const value_10: i64 = block_20: {
                        const operand_18 = value_8;
                        const operand_19 = value_9;

                        if ((operand_19 >= (operand_18).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_20 (operand_18)[@intCast(operand_19)];
                    };
                    const value_11: state_type_9 = block_17: {
                        break :block_17 state_type_9{ .columns = block_16: {
                            break :block_16 state_type_8{ .left = (value_7).left, .right = block_15: {
                                const operand_11 = value_8;
                                const operand_12 = value_9;

                                if ((operand_12 >= (operand_11).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_13 = (value_10 - (value_5).delta);

                                break :block_15 block_14: {
                                    if ((!state_items_started_7)) {
                                        state_items_6 = (try (allocator).dupe(i64, operand_11));
                                        state_items_started_7 = true;
                                    }

                                    (state_items_6)[@intCast(operand_12)] = operand_13;

                                    break :block_14 state_items_6;
                                };
                            }, };
                        }, .count = (value_6).count, .delta = (value_6).delta, .enabled = (value_6).enabled, .left_index = (value_6).left_index, .marker = (value_6).marker, .right_index = (value_6).right_index, .round = (value_6).round, };
                    };

                    break :block_27 value_11;
                } else state_1);

                const value_13: state_type_9 = value_12;
                const value_14: u64 = (value_13).round;

                const value_15: state_type_9 = block_10: {
                    break :block_10 state_type_9{ .columns = (value_13).columns, .count = (value_13).count, .delta = (value_13).delta, .enabled = (value_13).enabled, .left_index = (value_13).left_index, .marker = (value_13).marker, .right_index = (value_13).right_index, .round = (value_14 + @as(u64, 1)), };
                };

                break :block_28 value_15;
            };

            state_changed_3 = true;
        }

        var state_owned_29: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_29);

        if (state_capacity_started_5) {
            ((state_capacity_4).items).len = (((state_1).columns).left).len;
            state_owned_29 = (try (state_capacity_4).toOwnedSlice(allocator));
        }

        if (state_capacity_started_5) {
            ((state_1).columns).left = state_owned_29;
        }

        break :block_35 (if (state_changed_3) block_34: {
            const operand_33 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_33).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_31).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_1).columns).left, .right = ((state_1).columns).right, });

                break :block_32 @as(*const (zx_abi).zx_type_13, operand_31);
            }, .count = (state_1).count, .delta = (state_1).delta, .enabled = (state_1).enabled, .left_index = (state_1).left_index, .marker = (state_1).marker, .right_index = (state_1).right_index, .round = (state_1).round, });

            break :block_34 @as(*const (zx_abi).zx_type_14, operand_33);
        } else operand_2);
    };
}

fn function_1_value(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return (block_71: {
        const operand_38 = in;
        var state_capacity_40: (std).ArrayList(i64) = .empty;
        var state_capacity_started_41 = false;

        defer (state_capacity_40).deinit(allocator);

        var state_items_42: []i64 = undefined;
        var state_items_started_43 = false;

        const state_type_44 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_45 = struct {
            columns: state_type_44,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        const state_type_57 = struct { []const i64, void, };
        var state_37: state_type_45 = state_type_45{ .columns = state_type_44{ .left = ((operand_38).columns).left, .right = ((operand_38).columns).right, }, .count = (operand_38).count, .delta = (operand_38).delta, .enabled = (operand_38).enabled, .left_index = (operand_38).left_index, .marker = (operand_38).marker, .right_index = (operand_38).right_index, .round = (operand_38).round, };
        var state_changed_39 = false;

        while (((state_37).round < (state_37).count)) {
            state_37 = block_64: {
                const value_12: state_type_45 = (if ((state_37).enabled) block_63: {
                    const value_3: state_type_45 = state_37;
                    const value_4: state_type_44 = (value_3).columns;

                    const value_5: state_type_45 = block_62: {
                        break :block_62 state_type_45{ .columns = block_61: {
                            break :block_61 state_type_44{ .left = (block_60: {
                                const operand_58 = ((state_37).columns).left;
                                const operand_59 = (state_37).delta;

                                _ = (try ((std).math).add(usize, (operand_58).len, 1));

                                if ((!state_capacity_started_41)) {
                                    (try (state_capacity_40).appendSlice(allocator, operand_58));
                                    state_capacity_started_41 = true;
                                } else {
                                    ((state_capacity_40).items).len = (operand_58).len;
                                }

                                (try (state_capacity_40).append(allocator, operand_59));

                                break :block_60 @as(state_type_57, .{ (state_capacity_40).items, {}, });
                            }).@"0", .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_6: state_type_45 = value_5;
                    const value_7: state_type_44 = (value_6).columns;
                    const value_8: []const i64 = (value_7).right;
                    const value_9: u64 = (value_5).right_index;
                    const value_10: i64 = block_56: {
                        const operand_54 = value_8;
                        const operand_55 = value_9;

                        if ((operand_55 >= (operand_54).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_56 (operand_54)[@intCast(operand_55)];
                    };
                    const value_11: state_type_45 = block_53: {
                        break :block_53 state_type_45{ .columns = block_52: {
                            break :block_52 state_type_44{ .left = (value_7).left, .right = block_51: {
                                const operand_47 = value_8;
                                const operand_48 = value_9;

                                if ((operand_48 >= (operand_47).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_49 = (value_10 - (value_5).delta);

                                break :block_51 block_50: {
                                    if ((!state_items_started_43)) {
                                        state_items_42 = (try (allocator).dupe(i64, operand_47));
                                        state_items_started_43 = true;
                                    }

                                    (state_items_42)[@intCast(operand_48)] = operand_49;

                                    break :block_50 state_items_42;
                                };
                            }, };
                        }, .count = (value_6).count, .delta = (value_6).delta, .enabled = (value_6).enabled, .left_index = (value_6).left_index, .marker = (value_6).marker, .right_index = (value_6).right_index, .round = (value_6).round, };
                    };

                    break :block_63 value_11;
                } else state_37);

                const value_13: state_type_45 = value_12;
                const value_14: u64 = (value_13).round;

                const value_15: state_type_45 = block_46: {
                    break :block_46 state_type_45{ .columns = (value_13).columns, .count = (value_13).count, .delta = (value_13).delta, .enabled = (value_13).enabled, .left_index = (value_13).left_index, .marker = (value_13).marker, .right_index = (value_13).right_index, .round = (value_14 + @as(u64, 1)), };
                };

                break :block_64 value_15;
            };

            state_changed_39 = true;
        }

        var state_owned_65: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_65);

        if (state_capacity_started_41) {
            ((state_capacity_40).items).len = (((state_37).columns).left).len;
            state_owned_65 = (try (state_capacity_40).toOwnedSlice(allocator));
        }

        if (state_capacity_started_41) {
            ((state_37).columns).left = state_owned_65;
        }

        break :block_71 (if (state_changed_39) block_70: {
            const operand_69 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_69).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_68: {
                const operand_67 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_67).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_37).columns).left, .right = ((state_37).columns).right, });

                break :block_68 @as(*const (zx_abi).zx_type_13, operand_67);
            }, .count = (state_37).count, .delta = (state_37).delta, .enabled = (state_37).enabled, .left_index = (state_37).left_index, .marker = (state_37).marker, .right_index = (state_37).right_index, .round = (state_37).round, });

            break :block_70 @as(*const (zx_abi).zx_type_14, operand_69);
        } else operand_38);
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
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return (block_114: {
        const operand_74 = in;
        var state_capacity_76: (std).ArrayList(i64) = .empty;
        var state_capacity_started_77 = false;

        defer (state_capacity_76).deinit(allocator);

        var state_capacity_78: (std).ArrayList(i64) = .empty;
        var state_capacity_started_79 = false;

        defer (state_capacity_78).deinit(allocator);

        const state_type_80 = struct {
            left: []const i64,
            right: []const i64,
        };

        const state_type_81 = struct {
            columns: state_type_80,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        const state_type_97 = struct { []const i64, void, };
        var state_73: state_type_81 = state_type_81{ .columns = state_type_80{ .left = ((operand_74).columns).left, .right = ((operand_74).columns).right, }, .count = (operand_74).count, .delta = (operand_74).delta, .enabled = (operand_74).enabled, .left_index = (operand_74).left_index, .marker = (operand_74).marker, .right_index = (operand_74).right_index, .round = (operand_74).round, };
        var state_changed_75 = false;

        while (((state_73).round < (state_73).count)) {
            state_73 = block_106: {
                const value_12: state_type_81 = (if ((state_73).enabled) block_105: {
                    const value_3: state_type_81 = state_73;
                    const value_4: state_type_80 = (value_3).columns;
                    const value_5: state_type_81 = block_104: {
                        break :block_104 state_type_81{ .columns = block_103: {
                            break :block_103 state_type_80{ .left = block_102: {
                                const operand_101 = @as([]const i64, (if (((buffers).lane_0 != null)) block_96: {
                                    const operand_94 = ((state_73).columns).left;
                                    const operand_95 = (state_73).delta;

                                    _ = (try ((std).math).add(usize, (operand_94).len, 1));

                                    if ((!(((buffers).lane_0.?).started).*)) {
                                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_94));
                                        (((buffers).lane_0.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_94).len;
                                    }

                                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_95));

                                    break :block_96 ((((buffers).lane_0.?).buffer).*).items;
                                } else (block_100: {
                                    const operand_98 = ((state_73).columns).left;
                                    const operand_99 = (state_73).delta;

                                    _ = (try ((std).math).add(usize, (operand_98).len, 1));

                                    if ((!state_capacity_started_77)) {
                                        (try (state_capacity_76).appendSlice(allocator, operand_98));

                                        state_capacity_started_77 = true;
                                    } else {
                                        ((state_capacity_76).items).len = (operand_98).len;
                                    }

                                    (try (state_capacity_76).append(allocator, operand_99));

                                    break :block_100 @as(state_type_97, .{ (state_capacity_76).items, {}, });
                                }).@"0"));

                                break :block_102 operand_101;
                            }, .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_6: state_type_81 = value_5;
                    const value_7: state_type_80 = (value_6).columns;
                    const value_8: []const i64 = (value_7).right;
                    const value_9: u64 = (value_5).right_index;

                    const value_10: i64 = block_93: {
                        const operand_91 = value_8;
                        const operand_92 = value_9;

                        if ((operand_92 >= (operand_91).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_93 (operand_91)[@intCast(operand_92)];
                    };
                    const value_11: state_type_81 = block_90: {
                        break :block_90 state_type_81{ .columns = block_89: {
                            break :block_89 state_type_80{ .left = (value_7).left, .right = block_88: {
                                const operand_83 = value_8;
                                const operand_84 = value_9;

                                if ((operand_84 >= (operand_83).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_85 = (value_10 - (value_5).delta);

                                break :block_88 @as([]const i64, (if (((buffers).lane_1 != null)) block_86: {
                                    if ((!(((buffers).lane_1.?).started).*)) {
                                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_83));
                                        (((buffers).lane_1.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_83).len;
                                    }

                                    (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_84)] = operand_85;

                                    break :block_86 ((((buffers).lane_1.?).buffer).*).items;
                                } else block_87: {
                                    if ((!state_capacity_started_79)) {
                                        (try (state_capacity_78).appendSlice(allocator, operand_83));

                                        state_capacity_started_79 = true;
                                    } else {
                                        ((state_capacity_78).items).len = (operand_83).len;
                                    }

                                    ((state_capacity_78).items)[@intCast(operand_84)] = operand_85;
                                    break :block_87 (state_capacity_78).items;
                                }));
                            }, };
                        }, .count = (value_6).count, .delta = (value_6).delta, .enabled = (value_6).enabled, .left_index = (value_6).left_index, .marker = (value_6).marker, .right_index = (value_6).right_index, .round = (value_6).round, };
                    };

                    break :block_105 value_11;
                } else state_73);

                const value_13: state_type_81 = value_12;
                const value_14: u64 = (value_13).round;

                const value_15: state_type_81 = block_82: {
                    break :block_82 state_type_81{ .columns = (value_13).columns, .count = (value_13).count, .delta = (value_13).delta, .enabled = (value_13).enabled, .left_index = (value_13).left_index, .marker = (value_13).marker, .right_index = (value_13).right_index, .round = (value_14 + @as(u64, 1)), };
                };

                break :block_106 value_15;
            };

            state_changed_75 = true;
        }

        var state_owned_107: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_107);

        if (state_capacity_started_77) {
            ((state_capacity_76).items).len = (((state_73).columns).left).len;
            state_owned_107 = (try (state_capacity_76).toOwnedSlice(allocator));
        }

        if (state_capacity_started_77) {
            ((state_73).columns).left = state_owned_107;
        }

        var state_owned_108: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_108);

        if (state_capacity_started_79) {
            ((state_capacity_78).items).len = (((state_73).columns).right).len;
            state_owned_108 = (try (state_capacity_78).toOwnedSlice(allocator));
        }

        if (state_capacity_started_79) {
            ((state_73).columns).right = state_owned_108;
        }

        break :block_114 (if (state_changed_75) block_113: {
            const operand_112 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_112).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_111: {
                const operand_110 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_110).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_73).columns).left, .right = ((state_73).columns).right, });

                break :block_111 @as(*const (zx_abi).zx_type_13, operand_110);
            }, .count = (state_73).count, .delta = (state_73).delta, .enabled = (state_73).enabled, .left_index = (state_73).left_index, .marker = (state_73).marker, .right_index = (state_73).right_index, .round = (state_73).round, });

            break :block_113 @as(*const (zx_abi).zx_type_14, operand_112);
        } else operand_74);
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
}) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_14 {
    @setRuntimeSafety(true);

    return block_156: {
        const operand_116 = in;
        var state_capacity_118: (std).ArrayList(i64) = .empty;
        var state_capacity_started_119 = false;

        defer (state_capacity_118).deinit(allocator);

        var state_capacity_120: (std).ArrayList(i64) = .empty;
        var state_capacity_started_121 = false;

        defer (state_capacity_120).deinit(allocator);

        const state_type_122 = struct {
            left: []const i64,
            right: []const i64,
        };
        const state_type_123 = struct {
            columns: state_type_122,
            count: u64,
            delta: i64,
            enabled: bool,
            left_index: u64,
            marker: u64,
            right_index: u64,
            round: u64,
        };

        const state_type_139 = struct { []const i64, void, };
        var state_115: state_type_123 = state_type_123{ .columns = state_type_122{ .left = ((operand_116).columns).left, .right = ((operand_116).columns).right, }, .count = (operand_116).count, .delta = (operand_116).delta, .enabled = (operand_116).enabled, .left_index = (operand_116).left_index, .marker = (operand_116).marker, .right_index = (operand_116).right_index, .round = (operand_116).round, };
        var state_changed_117 = false;

        while (((state_115).round < (state_115).count)) {
            state_115 = block_148: {
                const value_12: state_type_123 = (if ((state_115).enabled) block_147: {
                    const value_3: state_type_123 = state_115;
                    const value_4: state_type_122 = (value_3).columns;
                    const value_5: state_type_123 = block_146: {
                        break :block_146 state_type_123{ .columns = block_145: {
                            break :block_145 state_type_122{ .left = block_144: {
                                const operand_143 = @as([]const i64, (if (((buffers).lane_0 != null)) block_138: {
                                    const operand_136 = ((state_115).columns).left;
                                    const operand_137 = (state_115).delta;

                                    _ = (try ((std).math).add(usize, (operand_136).len, 1));

                                    if ((!(((buffers).lane_0.?).started).*)) {
                                        (try ((((buffers).lane_0.?).buffer).*).appendSlice(allocator, operand_136));
                                        (((buffers).lane_0.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_0.?).buffer).*).items).len = (operand_136).len;
                                    }

                                    (try ((((buffers).lane_0.?).buffer).*).append(allocator, operand_137));

                                    break :block_138 ((((buffers).lane_0.?).buffer).*).items;
                                } else (block_142: {
                                    const operand_140 = ((state_115).columns).left;
                                    const operand_141 = (state_115).delta;

                                    _ = (try ((std).math).add(usize, (operand_140).len, 1));

                                    if ((!state_capacity_started_119)) {
                                        (try (state_capacity_118).appendSlice(allocator, operand_140));
                                        state_capacity_started_119 = true;
                                    } else {
                                        ((state_capacity_118).items).len = (operand_140).len;
                                    }

                                    (try (state_capacity_118).append(allocator, operand_141));

                                    break :block_142 @as(state_type_139, .{ (state_capacity_118).items, {}, });
                                }).@"0"));

                                break :block_144 operand_143;
                            }, .right = (value_4).right, };
                        }, .count = (value_3).count, .delta = (value_3).delta, .enabled = (value_3).enabled, .left_index = (value_3).left_index, .marker = (value_3).marker, .right_index = (value_3).right_index, .round = (value_3).round, };
                    };
                    const value_6: state_type_123 = value_5;
                    const value_7: state_type_122 = (value_6).columns;
                    const value_8: []const i64 = (value_7).right;
                    const value_9: u64 = (value_5).right_index;

                    const value_10: i64 = block_135: {
                        const operand_133 = value_8;
                        const operand_134 = value_9;

                        if ((operand_134 >= (operand_133).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_135 (operand_133)[@intCast(operand_134)];
                    };
                    const value_11: state_type_123 = block_132: {
                        break :block_132 state_type_123{ .columns = block_131: {
                            break :block_131 state_type_122{ .left = (value_7).left, .right = block_130: {
                                const operand_125 = value_8;
                                const operand_126 = value_9;

                                if ((operand_126 >= (operand_125).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_127 = (value_10 - (value_5).delta);

                                break :block_130 @as([]const i64, (if (((buffers).lane_1 != null)) block_128: {
                                    if ((!(((buffers).lane_1.?).started).*)) {
                                        (try ((((buffers).lane_1.?).buffer).*).appendSlice(allocator, operand_125));
                                        (((buffers).lane_1.?).started).* = true;
                                    } else {
                                        (((((buffers).lane_1.?).buffer).*).items).len = (operand_125).len;
                                    }

                                    (((((buffers).lane_1.?).buffer).*).items)[@intCast(operand_126)] = operand_127;

                                    break :block_128 ((((buffers).lane_1.?).buffer).*).items;
                                } else block_129: {
                                    if ((!state_capacity_started_121)) {
                                        (try (state_capacity_120).appendSlice(allocator, operand_125));

                                        state_capacity_started_121 = true;
                                    } else {
                                        ((state_capacity_120).items).len = (operand_125).len;
                                    }

                                    ((state_capacity_120).items)[@intCast(operand_126)] = operand_127;

                                    break :block_129 (state_capacity_120).items;
                                }));
                            }, };
                        }, .count = (value_6).count, .delta = (value_6).delta, .enabled = (value_6).enabled, .left_index = (value_6).left_index, .marker = (value_6).marker, .right_index = (value_6).right_index, .round = (value_6).round, };
                    };

                    break :block_147 value_11;
                } else state_115);

                const value_13: state_type_123 = value_12;
                const value_14: u64 = (value_13).round;

                const value_15: state_type_123 = block_124: {
                    break :block_124 state_type_123{ .columns = (value_13).columns, .count = (value_13).count, .delta = (value_13).delta, .enabled = (value_13).enabled, .left_index = (value_13).left_index, .marker = (value_13).marker, .right_index = (value_13).right_index, .round = (value_14 + @as(u64, 1)), };
                };

                break :block_148 value_15;
            };

            state_changed_117 = true;
        }

        var state_owned_149: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_149);

        if (state_capacity_started_119) {
            ((state_capacity_118).items).len = (((state_115).columns).left).len;
            state_owned_149 = (try (state_capacity_118).toOwnedSlice(allocator));
        }

        if (state_capacity_started_119) {
            ((state_115).columns).left = state_owned_149;
        }

        var state_owned_150: []const i64 = (&[_]i64{});

        errdefer (allocator).free(state_owned_150);

        if (state_capacity_started_121) {
            ((state_capacity_120).items).len = (((state_115).columns).right).len;
            state_owned_150 = (try (state_capacity_120).toOwnedSlice(allocator));
        }

        if (state_capacity_started_121) {
            ((state_115).columns).right = state_owned_150;
        }

        break :block_156 (if (state_changed_117) block_155: {
            const operand_154 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_154).* = @as((zx_abi).zx_type_14, (zx_abi).zx_type_14{ .columns = block_153: {
                const operand_152 = (try (allocator).create((zx_abi).zx_type_13));

                (operand_152).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = ((state_115).columns).left, .right = ((state_115).columns).right, });

                break :block_153 @as(*const (zx_abi).zx_type_13, operand_152);
            }, .count = (state_115).count, .delta = (state_115).delta, .enabled = (state_115).enabled, .left_index = (state_115).left_index, .marker = (state_115).marker, .right_index = (state_115).right_index, .round = (state_115).round, });

            break :block_155 @as(*const (zx_abi).zx_type_14, operand_154);
        } else operand_116);
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

        const operand_14 = (value_2).marker;
        const operand_15 = (value_2).round;

        break :block_18 block_17: {
            const operand_16 = (try (allocator).create((zx_abi).zx_type_19));

            (operand_16).* = @as((zx_abi).zx_type_19, (zx_abi).zx_type_19{ .columns = operand_1, .before = operand_2, .original = operand_8, .marker = operand_14, .rounds = operand_15, });

            break :block_17 @as(*const (zx_abi).zx_type_19, operand_16);
        };
    };
}

