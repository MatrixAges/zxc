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

    return block_37: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_36: {
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
                state_1 = block_28: {
                    const value_6: u64 = block_27: {
                        const operand_25 = (state_1).source;
                        const operand_26 = (state_1).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_24: {
                        break :block_24 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_23: {
                        const operand_14 = value_1;
                        const operand_15 = ((value_1).count + @as(u64, 1));

                        const operand_16 = (((value_1).total + (value_1).count) + block_17: {
                            break :block_17 value_2;
                        });

                        const operand_18 = (value_1).count;

                        const operand_19 = block_22: {
                            const operand_20 = (((value_1).child).value + block_21: {
                                break :block_21 value_2;
                            });

                            break :block_22 @as((zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744, (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = operand_20, });
                        };

                        break :block_23 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = operand_19, .count = operand_15, .labels = (operand_14).labels, .last = operand_18, .text = (operand_14).text, .total = operand_16, });
                    };

                    break :block_28 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_36 (if (state_changed_9) block_35: {
                break :block_35 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_34: {
                    const operand_33 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_33).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_32: {
                        const operand_31 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_31).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_30: {
                            const operand_29 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_29).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_30 @as(*const (zx_abi).zx_type_11, operand_29);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_32 @as(*const (zx_abi).zx_type_13, operand_31);
                    }), .source = (state_1).source, };

                    break :block_34 @as(*const (zx_abi).zx_type_16, operand_33);
                });
            } else operand_8);
        };

        break :block_37 (value_8).result;
    };
}

