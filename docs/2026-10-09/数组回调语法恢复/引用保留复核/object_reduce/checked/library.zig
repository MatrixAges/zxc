const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Child = *const (zx_abi).zx_type_11;
pub const State = *const (zx_abi).zx_type_13;
pub const Input = *const (zx_abi).zx_type_15;
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
const zx_shape_11 = .{ .kind = .object, .fields = .{ .value = zx_shape_5, }, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .child = zx_shape_11, .count = zx_shape_5, .labels = zx_shape_12, .last = zx_shape_5, .text = zx_shape_10, .total = zx_shape_5, }, };
const zx_shape_14 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .seed = zx_shape_13, .steps = zx_shape_14, }, };
const zx_shape_16 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .result = zx_shape_13, .source = zx_shape_14, }, };
pub const input_shape = zx_shape_15;
pub const output_shape = zx_shape_13;

fn function_0(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    return block_38: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_37: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_8).result).child).value, .zx_origin = ((operand_8).result).child, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_29: {
                    const value_6: u64 = block_28: {
                        const operand_26 = (state_1).source;
                        const operand_27 = (state_1).index;

                        if ((operand_27 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_28 (operand_26)[@intCast(operand_27)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_25: {
                        break :block_25 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_24: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = ((((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        }) + @as(u64, (block_19: {
                            const operand_17 = (value_1).labels;
                            const operand_18 = @as(u64, 0);

                            if ((operand_18 >= (operand_17).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_19 (operand_17)[@intCast(operand_18)];
                        }).len));

                        const operand_20 = (value_1).count;
                        const operand_21 = (value_1).labels;
                        const operand_22 = (value_1).text;
                        const operand_23 = (value_1).child;

                        break :block_24 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_20, .labels = operand_21, .text = operand_22, .child = operand_23, });
                    };

                    break :block_29 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_37 (if (state_changed_9) block_36: {
                break :block_36 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_35: {
                    const operand_34 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_34).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_33: {
                        const operand_32 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_32).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_31: {
                            const operand_30 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_30).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_31 @as(*const (zx_abi).zx_type_11, operand_30);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_33 @as(*const (zx_abi).zx_type_13, operand_32);
                    }), .source = (state_1).source, };

                    break :block_35 @as(*const (zx_abi).zx_type_16, operand_34);
                });
            } else operand_8);
        };

        break :block_38 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_69: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_68: {
            const operand_45 = block_44: {
                const operand_40 = block_41: {
                    break :block_41 value_3;
                };

                const operand_42 = @as(u64, 0);
                const operand_43 = (in).seed;

                break :block_44 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_42, .result = operand_43, .source = operand_40, });
            };

            var state_39: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_45;
            var state_changed_46 = false;

            while (((state_39).index < @as(u64, ((state_39).source).len))) {
                state_39 = block_66: {
                    const value_6: u64 = block_65: {
                        const operand_63 = (state_39).source;
                        const operand_64 = (state_39).index;

                        if ((operand_64 >= (operand_63).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_65 (operand_63)[@intCast(operand_64)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_39).result;

                    const value_2: u64 = block_62: {
                        break :block_62 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_61: {
                        const operand_51 = ((value_1).count + @as(u64, 1));

                        const operand_52 = ((((value_1).total + (value_1).count) + block_53: {
                            break :block_53 value_2;
                        }) + @as(u64, (block_56: {
                            const operand_54 = (value_1).labels;
                            const operand_55 = @as(u64, 0);

                            if ((operand_55 >= (operand_54).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_56 (operand_54)[@intCast(operand_55)];
                        }).len));

                        const operand_57 = (value_1).count;
                        const operand_58 = (value_1).labels;
                        const operand_59 = (value_1).text;
                        const operand_60 = (value_1).child;

                        break :block_61 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_51, .total = operand_52, .last = operand_57, .labels = operand_58, .text = operand_59, .child = operand_60, });
                    };

                    break :block_66 block_50: {
                        const operand_47 = (state_39).source;
                        const operand_48 = ((state_39).index + @as(u64, 1));
                        const operand_49 = value_7;

                        break :block_50 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_48, .result = operand_49, .source = operand_47, });
                    };
                };

                state_changed_46 = true;
            }

            break :block_68 (if (state_changed_46) state_39 else operand_45);
        };

        break :block_69 (value_8).result;
    };
}

