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

    return block_44: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_43: {
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
                state_1 = block_35: {
                    const value_6: u64 = block_34: {
                        const operand_32 = (state_1).source;
                        const operand_33 = (state_1).index;

                        if ((operand_33 >= (operand_32).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_34 (operand_32)[@intCast(operand_33)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_31: {
                        break :block_31 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_30: {
                        const operand_15 = @rem(block_14: {
                            break :block_14 value_2;
                        }, @as(u64, 3));

                        break :block_30 (if ((operand_15 == @as(u64, 0))) value_1 else (if ((operand_15 == @as(u64, 1))) block_29: {
                            const operand_24 = value_1;
                            const operand_25 = ((value_1).count + @as(u64, 1));

                            const operand_26 = (((value_1).total + (value_1).count) + block_27: {
                                break :block_27 value_2;
                            });

                            const operand_28 = (value_1).count;

                            break :block_29 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_24).child, .count = operand_25, .labels = (operand_24).labels, .last = operand_28, .text = (operand_24).text, .total = operand_26, });
                        } else block_23: {
                            const operand_16 = ((value_1).count + @as(u64, 2));

                            const operand_17 = ((((value_1).total + (value_1).count) + block_18: {
                                break :block_18 value_2;
                            }) + @as(u64, 10));

                            const operand_19 = (value_1).count;
                            const operand_20 = (value_1).labels;
                            const operand_21 = (value_1).text;
                            const operand_22 = (value_1).child;

                            break :block_23 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_16, .total = operand_17, .last = operand_19, .labels = operand_20, .text = operand_21, .child = operand_22, });
                        }));
                    };

                    break :block_35 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_43 (if (state_changed_9) block_42: {
                break :block_42 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_41: {
                    const operand_40 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_40).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_39: {
                        const operand_38 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_38).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_37: {
                            const operand_36 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_36).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_37 @as(*const (zx_abi).zx_type_11, operand_36);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_39 @as(*const (zx_abi).zx_type_13, operand_38);
                    }), .source = (state_1).source, };

                    break :block_41 @as(*const (zx_abi).zx_type_16, operand_40);
                });
            } else operand_8);
        };

        break :block_44 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_81: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_80: {
            const operand_51 = block_50: {
                const operand_46 = block_47: {
                    break :block_47 value_3;
                };

                const operand_48 = @as(u64, 0);
                const operand_49 = (in).seed;

                break :block_50 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_48, .result = operand_49, .source = operand_46, });
            };

            var state_45: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_51;
            var state_changed_52 = false;

            while (((state_45).index < @as(u64, ((state_45).source).len))) {
                state_45 = block_78: {
                    const value_6: u64 = block_77: {
                        const operand_75 = (state_45).source;
                        const operand_76 = (state_45).index;

                        if ((operand_76 >= (operand_75).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_77 (operand_75)[@intCast(operand_76)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_45).result;

                    const value_2: u64 = block_74: {
                        break :block_74 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_73: {
                        const operand_58 = @rem(block_57: {
                            break :block_57 value_2;
                        }, @as(u64, 3));

                        break :block_73 (if ((operand_58 == @as(u64, 0))) value_1 else (if ((operand_58 == @as(u64, 1))) block_72: {
                            const operand_67 = value_1;
                            const operand_68 = ((value_1).count + @as(u64, 1));

                            const operand_69 = (((value_1).total + (value_1).count) + block_70: {
                                break :block_70 value_2;
                            });

                            const operand_71 = (value_1).count;

                            break :block_72 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_67).child, .count = operand_68, .labels = (operand_67).labels, .last = operand_71, .text = (operand_67).text, .total = operand_69, });
                        } else block_66: {
                            const operand_59 = ((value_1).count + @as(u64, 2));

                            const operand_60 = ((((value_1).total + (value_1).count) + block_61: {
                                break :block_61 value_2;
                            }) + @as(u64, 10));

                            const operand_62 = (value_1).count;
                            const operand_63 = (value_1).labels;
                            const operand_64 = (value_1).text;
                            const operand_65 = (value_1).child;

                            break :block_66 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_59, .total = operand_60, .last = operand_62, .labels = operand_63, .text = operand_64, .child = operand_65, });
                        }));
                    };

                    break :block_78 block_56: {
                        const operand_53 = (state_45).source;
                        const operand_54 = ((state_45).index + @as(u64, 1));
                        const operand_55 = value_7;

                        break :block_56 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_54, .result = operand_55, .source = operand_53, });
                    };
                };

                state_changed_52 = true;
            }

            break :block_80 (if (state_changed_52) state_45 else operand_51);
        };

        break :block_81 (value_8).result;
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

    return block_118: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_117: {
            const operand_88 = block_87: {
                const operand_83 = block_84: {
                    break :block_84 value_3;
                };

                const operand_85 = @as(u64, 0);
                const operand_86 = (in).seed;

                break :block_87 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_85, .result = operand_86, .source = operand_83, });
            };

            var state_82: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_88;
            var state_changed_89 = false;

            while (((state_82).index < @as(u64, ((state_82).source).len))) {
                state_82 = block_115: {
                    const value_6: u64 = block_114: {
                        const operand_112 = (state_82).source;
                        const operand_113 = (state_82).index;

                        if ((operand_113 >= (operand_112).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_114 (operand_112)[@intCast(operand_113)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_82).result;

                    const value_2: u64 = block_111: {
                        break :block_111 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_110: {
                        const operand_95 = @rem(block_94: {
                            break :block_94 value_2;
                        }, @as(u64, 3));

                        break :block_110 (if ((operand_95 == @as(u64, 0))) value_1 else (if ((operand_95 == @as(u64, 1))) block_109: {
                            const operand_104 = value_1;
                            const operand_105 = ((value_1).count + @as(u64, 1));

                            const operand_106 = (((value_1).total + (value_1).count) + block_107: {
                                break :block_107 value_2;
                            });

                            const operand_108 = (value_1).count;

                            break :block_109 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_104).child, .count = operand_105, .labels = (operand_104).labels, .last = operand_108, .text = (operand_104).text, .total = operand_106, });
                        } else block_103: {
                            const operand_96 = ((value_1).count + @as(u64, 2));

                            const operand_97 = ((((value_1).total + (value_1).count) + block_98: {
                                break :block_98 value_2;
                            }) + @as(u64, 10));

                            const operand_99 = (value_1).count;
                            const operand_100 = (value_1).labels;
                            const operand_101 = (value_1).text;
                            const operand_102 = (value_1).child;

                            break :block_103 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_96, .total = operand_97, .last = operand_99, .labels = operand_100, .text = operand_101, .child = operand_102, });
                        }));
                    };

                    break :block_115 block_93: {
                        const operand_90 = (state_82).source;
                        const operand_91 = ((state_82).index + @as(u64, 1));
                        const operand_92 = value_7;

                        break :block_93 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_91, .result = operand_92, .source = operand_90, });
                    };
                };

                state_changed_89 = true;
            }

            break :block_117 (if (state_changed_89) state_82 else operand_88);
        };

        break :block_118 (value_8).result;
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

    return block_162: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_161: {
            const operand_126 = block_125: {
                const operand_120 = value_3;
                const operand_121 = @as(u64, 0);
                const operand_122 = (in).seed;

                break :block_125 block_124: {
                    const operand_123 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_123).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_121, .result = operand_122, .source = operand_120, });

                    break :block_124 @as(*const (zx_abi).zx_type_16, operand_123);
                };
            };

            var state_119: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_126).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_126).result).child).value, .zx_origin = ((operand_126).result).child, }, .count = ((operand_126).result).count, .labels = ((operand_126).result).labels, .last = ((operand_126).result).last, .text = ((operand_126).result).text, .total = ((operand_126).result).total, .zx_origin = (operand_126).result, }, .source = (operand_126).source, .zx_origin = operand_126, };
            var state_changed_127 = false;

            while (((state_119).index < @as(u64, ((state_119).source).len))) {
                state_119 = block_153: {
                    const value_6: u64 = block_152: {
                        const operand_150 = (state_119).source;
                        const operand_151 = (state_119).index;

                        if ((operand_151 >= (operand_150).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_152 (operand_150)[@intCast(operand_151)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_119).result;

                    const value_2: u64 = block_149: {
                        break :block_149 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_148: {
                        const operand_133 = @rem(block_132: {
                            break :block_132 value_2;
                        }, @as(u64, 3));

                        break :block_148 (if ((operand_133 == @as(u64, 0))) value_1 else (if ((operand_133 == @as(u64, 1))) block_147: {
                            const operand_142 = value_1;
                            const operand_143 = ((value_1).count + @as(u64, 1));

                            const operand_144 = (((value_1).total + (value_1).count) + block_145: {
                                break :block_145 value_2;
                            });

                            const operand_146 = (value_1).count;

                            break :block_147 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_142).child, .count = operand_143, .labels = (operand_142).labels, .last = operand_146, .text = (operand_142).text, .total = operand_144, });
                        } else block_141: {
                            const operand_134 = ((value_1).count + @as(u64, 2));

                            const operand_135 = ((((value_1).total + (value_1).count) + block_136: {
                                break :block_136 value_2;
                            }) + @as(u64, 10));

                            const operand_137 = (value_1).count;
                            const operand_138 = (value_1).labels;
                            const operand_139 = (value_1).text;
                            const operand_140 = (value_1).child;

                            break :block_141 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_134, .total = operand_135, .last = operand_137, .labels = operand_138, .text = operand_139, .child = operand_140, });
                        }));
                    };

                    break :block_153 block_131: {
                        const operand_128 = (state_119).source;
                        const operand_129 = ((state_119).index + @as(u64, 1));
                        const operand_130 = value_7;

                        break :block_131 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_129, .result = operand_130, .source = operand_128, });
                    };
                };

                state_changed_127 = true;
            }

            break :block_161 (if (state_changed_127) block_160: {
                break :block_160 (if (((state_119).zx_origin != null)) (state_119).zx_origin.? else block_159: {
                    const operand_158 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_158).* = (zx_abi).zx_type_16{ .index = (state_119).index, .result = (if ((((state_119).result).zx_origin != null)) ((state_119).result).zx_origin.? else block_157: {
                        const operand_156 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_156).* = (zx_abi).zx_type_13{ .child = (if (((((state_119).result).child).zx_origin != null)) (((state_119).result).child).zx_origin.? else block_155: {
                            const operand_154 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_154).* = (zx_abi).zx_type_11{ .value = (((state_119).result).child).value, };

                            break :block_155 @as(*const (zx_abi).zx_type_11, operand_154);
                        }), .count = ((state_119).result).count, .labels = ((state_119).result).labels, .last = ((state_119).result).last, .text = ((state_119).result).text, .total = ((state_119).result).total, };

                        break :block_157 @as(*const (zx_abi).zx_type_13, operand_156);
                    }), .source = (state_119).source, };

                    break :block_159 @as(*const (zx_abi).zx_type_16, operand_158);
                });
            } else operand_126);
        };

        break :block_162 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_44: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_43: {
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
                state_1 = block_35: {
                    const value_6: u64 = block_34: {
                        const operand_32 = (state_1).source;
                        const operand_33 = (state_1).index;

                        if ((operand_33 >= (operand_32).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_34 (operand_32)[@intCast(operand_33)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_31: {
                        break :block_31 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_30: {
                        const operand_15 = @rem(block_14: {
                            break :block_14 value_2;
                        }, @as(u64, 3));

                        break :block_30 (if ((operand_15 == @as(u64, 0))) value_1 else (if ((operand_15 == @as(u64, 1))) block_29: {
                            const operand_24 = value_1;
                            const operand_25 = ((value_1).count + @as(u64, 1));

                            const operand_26 = (((value_1).total + (value_1).count) + block_27: {
                                break :block_27 value_2;
                            });

                            const operand_28 = (value_1).count;

                            break :block_29 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (operand_24).child, .count = operand_25, .labels = (operand_24).labels, .last = operand_28, .text = (operand_24).text, .total = operand_26, });
                        } else block_23: {
                            const operand_16 = ((value_1).count + @as(u64, 2));

                            const operand_17 = ((((value_1).total + (value_1).count) + block_18: {
                                break :block_18 value_2;
                            }) + @as(u64, 10));

                            const operand_19 = (value_1).count;
                            const operand_20 = (value_1).labels;
                            const operand_21 = (value_1).text;
                            const operand_22 = (value_1).child;

                            break :block_23 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .count = operand_16, .total = operand_17, .last = operand_19, .labels = operand_20, .text = operand_21, .child = operand_22, });
                        }));
                    };

                    break :block_35 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_43 (if (state_changed_9) block_42: {
                break :block_42 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_41: {
                    const operand_40 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_40).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_39: {
                        const operand_38 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_38).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_37: {
                            const operand_36 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_36).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_37 @as(*const (zx_abi).zx_type_11, operand_36);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_39 @as(*const (zx_abi).zx_type_13, operand_38);
                    }), .source = (state_1).source, };

                    break :block_41 @as(*const (zx_abi).zx_type_16, operand_40);
                });
            } else operand_8);
        };

        break :block_44 (value_8).result;
    };
}