fn function_0_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_15_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_67: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_66: {
            const operand_44 = block_43: {
                const operand_39 = block_40: {
                    break :block_40 value_3;
                };

                const operand_41 = @as(u64, 0);
                const operand_42 = (in).seed;

                break :block_43 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_41, .result = operand_42, .source = operand_39, });
            };

            var state_38: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_44;
            var state_changed_45 = false;

            while (((state_38).index < @as(u64, ((state_38).source).len))) {
                state_38 = block_64: {
                    const value_6: u64 = block_63: {
                        const operand_61 = (state_38).source;
                        const operand_62 = (state_38).index;

                        if ((operand_62 >= (operand_61).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_63 (operand_61)[@intCast(operand_62)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_38).result;

                    const value_2: u64 = block_60: {
                        break :block_60 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_59: {
                        const operand_50 = value_1;
                        const operand_51 = ((value_1).count + @as(u64, 1));

                        const operand_52 = (((value_1).total + (value_1).count) + block_53: {
                            break :block_53 value_2;
                        });

                        const operand_54 = (value_1).count;

                        const operand_55 = block_58: {
                            const operand_56 = (((value_1).child).value + block_57: {
                                break :block_57 value_2;
                            });

                            break :block_58 @as((zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744, (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = operand_56, });
                        };

                        break :block_59 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = operand_55, .count = operand_51, .labels = (operand_50).labels, .last = operand_54, .text = (operand_50).text, .total = operand_52, });
                    };

                    break :block_64 block_49: {
                        const operand_46 = (state_38).source;
                        const operand_47 = ((state_38).index + @as(u64, 1));
                        const operand_48 = value_7;

                        break :block_49 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_47, .result = operand_48, .source = operand_46, });
                    };
                };

                state_changed_45 = true;
            }

            break :block_66 (if (state_changed_45) state_38 else operand_44);
        };

        break :block_67 (value_8).result;
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

    return block_97: {
        const value_3: []const u64 = (in).steps;

        const value_8: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = block_96: {
            const operand_74 = block_73: {
                const operand_69 = block_70: {
                    break :block_70 value_3;
                };

                const operand_71 = @as(u64, 0);
                const operand_72 = (in).seed;

                break :block_73 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_71, .result = operand_72, .source = operand_69, });
            };

            var state_68: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = operand_74;
            var state_changed_75 = false;

            while (((state_68).index < @as(u64, ((state_68).source).len))) {
                state_68 = block_94: {
                    const value_6: u64 = block_93: {
                        const operand_91 = (state_68).source;
                        const operand_92 = (state_68).index;

                        if ((operand_92 >= (operand_91).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_93 (operand_91)[@intCast(operand_92)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_68).result;

                    const value_2: u64 = block_90: {
                        break :block_90 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_89: {
                        const operand_80 = value_1;
                        const operand_81 = ((value_1).count + @as(u64, 1));

                        const operand_82 = (((value_1).total + (value_1).count) + block_83: {
                            break :block_83 value_2;
                        });

                        const operand_84 = (value_1).count;

                        const operand_85 = block_88: {
                            const operand_86 = (((value_1).child).value + block_87: {
                                break :block_87 value_2;
                            });

                            break :block_88 @as((zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744, (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = operand_86, });
                        };

                        break :block_89 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = operand_85, .count = operand_81, .labels = (operand_80).labels, .last = operand_84, .text = (operand_80).text, .total = operand_82, });
                    };

                    break :block_94 block_79: {
                        const operand_76 = (state_68).source;
                        const operand_77 = ((state_68).index + @as(u64, 1));
                        const operand_78 = value_7;

                        break :block_79 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_77, .result = operand_78, .source = operand_76, });
                    };
                };

                state_changed_75 = true;
            }

            break :block_96 (if (state_changed_75) state_68 else operand_74);
        };

        break :block_97 (value_8).result;
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

    return block_134: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_133: {
            const operand_105 = block_104: {
                const operand_99 = value_3;
                const operand_100 = @as(u64, 0);
                const operand_101 = (in).seed;

                break :block_104 block_103: {
                    const operand_102 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_102).* = @as((zx_abi).zx_type_16, (zx_abi).zx_type_16{ .index = operand_100, .result = operand_101, .source = operand_99, });

                    break :block_103 @as(*const (zx_abi).zx_type_16, operand_102);
                };
            };

            var state_98: (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = (operand_105).index, .result = (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = (((operand_105).result).child).value, .zx_origin = ((operand_105).result).child, }, .count = ((operand_105).result).count, .labels = ((operand_105).result).labels, .last = ((operand_105).result).last, .text = ((operand_105).result).text, .total = ((operand_105).result).total, .zx_origin = (operand_105).result, }, .source = (operand_105).source, .zx_origin = operand_105, };
            var state_changed_106 = false;

            while (((state_98).index < @as(u64, ((state_98).source).len))) {
                state_98 = block_125: {
                    const value_6: u64 = block_124: {
                        const operand_122 = (state_98).source;
                        const operand_123 = (state_98).index;

                        if ((operand_123 >= (operand_122).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_124 (operand_122)[@intCast(operand_123)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_98).result;

                    const value_2: u64 = block_121: {
                        break :block_121 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_120: {
                        const operand_111 = value_1;
                        const operand_112 = ((value_1).count + @as(u64, 1));

                        const operand_113 = (((value_1).total + (value_1).count) + block_114: {
                            break :block_114 value_2;
                        });

                        const operand_115 = (value_1).count;

                        const operand_116 = block_119: {
                            const operand_117 = (((value_1).child).value + block_118: {
                                break :block_118 value_2;
                            });

                            break :block_119 @as((zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744, (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = operand_117, });
                        };

                        break :block_120 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = operand_116, .count = operand_112, .labels = (operand_111).labels, .last = operand_115, .text = (operand_111).text, .total = operand_113, });
                    };

                    break :block_125 block_110: {
                        const operand_107 = (state_98).source;
                        const operand_108 = ((state_98).index + @as(u64, 1));
                        const operand_109 = value_7;

                        break :block_110 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_108, .result = operand_109, .source = operand_107, });
                    };
                };

                state_changed_106 = true;
            }

            break :block_133 (if (state_changed_106) block_132: {
                break :block_132 (if (((state_98).zx_origin != null)) (state_98).zx_origin.? else block_131: {
                    const operand_130 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_130).* = (zx_abi).zx_type_16{ .index = (state_98).index, .result = (if ((((state_98).result).zx_origin != null)) ((state_98).result).zx_origin.? else block_129: {
                        const operand_128 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_128).* = (zx_abi).zx_type_13{ .child = (if (((((state_98).result).child).zx_origin != null)) (((state_98).result).child).zx_origin.? else block_127: {
                            const operand_126 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_126).* = (zx_abi).zx_type_11{ .value = (((state_98).result).child).value, };

                            break :block_127 @as(*const (zx_abi).zx_type_11, operand_126);
                        }), .count = ((state_98).result).count, .labels = ((state_98).result).labels, .last = ((state_98).result).last, .text = ((state_98).result).text, .total = ((state_98).result).total, };

                        break :block_129 @as(*const (zx_abi).zx_type_13, operand_128);
                    }), .source = (state_98).source, };

                    break :block_131 @as(*const (zx_abi).zx_type_16, operand_130);
                });
            } else operand_105);
        };

        break :block_134 (value_8).result;
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_15) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    return block_37: {
        const value_3: []const u64 = (in).steps;

        const value_8: *const (zx_abi).zx_type_16 = block_36: {
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
                state_1 = block_28: {
                    const value_6: u64 = block_27: {
                        const operand_25 = (state_1).source;
                        const operand_26 = (state_1).index;

                        if ((operand_26 >= (operand_25).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_27 (operand_25)[@intCast(operand_26)];
                    };

                    const value_1: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = (state_1).result;

                    const value_2: u64 = block_24: {
                        break :block_24 value_6;
                    };
                    const value_7: (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = block_23: {
                        const operand_14 = value_1;
                        const operand_15 = ((value_1).count + @as(u64, 1));

                        const operand_16 = (((value_1).total + (value_1).count) + block_17: {
                            break :block_17 value_2;
                        });

                        const operand_18 = (value_1).count;

                        const operand_19 = block_22: {
                            const operand_20 = (((value_1).child).value + block_21: {
                                break :block_21 value_2;
                            });

                            break :block_22 @as((zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744, (zx_abi).value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744{ .value = operand_20, });
                        };

                        break :block_23 @as((zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2, (zx_abi).value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2{ .child = operand_19, .count = operand_15, .labels = (operand_14).labels, .last = operand_18, .text = (operand_14).text, .total = operand_16, });
                    };

                    break :block_28 block_13: {
                        const operand_10 = (state_1).source;
                        const operand_11 = ((state_1).index + @as(u64, 1));
                        const operand_12 = value_7;

                        break :block_13 @as((zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64, (zx_abi).value_zx_type_16_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                };

                state_changed_9 = true;
            }

            break :block_36 (if (state_changed_9) block_35: {
                break :block_35 (if (((state_1).zx_origin != null)) (state_1).zx_origin.? else block_34: {
                    const operand_33 = (try (allocator).create((zx_abi).zx_type_16));

                    (operand_33).* = (zx_abi).zx_type_16{ .index = (state_1).index, .result = (if ((((state_1).result).zx_origin != null)) ((state_1).result).zx_origin.? else block_32: {
                        const operand_31 = (try (allocator).create((zx_abi).zx_type_13));

                        (operand_31).* = (zx_abi).zx_type_13{ .child = (if (((((state_1).result).child).zx_origin != null)) (((state_1).result).child).zx_origin.? else block_30: {
                            const operand_29 = (try (allocator).create((zx_abi).zx_type_11));

                            (operand_29).* = (zx_abi).zx_type_11{ .value = (((state_1).result).child).value, };

                            break :block_30 @as(*const (zx_abi).zx_type_11, operand_29);
                        }), .count = ((state_1).result).count, .labels = ((state_1).result).labels, .last = ((state_1).result).last, .text = ((state_1).result).text, .total = ((state_1).result).total, };

                        break :block_32 @as(*const (zx_abi).zx_type_13, operand_31);
                    }), .source = (state_1).source, };

                    break :block_34 @as(*const (zx_abi).zx_type_16, operand_33);
                });
            } else operand_8);
        };

        break :block_37 (value_8).result;
    };
}