fn function_0_buffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;
    _ = buffers;

    return block_100: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_99: {
            const operand_76 = block_75: {
                const operand_71 = block_72: {
                    break :block_72 value_3;
                };

                const operand_73 = @as(u64, 0);
                const operand_74 = (in).seed;

                break :block_75 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_73, .result = operand_74, .source = operand_71, });
            };

            var state_70: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_76;
            var state_changed_77 = false;

            while (((state_70).index < @as(u64, ((state_70).source).len))) {
                state_70 = block_97: {
                    const value_6: u64 = block_96: {
                        const operand_94 = (state_70).source;
                        const operand_95 = (state_70).index;

                        if ((operand_95 >= (operand_94).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_96 (operand_94)[@intCast(operand_95)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_70).result;

                    const value_2: u64 = block_93: {
                        break :block_93 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_92: {
                        const operand_82 = ((value_1).count + @as(u64, 1));

                        const operand_83 = ((((value_1).total + (value_1).count) + block_84: {
                            break :block_84 value_2;
                        }) + @as(u64, (block_87: {
                            const operand_85 = (value_1).labels;
                            const operand_86 = @as(u64, 0);

                            if ((operand_86 >= (operand_85).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_87 (operand_85)[@intCast(operand_86)];
                        }).len));

                        const operand_88 = (value_1).count;
                        const operand_89 = (value_1).labels;
                        const operand_90 = (value_1).text;
                        const operand_91 = (value_1).child;

                        break :block_92 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_82, .total = operand_83, .last = operand_88, .labels = operand_89, .text = operand_90, .child = operand_91, });
                    };

                    break :block_97 block_81: {
                        const operand_78 = (state_70).source;
                        const operand_79 = ((state_70).index + @as(u64, 1));
                        const operand_80 = value_7;

                        break :block_81 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_79, .result = operand_80, .source = operand_78, });
                    };
                };

                state_changed_77 = true;
            }

            break :block_99 (if (state_changed_77) state_70 else operand_76);
        };

        break :block_100 (value_8).result;
    };
}

