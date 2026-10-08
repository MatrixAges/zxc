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

    return block_39: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_38: {
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

            const state_type_10 = struct {
                value: u64,
            };
            const state_type_11 = struct {
                child: state_type_10,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_12 = struct {
                index: u64,
                result: state_type_11,
                source: []const u64,
            };

            var state_1: state_type_12 = state_type_12{ .index = (operand_8).index, .result = state_type_11{ .child = state_type_10{ .value = (((operand_8).result).child).value, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, }, .source = (operand_8).source, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_30: {
                    const value_6: u64 = block_29: {
                        const operand_27 = (state_1).source;
                        const operand_28 = (state_1).index;

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    };

                    const value_1: state_type_11 = (state_1).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_11 = block_26: {
                        const operand_17 = ((value_1).count + @as(u64, 1));

                        const operand_21 = ((((value_1).total + (value_1).count) + value_2) + @as(u64, (block_20: {
                            const operand_18 = (value_1).labels;
                            const operand_19 = @as(u64, 0);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        }).len));

                        const operand_22 = (value_1).count;
                        const operand_23 = (value_1).labels;
                        const operand_24 = (value_1).text;
                        const operand_25 = (value_1).child;

                        break :block_26 state_type_11{ .count = operand_17, .total = operand_21, .last = operand_22, .labels = operand_23, .text = operand_24, .child = operand_25, };
                    };

                    break :block_30 block_16: {
                        const operand_13 = (state_1).source;
                        const operand_14 = ((state_1).index + @as(u64, 1));
                        const operand_15 = value_7;

                        break :block_16 state_type_12{ .index = operand_14, .result = operand_15, .source = operand_13, };
                    };
                };

                state_changed_9 = true;
            }

            break :block_38 (if (state_changed_9) block_37: {
                const operand_36 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_36).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_1).index, .result = block_35: {
                    const operand_34 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_34).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_33: {
                        const operand_32 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_32).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_33 @as(*const (zx_abi).zx_type_11, operand_32);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_35 @as(*const (zx_abi).zx_type_13, operand_34);
                }, .source = (state_1).source, });

                break :block_37 @as(*const (zx_abi).zx_type_16, operand_36);
            } else operand_8);
        };

        break :block_39 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_70: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_69: {
            const operand_46 = block_45: {
                const operand_41 = block_42: {
                    break :block_42 value_3;
                };

                const operand_43 = @as(u64, 0);
                const operand_44 = (in).seed;

                break :block_45 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_43, .result = operand_44, .source = operand_41, });
            };

            var state_40: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_46;
            var state_changed_47 = false;

            while (((state_40).index < @as(u64, ((state_40).source).len))) {
                state_40 = block_67: {
                    const value_6: u64 = block_66: {
                        const operand_64 = (state_40).source;
                        const operand_65 = (state_40).index;

                        if ((operand_65 >= (operand_64).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_66 (operand_64)[@intCast(operand_65)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_40).result;

                    const value_2: u64 = block_63: {
                        break :block_63 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_62: {
                        const operand_52 = ((value_1).count + @as(u64, 1));

                        const operand_53 = ((((value_1).total + (value_1).count) + block_54: {
                            break :block_54 value_2;
                        }) + @as(u64, (block_57: {
                            const operand_55 = (value_1).labels;
                            const operand_56 = @as(u64, 0);

                            if ((operand_56 >= (operand_55).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_57 (operand_55)[@intCast(operand_56)];
                        }).len));

                        const operand_58 = (value_1).count;
                        const operand_59 = (value_1).labels;
                        const operand_60 = (value_1).text;
                        const operand_61 = (value_1).child;

                        break :block_62 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_52, .total = operand_53, .last = operand_58, .labels = operand_59, .text = operand_60, .child = operand_61, });
                    };

                    break :block_67 block_51: {
                        const operand_48 = (state_40).source;
                        const operand_49 = ((state_40).index + @as(u64, 1));
                        const operand_50 = value_7;

                        break :block_51 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_49, .result = operand_50, .source = operand_48, });
                    };
                };

                state_changed_47 = true;
            }

            break :block_69 (if (state_changed_47) state_40 else operand_46);
        };

        break :block_70 (value_8).result;
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

    return block_101: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_100: {
            const operand_77 = block_76: {
                const operand_72 = block_73: {
                    break :block_73 value_3;
                };

                const operand_74 = @as(u64, 0);
                const operand_75 = (in).seed;

                break :block_76 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_74, .result = operand_75, .source = operand_72, });
            };

            var state_71: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_77;
            var state_changed_78 = false;

            while (((state_71).index < @as(u64, ((state_71).source).len))) {
                state_71 = block_98: {
                    const value_6: u64 = block_97: {
                        const operand_95 = (state_71).source;
                        const operand_96 = (state_71).index;

                        if ((operand_96 >= (operand_95).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_97 (operand_95)[@intCast(operand_96)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_71).result;

                    const value_2: u64 = block_94: {
                        break :block_94 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_93: {
                        const operand_83 = ((value_1).count + @as(u64, 1));

                        const operand_84 = ((((value_1).total + (value_1).count) + block_85: {
                            break :block_85 value_2;
                        }) + @as(u64, (block_88: {
                            const operand_86 = (value_1).labels;
                            const operand_87 = @as(u64, 0);

                            if ((operand_87 >= (operand_86).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_88 (operand_86)[@intCast(operand_87)];
                        }).len));

                        const operand_89 = (value_1).count;
                        const operand_90 = (value_1).labels;
                        const operand_91 = (value_1).text;
                        const operand_92 = (value_1).child;

                        break :block_93 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_83, .total = operand_84, .last = operand_89, .labels = operand_90, .text = operand_91, .child = operand_92, });
                    };

                    break :block_98 block_82: {
                        const operand_79 = (state_71).source;
                        const operand_80 = ((state_71).index + @as(u64, 1));
                        const operand_81 = value_7;

                        break :block_82 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_80, .result = operand_81, .source = operand_79, });
                    };
                };

                state_changed_78 = true;
            }

            break :block_100 (if (state_changed_78) state_71 else operand_77);
        };

        break :block_101 (value_8).result;
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

    return block_140: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_139: {
            const operand_109 = block_108: {
                const operand_103 = value_3;
                const operand_104 = @as(u64, 0);
                const operand_105 = (in).seed;

                break :block_108 block_107: {
                    const operand_106 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_106).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_104, .result = operand_105, .source = operand_103, });

                    break :block_107 @as(*const (zx_abi).zx_type_16, operand_106);
                };
            };
            const state_type_111 = struct {
                value: u64,
            };
            const state_type_112 = struct {
                child: state_type_111,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_113 = struct {
                index: u64,
                result: state_type_112,
                source: []const u64,
            };

            var state_102: state_type_113 = state_type_113{ .index = (operand_109).index, .result = state_type_112{ .child = state_type_111{ .value = (((operand_109).result).child).value, }, .count = ((operand_109).result).count, .labels = ((operand_109).result).labels, .last = ((operand_109).result).last, .text = ((operand_109).result).text, .total = ((operand_109).result).total, }, .source = (operand_109).source, };
            var state_changed_110 = false;

            while (((state_102).index < @as(u64, ((state_102).source).len))) {
                state_102 = block_131: {
                    const value_6: u64 = block_130: {
                        const operand_128 = (state_102).source;
                        const operand_129 = (state_102).index;

                        if ((operand_129 >= (operand_128).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_130 (operand_128)[@intCast(operand_129)];
                    };

                    const value_1: state_type_112 = (state_102).result;
                    const value_2: u64 = value_6;

                    const value_7: state_type_112 = block_127: {
                        const operand_118 = ((value_1).count + @as(u64, 1));

                        const operand_122 = ((((value_1).total + (value_1).count) + value_2) + @as(u64, (block_121: {
                            const operand_119 = (value_1).labels;
                            const operand_120 = @as(u64, 0);

                            if ((operand_120 >= (operand_119).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_121 (operand_119)[@intCast(operand_120)];
                        }).len));

                        const operand_123 = (value_1).count;
                        const operand_124 = (value_1).labels;
                        const operand_125 = (value_1).text;
                        const operand_126 = (value_1).child;

                        break :block_127 state_type_112{ .count = operand_118, .total = operand_122, .last = operand_123, .labels = operand_124, .text = operand_125, .child = operand_126, };
                    };

                    break :block_131 block_117: {
                        const operand_114 = (state_102).source;
                        const operand_115 = ((state_102).index + @as(u64, 1));
                        const operand_116 = value_7;

                        break :block_117 state_type_113{ .index = operand_115, .result = operand_116, .source = operand_114, };
                    };
                };

                state_changed_110 = true;
            }

            break :block_139 (if (state_changed_110) block_138: {
                const operand_137 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_137).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_102).index, .result = block_136: {
                    const operand_135 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_135).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_134: {
                        const operand_133 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_133).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_102).result).child).value, });

                        break :block_134 @as(*const (zx_abi).zx_type_11, operand_133);
                    }, .count = ((state_102).result).count, .labels = ((state_102).result).labels, .last = ((state_102).result).last, .text = ((state_102).result).text, .total = ((state_102).result).total, });

                    break :block_136 @as(*const (zx_abi).zx_type_13, operand_135);
                }, .source = (state_102).source, });

                break :block_138 @as(*const (zx_abi).zx_type_16, operand_137);
            } else operand_109);
        };

        break :block_140 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_39: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_38: {
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

            const state_type_10 = struct {
                value: u64,
            };
            const state_type_11 = struct {
                child: state_type_10,
                count: u64,
                labels: []const []const u8,
                last: u64,
                text: []const u8,
                total: u64,
            };
            const state_type_12 = struct {
                index: u64,
                result: state_type_11,
                source: []const u64,
            };

            var state_1: state_type_12 = state_type_12{ .index = (operand_8).index, .result = state_type_11{ .child = state_type_10{ .value = (((operand_8).result).child).value, }, .count = ((operand_8).result).count, .labels = ((operand_8).result).labels, .last = ((operand_8).result).last, .text = ((operand_8).result).text, .total = ((operand_8).result).total, }, .source = (operand_8).source, };
            var state_changed_9 = false;

            while (((state_1).index < @as(u64, ((state_1).source).len))) {
                state_1 = block_30: {
                    const value_6: u64 = block_29: {
                        const operand_27 = (state_1).source;
                        const operand_28 = (state_1).index;

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    };

                    const value_1: state_type_11 = (state_1).result;
                    const value_2: u64 = value_6;
                    const value_7: state_type_11 = block_26: {
                        const operand_17 = ((value_1).count + @as(u64, 1));

                        const operand_21 = ((((value_1).total + (value_1).count) + value_2) + @as(u64, (block_20: {
                            const operand_18 = (value_1).labels;
                            const operand_19 = @as(u64, 0);

                            if ((operand_19 >= (operand_18).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_20 (operand_18)[@intCast(operand_19)];
                        }).len));

                        const operand_22 = (value_1).count;
                        const operand_23 = (value_1).labels;
                        const operand_24 = (value_1).text;
                        const operand_25 = (value_1).child;

                        break :block_26 state_type_11{ .count = operand_17, .total = operand_21, .last = operand_22, .labels = operand_23, .text = operand_24, .child = operand_25, };
                    };

                    break :block_30 block_16: {
                        const operand_13 = (state_1).source;
                        const operand_14 = ((state_1).index + @as(u64, 1));
                        const operand_15 = value_7;

                        break :block_16 state_type_12{ .index = operand_14, .result = operand_15, .source = operand_13, };
                    };
                };

                state_changed_9 = true;
            }

            break :block_38 (if (state_changed_9) block_37: {
                const operand_36 = (try (allocator).create((zx_abi).zx_type_16));

                (operand_36).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = (state_1).index, .result = block_35: {
                    const operand_34 = (try (allocator).create((zx_abi).zx_type_13));

                    (operand_34).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .child = block_33: {
                        const operand_32 = (try (allocator).create((zx_abi).zx_type_11));

                        (operand_32).* = @as((zx_abi).zx_type_11, (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, });

                        break :block_33 @as(*const (zx_abi).zx_type_11, operand_32);
                    }, .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, });

                    break :block_35 @as(*const (zx_abi).zx_type_13, operand_34);
                }, .source = (state_1).source, });

                break :block_37 @as(*const (zx_abi).zx_type_16, operand_36);
            } else operand_8);
        };

        break :block_39 (value_8).result;
    };
}