fn function_0_buffered_pointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_15, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList([]const u8),
        started: *bool,
    },
}) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    _ = buffers;

    return block_138: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_137: {
            const operand_108 = block_107: {
                const operand_102 = value_3;
                const operand_103 = @as(u64, 0);
                const operand_104 = (in).seed;

                break :block_107 block_106: {
                    const operand_105 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_105).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_103, .result = operand_104, .source = operand_102, });

                    break :block_106 @as(*const (zx_abi).zx_type_16, operand_105);
                };
            };

            var state_101: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_108).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_108).result).child).value, .zx_origin = ((operand_108).result).child, }, .count = ((operand_108).result).count, .labels = ((operand_108).result).labels, .last = ((operand_108).result).last, .text = ((operand_108).result).text, .total = ((operand_108).result).total, .zx_origin = (operand_108).result, }, .source = (operand_108).source, .zx_origin = operand_108, };
            var state_changed_109 = false;

            while (((state_101).index < @as(u64, ((state_101).source).len))) {
                state_101 = block_129: {
                    const value_6: u64 = block_128: {
                        const operand_126 = (state_101).source;
                        const operand_127 = (state_101).index;

                        if ((operand_127 >= (operand_126).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_128 (operand_126)[@intCast(operand_127)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_101).result;

                    const value_2: u64 = block_125: {
                        break :block_125 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_124: {
                        const operand_114 = ((value_1).count + @as(u64, 1));

                        const operand_115 = ((((value_1).total + (value_1).count) + block_116: {
                            break :block_116 value_2;
                        }) + @as(u64, (block_119: {
                            const operand_117 = (value_1).labels;
                            const operand_118 = @as(u64, 0);

                            if ((operand_118 >= (operand_117).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_119 (operand_117)[@intCast(operand_118)];
                        }).len));

                        const operand_120 = (value_1).count;
                        const operand_121 = (value_1).labels;
                        const operand_122 = (value_1).text;
                        const operand_123 = (value_1).child;

                        break :block_124 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_114, .total = operand_115, .last = operand_120, .labels = operand_121, .text = operand_122, .child = operand_123, });
                    };

                    break :block_129 block_113: {
                        const operand_110 = (state_101).source;
                        const operand_111 = ((state_101).index + @as(u64, 1));
                        const operand_112 = value_7;

                        break :block_113 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_111, .result = operand_112, .source = operand_110, });
                    };
                };

                state_changed_109 = true;
            }

            break :block_137 (if (state_changed_109) block_136: {
                break :block_136 (if (((state_101).zx_origin != null)) (state_101).zx_origin.? else block_135: {
                    const operand_134 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_134).* = (zx_abi).zx_type_16{ .index = (state_101).index, .result = (if ((((state_101).result).zx_origin != null)) ((state_101).result).zx_origin.? else block_133: {
                        const operand_132 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_132).* = (zx_abi).zx_type_13{ .child = (if (((((state_101).result).child).zx_origin != null)) (((state_101).result).child).zx_origin.? else block_131: {
                            const operand_130 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_130).* = (zx_abi).zx_type_11{ .value = (((state_101).result).child).value, };

                            break :block_131 @as(*const (zx_abi).zx_type_11, operand_130);
                        }), .count = ((state_101).result).count, .labels = ((state_101).result).labels, .last = ((state_101).result).last, .text = ((state_101).result).text, .total = ((state_101).result).total, };

                        break :block_133 @as(*const (zx_abi).zx_type_13, operand_132);
                    }), .source = (state_101).source, };

                    break :block_135 @as(*const (zx_abi).zx_type_16, operand_134);
                });
            } else operand_108);
        };

        break :block_138 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_38: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_37: {
            const operand_8 = block_7: {
                const operand_2 = value_3;
                const operand_3 = @as(u64, 0);
                const operand_4 = (in).seed;

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_5).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_3, .result = operand_4, .source = operand_2, });

                    break :block_6 @as(*const (zx_abi).zx_type_16, operand_5);
                };
            };

            var state_1: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_8).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_8).result).child).value, .zx_origin = ((operand_8).result).child, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, .zx_origin = (operand_8).result, }, .source = (operand_8).source, .zx_origin = operand_8, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_29: {
                    const value_6: u64 = block_28: {
                        const operand_26 = (state_1).source;
                        const operand_27 = (state_1).index;

                        if ((operand_27 >= (operand_26).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_28 (operand_26)[@intCast(operand_27)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_25: {
                        break :block_25 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_24: {
                        const operand_14 = ((value_1).count + @as(u64, 1));

                        const operand_15 = ((((value_1).total + (value_1).count) + block_16: {
                            break :block_16 value_2;
                        }) + @as(u64, (block_19: {
                            const operand_17 = (value_1).labels;
                            const operand_18 = @as(u64, 0);

                            if ((operand_18 >= (operand_17).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_19 (operand_17)[@intCast(operand_18)];
                        }).len));

                        const operand_20 = (value_1).count;
                        const operand_21 = (value_1).labels;
                        const operand_22 = (value_1).text;
                        const operand_23 = (value_1).child;

                        break :block_24 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_14, .total = operand_15, .last = operand_20, .labels = operand_21, .text = operand_22, .child = operand_23, });
                    };

                    break :block_29 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_37 (if (state_changed_9) block_36: {
                break :block_36 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_35: {
                    const operand_34 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_34).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_33: {
                        const operand_32 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_32).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_31: {
                            const operand_30 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_30).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_31 @as(*const (zx_abi).zx_type_11, operand_30);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_33 @as(*const (zx_abi).zx_type_13, operand_32);
                    }), .source = (state_1).source, };

                    break :block_35 @as(*const (zx_abi).zx_type_16, operand_34);
                });
            } else operand_8);
        };

        break :block_38 (value_8).result;
    };
}

